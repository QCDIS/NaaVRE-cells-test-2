setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("here", quietly = TRUE)) {
	install.packages("here", repos="http://cran.us.r-project.org")
}
library(here)
if (!requireNamespace("knitr", quietly = TRUE)) {
	install.packages("knitr", repos="http://cran.us.r-project.org")
}
library(knitr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
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
make_option(c("--param_country_code"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_download_key"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_end_date"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_GBIF_EMAIL"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_GBIF_PASSWORD"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_GBIF_USERNAME"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_start_date"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)

param_country_code = opt$param_country_code
param_download_key = opt$param_download_key
param_end_date = opt$param_end_date
param_GBIF_EMAIL = opt$param_GBIF_EMAIL
param_GBIF_PASSWORD = opt$param_GBIF_PASSWORD
param_GBIF_USERNAME = opt$param_GBIF_USERNAME
param_start_date = opt$param_start_date


conf_work_dir = '/tmp/data'


conf_work_dir = '/tmp/data'

library(devtools)
devtools::install_github("trias-project/trias@5d0f27f76567c0d11021a3055c32ec521622ca36")

lbs <- c("knitr", "optparse", "trias", "tidyverse", "here", "rgbif", "lubridate", "devtools")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)

	


setwd(conf_work_dir)


countries <- param_country_code

basis_of_record <- c(
  "OBSERVATION", 
  "HUMAN_OBSERVATION",
  "MATERIAL_SAMPLE", 
  "LITERATURE", 
  "PRESERVED_SPECIMEN", 
  "UNKNOWN", 
  "MACHINE_OBSERVATION"
)


year_begin <- param_start_date
year_end <- param_end_date


hasCoordinate <- TRUE




gbif_download_key <- occ_download(
  pred_in("country", countries),
  pred_in("basisOfRecord", basis_of_record),
  pred_gte("year", year_begin),
  pred_lte("year", year_end),
  pred("hasCoordinate", hasCoordinate),
  user = param_GBIF_USERNAME,
  pwd = param_GBIF_PASSWORD,
  email = param_GBIF_EMAIL
)


metadata <- occ_download_meta(key = gbif_download_key)

while (metadata$status == "PREPARING" || metadata$status == "RUNNING") {
   	metadata <- occ_download_meta(key = gbif_download_key)
    print(metadata$status)
    Sys.sleep(120)
}
metadata$key
metadata$status

destfile <- "gbif.zip"
download.file(metadata$downloadLink, destfile, mode="wb")


if (!file.exists("gbif_downloads.tsv")){
	gbif_tsv <- cbind("gbif_download_key", "input_checklist", "gbif_download_created", "gbif_download_status", "gbif_download_doi")
	write.table(gbif_tsv, file='gbif_downloads.tsv', quote=FALSE, sep='\t', col.names = FALSE, row.names = FALSE)
}
update_download_list(
  file = "gbif_downloads.tsv",
  download_to_add = gbif_download_key, 
  input_checklist = ""
)

occ_data <- file.path(conf_work_dir, "gbif.zip")



# capturing outputs
file <- file(paste0('/tmp/occ_data_', id, '.json'))
writeLines(toJSON(occ_data, auto_unbox=TRUE), file)
close(file)
