setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("plot3D", quietly = TRUE)) {
	install.packages("plot3D", repos="http://cran.us.r-project.org")
}
library(plot3D)


print('option_list')
option_list = list(

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

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )
bucketlist(region="")

save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/Spatio_temporal_settings.rda", object=paste0(param_s3_user_prefix, "/input_data/Spatio_temporal_settings.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/WKd_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WKd_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/Irrad_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/Irrad_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/WAlpha_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WAlpha_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/WEopt_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WEopt_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/WPs_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WPs_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/WHeight_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WHeight_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/Sediment_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/Sediment_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/BAlpha_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BAlpha_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/BEopt_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BEopt_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="downloaded_data/BPs_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BPs_Ems.rda"))
