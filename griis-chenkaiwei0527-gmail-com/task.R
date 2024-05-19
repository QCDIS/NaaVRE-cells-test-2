setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
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
make_option(c("--param_dataset_key"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)

param_dataset_key = opt$param_dataset_key


conf_work_dir = '/tmp/data'


conf_work_dir = '/tmp/data'

lbs <- c("knitr", "optparse", "tidyverse","rgbif")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)



setwd(conf_work_dir)

alien_taxa <- name_usage(
  datasetKey = param_dataset_key, 
  limit = 10000)  

alien_taxa <- 
	alien_taxa$data %>%
	filter(origin == "SOURCE")

alien_taxa  %>% head()

write.table(alien_taxa, file=paste(param_dataset_key, '.tsv', sep=""), quote=FALSE, sep='\t', row.names = FALSE)

library(zip)

file_to_zip <- paste0(param_dataset_key, ".tsv")

if (length(tsv_files) > 0) {
  zip(zipfile = "griis.zip", files = file_to_zip)
  
  cat("File", param_dataset_key, "zipped into griis.zip successfully.\n")
} else {
  cat("File", param_dataset_key, "not found in the current directory.\n")
}

taxa_data <- file.path(conf_work_dir, "griis.zip")



# capturing outputs
file <- file(paste0('/tmp/taxa_data_', id, '.json'))
writeLines(toJSON(taxa_data, auto_unbox=TRUE), file)
close(file)
