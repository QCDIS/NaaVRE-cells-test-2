setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


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

analysis_conf_file = paste0(conf_output,"analysis_conf_file.csv")

data_file=list()
for ( myfile in param_data_in) {
    
  if (grepl("^https?://", myfile)) {
      datafile_item=gsub('/', '_', myfile)
      download.file(myfile, dest=datafile_item)
  } else if (grepl("^minio::", myfile)) {
      datafile_item=str_split(myfile, '/')[[1]]
      datafile_item=datafile_item[length(datafile_item)]
      minio_path = gsub("^minio::","",myfile)
      save_object(region="", bucket="naa-vre-user-data", file=datafile_item, object=paste0(param_s3_prefix, minio_path))
  } else {
     stop('invalid value in param_data_in')
 }
    data_file[[length(data_file)+1]] <- datafile_item
}
save_object(region="", bucket="naa-vre-user-data", file=analysis_conf_file, object=paste(param_s3_prefix, conf_s3_folder, "2_FILEinformativo_OPERATORE.csv", sep='/'))



# capturing outputs
file <- file(paste0('/tmp/data_file_', id, '.json'))
writeLines(toJSON(data_file, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/analysis_conf_file_', id, '.json'))
writeLines(toJSON(analysis_conf_file, auto_unbox=TRUE), file)
close(file)
