setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("dendextend", quietly = TRUE)) {
	install.packages("dendextend", repos="http://cran.us.r-project.org")
}
library(dendextend)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("fields", quietly = TRUE)) {
	install.packages("fields", repos="http://cran.us.r-project.org")
}
library(fields)
if (!requireNamespace("reshape", quietly = TRUE)) {
	install.packages("reshape", repos="http://cran.us.r-project.org")
}
library(reshape)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
if (!requireNamespace("vegan", quietly = TRUE)) {
	install.packages("vegan", repos="http://cran.us.r-project.org")
}
library(vegan)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_data_in"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key_id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_access_key"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)

param_data_in = opt$param_data_in
param_s3_access_key_id = opt$param_s3_access_key_id
param_s3_endpoint = opt$param_s3_endpoint
param_s3_prefix = opt$param_s3_prefix
param_s3_secret_access_key = opt$param_s3_secret_access_key


conf_output = '/tmp/data/'
conf_s3_folder = 'vl-phytoplankton'


conf_output = '/tmp/data/'
conf_s3_folder = 'vl-phytoplankton'

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

data_file = paste0(conf_output,"input_data.csv")
analysis_conf_file = paste0(conf_output,"analysis_conf_file.csv")

if (grepl("^https?://", param_data_in)) {
    download.file(param_data_in, dest=data_file)
} else if (grepl("^minio::", param_data_in)) {
    minio_path = gsub("^minio::","",param_data_in)
    save_object(region="", bucket="naa-vre-user-data", file=data_file, object=paste0(param_s3_prefix, minio_path))
} else {
    print('invalid param_data_in')
}

save_object(region="", bucket="naa-vre-user-data", file=analysis_conf_file, object=paste(param_s3_prefix, conf_s3_folder, "2_FILEinformativo_OPERATORE.csv", sep='/'))



# capturing outputs
file <- file(paste0('/tmp/data_file_', id, '.json'))
writeLines(toJSON(data_file, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/analysis_conf_file_', id, '.json'))
writeLines(toJSON(analysis_conf_file, auto_unbox=TRUE), file)
close(file)
