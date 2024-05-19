setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("RSQLite", quietly = TRUE)) {
	install.packages("RSQLite", repos="http://cran.us.r-project.org")
}
library(RSQLite)
if (!requireNamespace("base", quietly = TRUE)) {
	install.packages("base", repos="http://cran.us.r-project.org")
}
library(base)
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
if (!requireNamespace("rgbif", quietly = TRUE)) {
	install.packages("rgbif", repos="http://cran.us.r-project.org")
}
library(rgbif)
if (!requireNamespace("tidyverse", quietly = TRUE)) {
	install.packages("tidyverse", repos="http://cran.us.r-project.org")
}
library(tidyverse)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--syntax_out"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)
syntax_out <- gsub('"', '', opt$syntax_out)



conf_work_dir = '/tmp/data'


conf_work_dir = '/tmp/data'

zip_file <- syntax_out

occ_A <- file.path(conf_work_dir, "occurrence_b.sqlite")
taxa_A <- file.path(conf_work_dir, "alientaxa_b.sqlite")

lbs <- c("knitr", "optparse", "base", "tidyverse","rgbif", "here", "glue", "RSQLite")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)



setwd(conf_work_dir)

decompress_file <- function(directory, file, extr_file) {
      decompression <-
        system2("unzip",
                args = c("-d", 
                         directory,
                         file,
                         extr_file),
                stdout = TRUE,
                stderr = TRUE)
      print(decompression)
}

wd <- getwd()

decompress_file(wd, here::here(zip_file),"occurrence.txt")
decompress_file(wd, here::here(zip_file),"alientaxa.txt")




cols_occ_file <- read_delim("occurrence.txt", "\t", n_max = 1, quote = "")
cols_occ_file <- names(cols_occ_file)
cols_occ_file

cols_taxa_file <- read_delim("alientaxa.txt","\t", n_max = 1, quote= "")
cols_taxa_file <- names(cols_taxa_file)
cols_taxa_file

length(cols_occ_file)
length(cols_taxa_file)

table_name <- "occ_all"
taxa_table_name <- "taxa_all"

field_types <- rep("TEXT", length(cols_occ_file))
names(field_types) <- cols_occ_file

taxa_field_types <- rep("TEXT", length(cols_taxa_file))
names(taxa_field_types) <- cols_taxa_file

int_fields <- names(field_types)[str_detect(names(field_types), "Key") & 
                                   names(field_types) != "datasetKey"]
int_fields <- c(
  int_fields,
  names(field_types)[str_detect(names(field_types), "DayOfYear")],
  names(field_types)[names(field_types) == "year"],
  names(field_types)[names(field_types) == "month"],
  names(field_types)[names(field_types) == "day"]
)
field_types[which(names(field_types) %in% int_fields)] <- "INTEGER"


taxa_int_fields <- names(taxa_field_types)[str_detect(names(taxa_field_types), "Key") & 
                                   names(taxa_field_types) != "datasetKey"]
taxa_field_types[which(names(taxa_field_types) %in% taxa_int_fields)] <- "INTEGER"

real_fields <- names(field_types)[str_detect(names(field_types), "decimal")]
real_fields <- c(
  real_fields,
  names(field_types)[str_detect(names(field_types), "coordinate")],
  names(field_types)[names(field_types) == "pointRadiusSpatialFit"]
)
field_types[which(names(field_types) %in% real_fields)] <- "REAL"


sqlite_occ <- dbConnect(SQLite(), dbname = "occurrence_b.sqlite")
sqlite_taxa <- dbConnect(SQLite(), dbname = "alientaxa_b.sqlite")

if (!table_name %in% dbListTables(sqlite_occ)) {
  dbWriteTable(
    conn = sqlite_occ,
    name = table_name,
    sep = "\t",
    value = "occurrence.txt",
    row.names = FALSE,
    header = TRUE,
    field.types = field_types,
    overwrite = TRUE
  )
}

if (!taxa_table_name %in% dbListTables(sqlite_taxa)) {
  dbWriteTable(
    conn = sqlite_taxa,
    name = taxa_table_name,
    sep = "\t",
    value = "alientaxa.txt",
    row.names = FALSE,
    header = TRUE,
    field.types = taxa_field_types,
    overwrite = TRUE
  )
}

cols_occ_db <- dbListFields(sqlite_occ, table_name)
length(cols_occ_db)

cols_taxa_db <- dbListFields(sqlite_taxa,taxa_table_name)
length(cols_taxa_db)

