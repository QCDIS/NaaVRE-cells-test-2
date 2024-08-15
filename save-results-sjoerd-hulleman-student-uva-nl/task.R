setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--cpu_results"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_key"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving cpu_results")
var = opt$cpu_results
print(var)
var_len = length(var)
print(paste("Variable cpu_results has length", var_len))

print("------------------------Running var_serialization for cpu_results-----------------------")
print(opt$cpu_results)
cpu_results = var_serialization(opt$cpu_results)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_s3_access_key")
var = opt$param_s3_access_key
print(var)
var_len = length(var)
print(paste("Variable param_s3_access_key has length", var_len))

param_s3_access_key <- gsub("\"", "", opt$param_s3_access_key)
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving param_s3_secret_key")
var = opt$param_s3_secret_key
print(var)
var_len = length(var)
print(paste("Variable param_s3_secret_key has length", var_len))

param_s3_secret_key <- gsub("\"", "", opt$param_s3_secret_key)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)


print("Running the cell")


cpu_results_df <- as.data.frame(do.call(rbind, cpu_results))

print(is.data.frame(cpu_results_df))

save(cpu_results_df, file='data_sjoerd.rda')


Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

print("SAVING FILE TO OBJECT STORAGE")
put_object(region="", bucket="naa-vre-user-data", file="data_sjoerd.rda", object=paste0(param_s3_user_prefix, "/outputs/data_sjoerd.rda"))
