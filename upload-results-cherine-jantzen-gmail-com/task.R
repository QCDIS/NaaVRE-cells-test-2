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
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_user_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--summary_maxTempT1"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_minio_user_prefix")
var = opt$param_minio_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_minio_user_prefix has length", var_len))

param_minio_user_prefix <- gsub("\"", "", opt$param_minio_user_prefix)
print("Retrieving summary_maxTempT1")
var = opt$summary_maxTempT1
print(var)
var_len = length(var)
print(paste("Variable summary_maxTempT1 has length", var_len))

print("------------------------Running var_serialization for summary_maxTempT1-----------------------")
print(opt$summary_maxTempT1)
summary_maxTempT1 = var_serialization(opt$summary_maxTempT1)
print("---------------------------------------------------------------------------------")



print("Running the cell")

save(summary_maxTempT1, "summary_maxTempT1.rda")

put_object(
    bucket = "naa-vre-user-data",
    file = "summary_maxTempT1.rda",
    object = paste0(param_minio_user_prefix, "/model_output_maxTempT1.csv"))
