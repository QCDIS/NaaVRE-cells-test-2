setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("glmmTMB", quietly = TRUE)) {
	install.packages("glmmTMB", repos="http://cran.us.r-project.org")
}
library(glmmTMB)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)

secret_minio_access_key = Sys.getenv('secret_minio_access_key')
secret_minio_secret_key = Sys.getenv('secret_minio_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--model_output"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_region"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_user_prefix"), action="store", default=NA, type="character", help="my description")
)


opt = parse_args(OptionParser(option_list=option_list))

var_serialization <- function(var){
    if (is.null(var)){
        print("Variable is null")
        exit(1)
    }
    tryCatch(
        {
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        error=function(e) {
            print("Error while deserializing the variable")
            print(var)
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        },
        warning=function(w) {
            print("Warning while deserializing the variable")
            var <- gsub("'", '"', var)
            var <- fromJSON(var)
            print("Variable deserialized")
            return(var)
        }
    )
}

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving model_output")
var = opt$model_output
print(var)
var_len = length(var)
print(paste("Variable model_output has length", var_len))

print("------------------------Running var_serialization for model_output-----------------------")
print(opt$model_output)
model_output = var_serialization(opt$model_output)
print("---------------------------------------------------------------------------------")

print("Retrieving param_minio_endpoint")
var = opt$param_minio_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_minio_endpoint has length", var_len))

param_minio_endpoint <- gsub("\"", "", opt$param_minio_endpoint)
print("Retrieving param_minio_region")
var = opt$param_minio_region
print(var)
var_len = length(var)
print(paste("Variable param_minio_region has length", var_len))

param_minio_region <- gsub("\"", "", opt$param_minio_region)
print("Retrieving param_minio_user_prefix")
var = opt$param_minio_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_minio_user_prefix has length", var_len))

param_minio_user_prefix <- gsub("\"", "", opt$param_minio_user_prefix)


print("Running the cell")

Sys.setenv(
  "AWS_S3_ENDPOINT"  = param_minio_endpoint,
  "AWS_DEFAULT_REGION" = param_minio_region,
  "AWS_ACCESS_KEY_ID" = secret_minio_access_key,
  "AWS_SECRET_ACCESS_KEY" = secret_minio_secret_key
)

purrr::map(.x = model_output,
           .f = ~{
               
                          
               put_object(
                bucket = "naa-vre-user-data",
                file = .x,
                object = paste0(param_minio_user_prefix, "/", stringr::str_extract(.x, pattern = "(?<=_)[^_]+(?=\\.rda)"), ".rda")
               )
               }
          )

               
               

