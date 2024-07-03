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


load(file = "downloaded_data/Spatio_temporal_settings.rda")
load(file = "downloaded_data/WKd_Ems.rda")
load(file = "downloaded_data/Irrad_Ems.rda")
load(file = "downloaded_data/WAlpha_Ems.rda")
load(file = "downloaded_data/WEopt_Ems.rda")
load(file = "downloaded_data/WPs_Ems.rda")
load(file = "downloaded_data/WHeight_Ems.rda")
load(file = "downloaded_data/Sediment_Ems.rda")
load(file = "downloaded_data/BAlpha_Ems.rda")
load(file = "downloaded_data/BEopt_Ems.rda")
load(file = "downloaded_data/BPs_Ems.rda")

Batxyv <- Bat_xyv
WKd <- WKd_Ems
Irrad <- Irrad_Ems
WAlpha <- WAlpha_Ems
WEopt <- WEopt_Ems
WPs <- WPs_Ems
WHeight <- WHeight_Ems
Sediment <- Sediment_Ems
BAlpha <- BAlpha_Ems
BEopt <- BEopt_Ems
BPs <- BPs_Ems
     
Silt <- Sediment_Ems$silt
Depth <- Bat_xyv$depth
Kd <- Sediment_Ems$Kd
     
print(Bat_xyv)



# capturing outputs
print('Serialization of Silt')
file <- file(paste0('/tmp/Silt_', id, '.json'))
writeLines(toJSON(Silt, auto_unbox=TRUE), file)
close(file)
print('Serialization of Depth')
file <- file(paste0('/tmp/Depth_', id, '.json'))
writeLines(toJSON(Depth, auto_unbox=TRUE), file)
close(file)
print('Serialization of Kd')
file <- file(paste0('/tmp/Kd_', id, '.json'))
writeLines(toJSON(Kd, auto_unbox=TRUE), file)
close(file)
print('Serialization of Batxyv')
file <- file(paste0('/tmp/Batxyv_', id, '.json'))
writeLines(toJSON(Batxyv, auto_unbox=TRUE), file)
close(file)
print('Serialization of WKd')
file <- file(paste0('/tmp/WKd_', id, '.json'))
writeLines(toJSON(WKd, auto_unbox=TRUE), file)
close(file)
print('Serialization of Irrad')
file <- file(paste0('/tmp/Irrad_', id, '.json'))
writeLines(toJSON(Irrad, auto_unbox=TRUE), file)
close(file)
print('Serialization of WAlpha')
file <- file(paste0('/tmp/WAlpha_', id, '.json'))
writeLines(toJSON(WAlpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of WEopt')
file <- file(paste0('/tmp/WEopt_', id, '.json'))
writeLines(toJSON(WEopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of WPs')
file <- file(paste0('/tmp/WPs_', id, '.json'))
writeLines(toJSON(WPs, auto_unbox=TRUE), file)
close(file)
print('Serialization of WHeight')
file <- file(paste0('/tmp/WHeight_', id, '.json'))
writeLines(toJSON(WHeight, auto_unbox=TRUE), file)
close(file)
print('Serialization of Sediment')
file <- file(paste0('/tmp/Sediment_', id, '.json'))
writeLines(toJSON(Sediment, auto_unbox=TRUE), file)
close(file)
print('Serialization of BAlpha')
file <- file(paste0('/tmp/BAlpha_', id, '.json'))
writeLines(toJSON(BAlpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of BEopt')
file <- file(paste0('/tmp/BEopt_', id, '.json'))
writeLines(toJSON(BEopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of BPs')
file <- file(paste0('/tmp/BPs_', id, '.json'))
writeLines(toJSON(BPs, auto_unbox=TRUE), file)
close(file)
