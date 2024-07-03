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

save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/Spatio_temporal_settings.rda", object=paste0(param_s3_user_prefix, "/input_data/Spatio_temporal_settings.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/WKd_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WKd_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/Irrad_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/Irrad_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/WAlpha_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WAlpha_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/WEopt_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WEopt_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/WPs_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WPs_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/WHeight_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/WHeight_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/Sediment_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/Sediment_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/BAlpha_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BAlpha_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/BEopt_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BEopt_Ems.rda"))
save_object(region="", bucket="naa-vre-user-data", file="/tmp/data/BPs_Ems.rda", object=paste0(param_s3_user_prefix, "/input_data/BPs_Ems.rda"))

spatio = '/tmp/data/Spatio_temporal_settings.rda'
wkd = '/tmp/data/WKd_Ems.rda'
irrad = '/tmp/data/Irrad_Ems.rda'
walpha = '/tmp/data/WAlpha_Ems.rda'
weopt = '/tmp/data/WEopt_Ems.rda'
wps = '/tmp/data/WPs_Ems.rda'
wheight = '/tmp/data/WHeight_Ems.rda'
sediment = '/tmp/data/Sediment_Ems.rda'
balpha = '/tmp/data/BAlpha_Ems.rda'
beopt = '/tmp/data/BEopt_Ems.rda'
bps = '/tmp/data/BPs_Ems.rda'




     



# capturing outputs
print('Serialization of spatio')
file <- file(paste0('/tmp/spatio_', id, '.json'))
writeLines(toJSON(spatio, auto_unbox=TRUE), file)
close(file)
print('Serialization of wkd')
file <- file(paste0('/tmp/wkd_', id, '.json'))
writeLines(toJSON(wkd, auto_unbox=TRUE), file)
close(file)
print('Serialization of irrad')
file <- file(paste0('/tmp/irrad_', id, '.json'))
writeLines(toJSON(irrad, auto_unbox=TRUE), file)
close(file)
print('Serialization of walpha')
file <- file(paste0('/tmp/walpha_', id, '.json'))
writeLines(toJSON(walpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of weopt')
file <- file(paste0('/tmp/weopt_', id, '.json'))
writeLines(toJSON(weopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of wps')
file <- file(paste0('/tmp/wps_', id, '.json'))
writeLines(toJSON(wps, auto_unbox=TRUE), file)
close(file)
print('Serialization of wheight')
file <- file(paste0('/tmp/wheight_', id, '.json'))
writeLines(toJSON(wheight, auto_unbox=TRUE), file)
close(file)
print('Serialization of sediment')
file <- file(paste0('/tmp/sediment_', id, '.json'))
writeLines(toJSON(sediment, auto_unbox=TRUE), file)
close(file)
print('Serialization of balpha')
file <- file(paste0('/tmp/balpha_', id, '.json'))
writeLines(toJSON(balpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of beopt')
file <- file(paste0('/tmp/beopt_', id, '.json'))
writeLines(toJSON(beopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of bps')
file <- file(paste0('/tmp/bps_', id, '.json'))
writeLines(toJSON(bps, auto_unbox=TRUE), file)
close(file)