cols_to_use <- c(
  "gbifID", "scientificName", "kingdom", "phylum", "class", "order", "family",
  "genus", "specificEpithet", "infraspecificEpithet", "taxonRank", 
  "taxonomicStatus", "datasetKey", "basisOfRecord", "occurrenceStatus",
  "lastInterpreted", "hasCoordinate", "hasGeospatialIssues", "decimalLatitude", "decimalLongitude", "coordinateUncertaintyInMeters",
  "coordinatePrecision", "pointRadiusSpatialFit", "verbatimCoordinateSystem", 
  "verbatimSRS", "eventDate", "startDayOfYear", "endDayOfYear", "year", "month",
  "day", "verbatimEventDate", "samplingProtocol", "samplingEffort", "issue",
  "taxonKey", "acceptedTaxonKey", "kingdomKey", "phylumKey", "classKey", 
  "orderKey", "familyKey", "genusKey", "subgenusKey", "speciesKey", "species"
)


cols_to_use[which(!cols_to_use %in% cols_occ_db)]


cols_to_use <- cols_to_use[which(cols_to_use %in% cols_occ_db)]


length(cols_to_use)


field_types_subset <- field_types[which(names(field_types) %in% cols_to_use)]
field_types_subset


issues_to_discard <- c(
  "ZERO_COORDINATE",
  "COORDINATE_OUT_OF_RANGE", 
  "COORDINATE_INVALID",
  "COUNTRY_COORDINATE_MISMATCH"
)


occurrenceStatus_to_discard <- c(
  "absent",
  "excluded"
)


idx_occStatus_issue <- "idx_occStatus_issue"
query <- glue_sql(
    "PRAGMA index_list({table_name})",
    table_name = table_name,
    .con = sqlite_occ
)
indexes_all <- dbGetQuery(sqlite_occ, query)

if (!idx_occStatus_issue %in% indexes_all$name) {
  query <- glue_sql(
  "CREATE INDEX {`idx`} ON {table_name} ({`cols_idx`*})",
  idx = idx_occStatus_issue,
  table_name = table_name,
  cols_idx = c("occurrenceStatus", "issue"),
  .con = sqlite_occ
  )
  dbExecute(sqlite_occ, query)
}


issues_to_discard <- paste0("\'%", issues_to_discard, "%\'")


issue_condition <- paste("issue NOT LIKE", issues_to_discard, collapse = " AND ")
issue_condition


table_name_subset <- "occ"


if (!table_name_subset %in% dbListTables(sqlite_occ)) {
  dbCreateTable(conn = sqlite_occ,
               name = table_name_subset,
               fields = field_types_subset)
  query <- glue_sql(
  "INSERT INTO {small_table} SELECT {`some_cols`*} FROM {big_table} WHERE 
  occurrenceStatus NOT IN ({bad_status*}) AND ", issue_condition, 
  small_table = table_name_subset,
  some_cols = names(field_types_subset),
  big_table = table_name,
  bad_status = occurrenceStatus_to_discard,
  .con = sqlite_occ
  )
  dbExecute(sqlite_occ, query)
}


table_name_subset %in% dbListTables(sqlite_occ)


dbListFields(sqlite_occ, name = table_name_subset)


idx_occStatus <- "idx_occStatus"
query <- glue_sql(
    "PRAGMA index_list({table_name})",
    table_name = table_name_subset,
    .con = sqlite_occ
)
indexes <- dbGetQuery(sqlite_occ, query)
if (!idx_occStatus %in% indexes$name) {
 query <- glue_sql(
  "CREATE INDEX {idx} ON {table_name} ({cols_idx})",
  idx = idx_occStatus,
  table_name = table_name_subset,
  cols_idx = c("occurrenceStatus"),
  .con = sqlite_occ
  )
 dbExecute(sqlite_occ, query)
}


query <- glue_sql(
    "SELECT DISTINCT occurrenceStatus FROM {table}",
    table = table_name_subset,
    .con = sqlite_occ
  )
dbGetQuery(sqlite_occ, query)


idx_issue <- "idx_issue"
if (!idx_issue %in% indexes$name) {
  query <- glue_sql(
    "CREATE INDEX {idx} ON {table_name} ({cols_idx})",
    idx = idx_issue,
    table_name = table_name_subset,
    cols_idx = c("issue"),
    .con = sqlite_occ
  )
  dbExecute(sqlite_occ, query)
}


query <- glue_sql(
    "SELECT DISTINCT issue FROM {table}",
    table = table_name_subset,
    .con = sqlite_occ
  )
issues_left <- dbGetQuery(sqlite_occ, query)
issues_left


any(map_lgl(issues_to_discard, 
            function(issue) {
              any(str_detect(issues_left$issue, issue))
            }))


query <- glue_sql(
    "PRAGMA index_list({table_name})",
    table_name = table_name_subset,
    .con = sqlite_occ
)
dbGetQuery(sqlite_occ, query)


dbDisconnect(sqlite_occ)
dbDisconnect(sqlite_taxa)



# capturing outputs
file <- file(paste0('/tmp/occ_A_', id, '.json'))
writeLines(toJSON(occ_A, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/taxa_A_', id, '.json'))
writeLines(toJSON(taxa_A, auto_unbox=TRUE), file)
close(file)
