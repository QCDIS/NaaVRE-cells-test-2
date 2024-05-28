setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("RSQL", quietly = TRUE)) {
	install.packages("RSQL", repos="http://cran.us.r-project.org")
}
library(RSQL)
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
make_option(c("--occ_B"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--taxa_B"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)
occ_B <- gsub('"', '', opt$occ_B)
taxa_B <- gsub('"', '', opt$taxa_B)



conf_work_dir = '/tmp/data'


conf_work_dir = '/tmp/data'

sqlite_C <- occ_B
dataset_key_C <- taxa_B

taxa_cube <- file.path(conf_work_dir, "be_alientaxa_cube.csv")
classes_cube <- file.path(conf_work_dir, "be_classes_cube.csv")

lbs <- c("knitr", "optparse", "rgbif", "tidyverse", "here", "glue", "RSQLite", "data.table")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)


setwd(conf_work_dir)

table_name <- "occ"


sqlite_occ <- dbConnect(SQLite(), dbname = sqlite_C)


idx_baseline <- "idx_year_cell_class"
query <- glue_sql(
    "PRAGMA index_list({table_name})",
    table_name = table_name,
    .con = sqlite_occ
)
indexes_all <- dbGetQuery(sqlite_occ, query)

if (!idx_baseline %in% indexes_all$name) {
  query <- glue_sql(
  "CREATE INDEX {`idx`} ON {table_name} ({`cols_idx`*})",
  idx = idx_baseline,
  table_name = table_name,
  cols_idx = c("year", 
               "eea_cell_code", 
               "classKey", 
               "coordinateUncertaintyInMeters"),
  .con = sqlite_occ
  )
  dbExecute(sqlite_occ, query)
}


query <- glue_sql(
  "SELECT {`cols`*}, COUNT(_ROWID_), MIN({`coord_uncertainty`}) FROM {table} GROUP BY {`cols`*}",
  cols = c("year", "eea_cell_code", "classKey"),
  coord_uncertainty = "coordinateUncertaintyInMeters",
  table = table_name,
  .con = sqlite_occ
)
occ_cube_baseline <- 
  dbGetQuery(sqlite_occ, query) %>%
  rename(
    n = "COUNT(_ROWID_)",
    min_coord_uncertainty = "MIN(`coordinateUncertaintyInMeters`)"
)


occ_cube_baseline %>% 
  head()


class_df <- tibble(
  classKey = unique(occ_cube_baseline$classKey))
class_df <- 
  class_df %>%
  mutate(class = map_chr(
    classKey, 
    function(x) {
      taxon = name_usage(x)
      taxon$data %>% pull(scientificName)
      })
  )
class_df



datasetKey <- dataset_key_C

taxa_table_name <- "taxa_all"

sqlite_taxa <- dbConnect(SQLite(), dbname = dataset_key_C)

query <- glue_sql("SELECT {`cols`*} FROM {table}",
              cols = c("taxonID", 
                       "scientificName",
                       "rank",
                       "taxonomicStatus",
                       "nubKey"),
              table = taxa_table_name,
              .con = sqlite_taxa
)

alien_taxa <- 
  dbGetQuery(sqlite_taxa, query) %>%
  as_tibble()

  alien_taxa %>%
  group_by(rank) %>%
  count()


alien_taxa %>%
  group_by(taxonomicStatus) %>%
  count()


alien_taxa_species <- 
  alien_taxa %>%
  filter(rank == "SPECIES", 
         taxonomicStatus %in% c("ACCEPTED", "DOUBTFUL"))
alien_taxa_species %>% head()


alien_taxa_species_key <-
  alien_taxa_species %>% 
  distinct(nubKey) %>% 
  pull(nubKey)

alien_taxa_species_key %>% head()

idx_species_year_cell <- "idx_species_year_cell"
query <- glue_sql(
    "PRAGMA index_list({table_name})",
    table_name = table_name,
    .con = sqlite_occ
)
indexes_all <- dbGetQuery(sqlite_occ, query)

if (!idx_species_year_cell %in% indexes_all$name) {
  query <- glue_sql(
  "CREATE INDEX {`idx`} ON {table_name} ({`cols_idx`*})",
  idx = idx_species_year_cell,
  table_name = table_name,
  cols_idx = c("year", 
               "eea_cell_code", 
               "speciesKey",
               "coordinateUncertaintyInMeters"),
  .con = sqlite_occ
  )
  dbExecute(sqlite_occ, query)
}


query <- glue_sql(
  "SELECT {`cols`*}, COUNT(_ROWID_), MIN({`coord_uncertainty`}) FROM {table} GROUP BY {`cols`*}",
  cols = c("year", 
           "eea_cell_code", 
           "speciesKey"),
  coord_uncertainty = "coordinateUncertaintyInMeters",
  table = table_name,
  .con = sqlite_occ
)
occ_cube_species <- 
  dbGetQuery(sqlite_occ, query) %>%
  rename(
    n = "COUNT(_ROWID_)",
    min_coord_uncertainty = "MIN(`coordinateUncertaintyInMeters`)"
)
occ_cube_species <-
  occ_cube_species %>%
  filter(speciesKey %in% alien_taxa_species_key)


paste(
  length(alien_taxa_species_key[
  which(alien_taxa_species_key %in% unique(occ_cube_species$speciesKey))]),
  "out of",
  length(alien_taxa_species_key)
)


occ_cube_species %>% head()


query <- glue_sql(
  "SELECT DISTINCT {`cols`*} FROM {table}",
  cols = c("speciesKey",
           "taxonKey",
           "scientificName"),
  table = table_name,
  .con = sqlite_occ
)
occ_cube_species_taxa <- 
  dbGetQuery(sqlite_occ, query) %>%
  filter(speciesKey %in% alien_taxa_species_key) %>%
    mutate(speciesKey = as.integer(speciesKey)) 


occ_cube_species_taxa %>%
  mutate(speciesKey = as.integer(speciesKey)) %>%
  group_by(speciesKey) %>%
  count() %>%
  filter(n > 1) %>%
  select(-n) %>%
  left_join(occ_cube_species_taxa, by = "speciesKey") %>%
  arrange(speciesKey, taxonKey)


occ_cube_species_taxa %>%
  mutate(speciesKey = as.integer(speciesKey))%>%
  group_by(speciesKey) %>%
  count() %>%
  rename(n_taxa = n) %>%
  left_join(occ_cube_species_taxa, by = "speciesKey") %>%
  group_by(speciesKey, n_taxa) %>%
  filter(taxonKey != speciesKey) %>%
  count() %>%
  rename(n_taxonKey_not_speciesKey = n) %>%
  filter(n_taxonKey_not_speciesKey == n_taxa) %>%
  left_join(occ_cube_species_taxa %>%
              filter(speciesKey != taxonKey),
            by = "speciesKey") %>%
  ungroup() %>%
  select(-c(n_taxa, n_taxonKey_not_speciesKey)) %>%
  arrange(speciesKey, taxonKey)


taxa_species <- 
  occ_cube_species_taxa %>%
  
  distinct(speciesKey) %>%
  
  pull(speciesKey) %>%
  
  map(~name_usage(key = .x)) %>%
  
  map(~.x[["data"]]) %>%
  map(~select(.x, speciesKey, scientificName, rank, taxonomicStatus)) %>%
  
  reduce(full_join) %>%
  
  rename(species_scientificName = scientificName) %>%
  
  right_join(occ_cube_species_taxa, by = "speciesKey") %>%
  
  group_by(speciesKey, 
           species_scientificName,
           rank,
           taxonomicStatus) %>%
  
  summarize(includes = paste(
    taxonKey, 
    scientificName, 
    sep = ": ", 
    collapse = " | ")) %>%
  
  rename(scientificName = species_scientificName)
taxa_species


rank_under_species <- c("SUBSPECIFICAGGREGATE",
                        "SUBSPECIES", 
                        "VARIETY",
                        "SUBVARIETY",
                        "FORM",
                        "SUBFORM"
)
alien_taxa_subspecies <-
  alien_taxa %>%
  filter(rank %in% rank_under_species, 
         taxonomicStatus %in% c("ACCEPTED", "DOUBTFUL"))
alien_taxa_subspecies


alien_taxa_subspecies_key <-
  alien_taxa_subspecies %>% 
  distinct(nubKey) %>% 
  pull(nubKey)


query <- glue_sql(
  "SELECT {`cols`*} FROM {table} WHERE acceptedTaxonKey IN ({subspecies_key*})",
  cols = c("year", 
           "eea_cell_code",
           "acceptedTaxonKey",
           "coordinateUncertaintyInMeters"),
  subspecies_key = alien_taxa_subspecies_key,
  table = table_name,
  .con = sqlite_occ
)
occ_cube_subspecies <- 
  dbGetQuery(sqlite_occ, query) %>%
  group_by(year, eea_cell_code, acceptedTaxonKey) %>%
  summarize(
    n = n(),
    min_coord_uncertainty = min(coordinateUncertaintyInMeters)
)


paste(
  length(alien_taxa_subspecies_key[
  which(alien_taxa_subspecies_key %in% 
          unique(occ_cube_subspecies$acceptedTaxonKey))]),
  "out of",
  length(alien_taxa_subspecies_key)
)


occ_cube_subspecies %>% head()


query <- glue_sql(
  "SELECT DISTINCT {`cols`*} FROM {table} 
  WHERE acceptedTaxonKey IN ({subspecies_key*})",
  cols = c("taxonKey", 
           "acceptedTaxonKey",
           "scientificName"),
  subspecies_key = alien_taxa_subspecies_key,
  table = table_name,
  .con = sqlite_occ
)
occ_cube_subspecies_taxa <- 
  dbGetQuery(sqlite_occ, query)


occ_cube_subspecies_taxa %>%
  group_by(acceptedTaxonKey) %>%
  count() %>%
  filter(n > 1) %>%
  select(-n) %>%
  left_join(occ_cube_subspecies_taxa)


occ_cube_subspecies_taxa %>%
  group_by(acceptedTaxonKey) %>%
  count() %>%
  rename(n_taxa = n) %>%
  left_join(occ_cube_subspecies_taxa, by = "acceptedTaxonKey") %>%
  group_by(acceptedTaxonKey, n_taxa) %>%
  filter(taxonKey != acceptedTaxonKey) %>%
  count() %>%
  rename(n_taxonKey_not_acceptedKey = n) %>%
  filter(n_taxonKey_not_acceptedKey == n_taxa) %>%
  left_join(occ_cube_subspecies_taxa %>%
              filter(acceptedTaxonKey != taxonKey),
            by = "acceptedTaxonKey") %>%
  ungroup() %>%
  select(-c(n_taxa, n_taxonKey_not_acceptedKey))


if (length(unique(occ_cube_subspecies_taxa$acceptedTaxonKey))>0){

taxa_subspecies <- 
  occ_cube_subspecies_taxa %>%
  
  distinct(acceptedTaxonKey) %>%
  
  pull(acceptedTaxonKey) %>%
  
  map(~name_usage(key = .x)) %>%
  
  map(~.x[["data"]]) %>%
  
  reduce(full_join) %>%
  
  rename(accepted_scientificName = scientificName)
if ("acceptedKey" %in% names(taxa_subspecies)) {
  
  taxa_subspecies <-
    taxa_subspecies %>%
    
    mutate(acceptedKey = case_when(
      is.na(acceptedKey) ~ key,
      !is.na(acceptedKey) ~acceptedKey)
  )
} else {
  taxa_subspecies <-
    taxa_subspecies %>%
    
    mutate(acceptedKey = key)
}
taxa_subspecies <-
  taxa_subspecies %>%
  
  select(acceptedKey, accepted_scientificName, rank, taxonomicStatus) %>%
  right_join(occ_cube_subspecies_taxa, 
             by = c("acceptedKey" = "acceptedTaxonKey")) %>%
  
  group_by(acceptedKey, 
           accepted_scientificName,
           rank,
           taxonomicStatus) %>%
  
  summarize(includes = paste(
    taxonKey, 
    scientificName, 
    sep = ": ", 
    collapse = " | ")) %>%
  
  rename(scientificName = accepted_scientificName)
taxa_subspecies
}else{
  taxa_subspecies <- data.table(NULL)
}

alien_taxa_synonyms <-
  alien_taxa %>%
  filter(!taxonomicStatus %in% c("ACCEPTED", "DOUBTFUL"))
alien_taxa_synonyms


alien_taxa_synonyms %>%
  group_by(rank) %>%
  count() %>%
  arrange(desc(n))


alien_taxa_synonyms_key <-
  alien_taxa_synonyms %>% 
  distinct(nubKey) %>% 
  pull(nubKey)


query <- glue_sql(
  "SELECT {`cols`*} FROM {table} WHERE taxonKey IN ({synonym_key*})",
  cols = c("year", 
           "eea_cell_code", 
           "taxonKey",
           "coordinateUncertaintyInMeters"),
  synonym_key = alien_taxa_synonyms_key,
  table = table_name,
  .con = sqlite_occ
)
occ_cube_synonym <- 
  dbGetQuery(sqlite_occ, query) %>%
  group_by(year, eea_cell_code, taxonKey) %>%
  summarize(
    n = n(),
    min_coord_uncertainty = min(coordinateUncertaintyInMeters)
)


paste(
  length(alien_taxa_synonyms_key[
  which(alien_taxa_synonyms_key %in% 
          unique(occ_cube_synonym$taxonKey))]),
  "out of",
  length(alien_taxa_synonyms_key)
)


occ_cube_synonym %>% head()


if (length(unique(occ_cube_synonym$taxonKey))>0){
  taxa_synonym <-
   
    alien_taxa_synonyms_key[
      which(alien_taxa_synonyms_key %in%
              unique(occ_cube_synonym$taxonKey))] %>%
   
    map(~name_usage(key = .x)) %>%
   
    map(~.x[["data"]]) %>%
   
    map(~select(.x, key, scientificName, rank, taxonomicStatus)) %>%
   
    reduce(full_join) %>%
   
    rename(taxonKey = key) %>%
   
    mutate(includes = paste(
      taxonKey,
      scientificName,
      sep = ": ")
  )
  taxa_synonym
} else {
  taxa_synonym <- data.table(NULL)
}


write_csv2(occ_cube_baseline, "be_classes_cube.csv", na = "")


head(occ_cube_species)


head(occ_cube_subspecies)


head(occ_cube_synonym)


occ_cube_species <-
  occ_cube_species %>%
  rename(taxonKey = speciesKey)


occ_cube_subspecies <-
  occ_cube_subspecies %>%
  rename(taxonKey = acceptedTaxonKey)


be_alientaxa_cube <- 
  occ_cube_species %>%
  bind_rows(occ_cube_subspecies) %>%
  bind_rows(occ_cube_synonym)


head(taxa_species)


head(taxa_subspecies)




taxa_species <-
  taxa_species %>%
  rename(taxonKey = speciesKey)


if("acceptedKey" %in% names(taxa_subspecies)){
  taxa_subspecies <-
    taxa_subspecies %>%
    rename(taxonKey = acceptedKey)
}


if (nrow(taxa_synonym) != 0){
  taxa <- 
    taxa_species %>%
    bind_rows(taxa_subspecies)%>%  
    bind_rows(taxa_synonym)
} else {
  taxa <- data.table(NULL)
}


write_csv2(be_alientaxa_cube, "be_alientaxa_cube.csv", na = "")


write_csv2(taxa, "be_alientaxa_info.csv", na = "")


dbDisconnect(sqlite_occ)



# capturing outputs
file <- file(paste0('/tmp/taxa_cube_', id, '.json'))
writeLines(toJSON(taxa_cube, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/classes_cube_', id, '.json'))
writeLines(toJSON(classes_cube, auto_unbox=TRUE), file)
close(file)
