setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("RSQLite", quietly = TRUE)) {
	install.packages("RSQLite", repos="http://cran.us.r-project.org")
}
library(RSQLite)
if (!requireNamespace("glue", quietly = TRUE)) {
	install.packages("glue", repos="http://cran.us.r-project.org")
}
library(glue)
if (!requireNamespace("here", quietly = TRUE)) {
	install.packages("here", repos="http://cran.us.r-project.org")
}
library(here)
if (!requireNamespace("knitr", quietly = TRUE)) {
	install.packages("knitr", repos="http://cran.us.r-project.org")
}
library(knitr)
if (!requireNamespace("optparse", quietly = TRUE)) {
	install.packages("optparse", repos="http://cran.us.r-project.org")
}
library(optparse)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("sp", quietly = TRUE)) {
	install.packages("sp", repos="http://cran.us.r-project.org")
}
library(sp)
if (!requireNamespace("tidyverse", quietly = TRUE)) {
	install.packages("tidyverse", repos="http://cran.us.r-project.org")
}
library(tidyverse)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--occ_A"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--taxa_A"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)
occ_A <- gsub('"', '', opt$occ_A)
taxa_A <- gsub('"', '', opt$taxa_A)



conf_work_dir = '/tmp/data'


conf_work_dir = '/tmp/data'

sqlite_B <- occ_A

occ_B <- file.path(conf_work_dir, "occurrence_b.sqlite")
taxa_B <- file.path(conf_work_dir, "alientaxa_b.sqlite")

lbs <- c("knitr", "optparse", "sp", "tidyverse", "here", "glue", "RSQLite")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)



setwd(conf_work_dir)


table_name <- "occ"


sqlite_occ <- dbConnect(SQLite(), dbname = sqlite_B)


query <- glue_sql("SELECT {`cols`*} FROM {table}",
              cols = c("decimalLatitude", 
                       "decimalLongitude",
                       "coordinateUncertaintyInMeters"),
              table = table_name,
              .con = sqlite_occ
)
geodata_df <- 
  dbGetQuery(sqlite_occ, query) %>%
  as_tibble()


nrow_geodata_df <- nrow(geodata_df)
nrow_geodata_df


geodata_df %>% head(10)


geodata_df %>%
  group_by(coordinateUncertaintyInMeters) %>%
  count() %>%
  arrange(desc(n))


geodata_df %>%
  filter(is.na(coordinateUncertaintyInMeters) | 
           coordinateUncertaintyInMeters == 0) %>%
  count()


geodata_df <- 
  geodata_df %>%
  mutate(coordinateUncertaintyInMeters = if_else(
    is.na(coordinateUncertaintyInMeters) | coordinateUncertaintyInMeters == 0,
    1000.0,
    as.double(coordinateUncertaintyInMeters)
  ))


query <- glue_sql(
  "PRAGMA synchronous = OFF",
  .con = sqlite_occ
)
dbExecute(sqlite_occ, query)

dbBegin(sqlite_occ)
query <- glue_sql(
            "UPDATE {table} SET {`column`} = 1000 WHERE 
            {`column`} = '' OR {`column`} = '0.0'",
            table = table_name,
            column = "coordinateUncertaintyInMeters",
            .con = sqlite_occ)
dbExecute(sqlite_occ, query)
dbCommit(sqlite_occ)


query <- glue_sql("SELECT {`column`} FROM {table}",
              table = table_name,
              column = "coordinateUncertaintyInMeters",
              .con = sqlite_occ
)
uncertainty_df <- 
  dbGetQuery(sqlite_occ, query) %>%
  as_tibble()
uncertainty_df %>%
  filter(is.na(coordinateUncertaintyInMeters) | 
           coordinateUncertaintyInMeters == 0) %>%
  count()


temp_file_coords <- "coordinates_and_uncertainty_epsg_4326.tsv"
col_names_geodata_df <- names(geodata_df)
write_tsv(geodata_df, temp_file_coords, na = "")
remove(geodata_df)


reproject_assign <- function(df, pos){
  
  nrow_df <- nrow(df)
  coordinates(df) <- ~decimalLongitude+decimalLatitude
  proj4string(df) <- CRS("+init=epsg:4326")
  df <- spTransform(df, CRS("+init=epsg:3035"))
  colnames(df@coords) <- c("x", "y")
  
  df@data <-
    df@data %>%
    mutate(random_angle = runif(nrow_df, 0, 2*pi))
  df@data <-
    df@data %>%
    mutate(random_r = sqrt(runif(
      nrow_df, 0, 1)) * coordinateUncertaintyInMeters)
  df@data <-
  df@data %>%
    mutate(x = df@coords[, "x"],
           y = df@coords[, "y"])
  df@data <-
    df@data %>%
    mutate(x = x + random_r * cos(random_angle),
           y = y + random_r * sin(random_angle)) %>%
    select(-c(random_angle, random_r))
  
  df@data <-
    df@data %>%
    mutate(eea_cell_code = paste0(floor(x/1000)*100000 + floor(y/1000))) %>%
    select(x, y, coordinateUncertaintyInMeters, eea_cell_code)
  return(df@data)
}


chunk_size <- 1000000
geodata_df <- read_tsv_chunked(
  file = temp_file_coords, 
  callback = DataFrameCallback$new(reproject_assign), 
  chunk_size = chunk_size,
  col_types = cols(.default = col_double()),
  na = ""
)


geodata_df %>% head(n = 10)


file.remove(temp_file_coords)


new_col <- "eea_cell_code"
query <- glue_sql("ALTER TABLE {table} ADD COLUMN {colname} {type}",
                  table = table_name,
                  colname = new_col,
                  type = "CHARACTER",
                  .con = sqlite_occ
)
dbExecute(sqlite_occ, query)


dbBegin(sqlite_occ)
dbExecute(
  sqlite_occ,
  glue_sql(
    "UPDATE {table} SET {`column`} = :eea_cell_code WHERE _ROWID_ = :id",
    table = table_name,
    column = new_col,
    .con = sqlite_occ),
  params = data.frame(
  eea_cell_code = geodata_df$eea_cell_code,
  id = rownames(geodata_df))
)
dbCommit(sqlite_occ)


query <- glue_sql("SELECT * FROM {table} WHERE _ROWID_ <= 10",
                  table = table_name,
                  .con = sqlite_occ)
dbGetQuery(sqlite_occ, query)


dbDisconnect(sqlite_occ)



# capturing outputs
file <- file(paste0('/tmp/occ_B_', id, '.json'))
writeLines(toJSON(occ_B, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/taxa_B_', id, '.json'))
writeLines(toJSON(taxa_B, auto_unbox=TRUE), file)
close(file)
