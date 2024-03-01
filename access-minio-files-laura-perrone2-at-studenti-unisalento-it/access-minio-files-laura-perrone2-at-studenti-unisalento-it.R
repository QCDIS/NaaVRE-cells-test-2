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
if (!requireNamespace("fields", quietly = TRUE)) {
	install.packages("fields", repos="http://cran.us.r-project.org")
}
library(fields)
if (!requireNamespace("vegan", quietly = TRUE)) {
	install.packages("vegan", repos="http://cran.us.r-project.org")
}
library(vegan)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key_id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_access_key"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)

param_s3_access_key_id = opt$param_s3_access_key_id
param_s3_endpoint = opt$param_s3_endpoint
param_s3_prefix = opt$param_s3_prefix
param_s3_secret_access_key = opt$param_s3_secret_access_key


conf_output = '/tmp/data/'


conf_output = '/tmp/data/'

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )
datain1 = paste0(conf_output,"Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv")
datain2 = paste0(conf_output,"2_FILEinformativo_OPERATORE.csv")
save_object(region="", bucket="naa-vre-user-data", file=datain1, object=paste0(param_s3_prefix, "/myfile/Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv"))
save_object(region="", bucket="naa-vre-user-data", file=datain2, object=paste0(param_s3_prefix, "/myfile/2_FILEinformativo_OPERATORE.csv"))



# capturing outputs
file <- file(paste0('/tmp/datain1_', id, '.json'))
writeLines(toJSON(datain1, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/datain2_', id, '.json'))
writeLines(toJSON(datain2, auto_unbox=TRUE), file)
close(file)
