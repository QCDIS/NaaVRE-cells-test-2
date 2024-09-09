setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)

secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_server"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_s3_server")
var = opt$param_s3_server
print(var)
var_len = length(var)
print(paste("Variable param_s3_server has length", var_len))

param_s3_server <- gsub("\"", "", opt$param_s3_server)


print("Running the cell")



Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_server
    )

download_files_from_minio <- function(bucket, folder, local_path) {
  
  objects <- get_bucket(bucket = bucket, prefix = folder, region="")
  
  for (object in objects) {
    file_name <- basename(object$Key)
    local_file_path <- file.path(local_path, file_name)
    cat("Downloading", object$Key, "to", local_file_path, "\n")
    
    save_object(object = object$Key, bucket = bucket, file = local_file_path, region="")
    
    cat("File", object$Key, "downloaded successfully.\n")
  }
}

bucket_name <- "naa-vre-waddenzee-shared"  # Replace with your bucket name
minio_folder <- "app_acolite/processed_results/"  # Replace with your folder in the bucket
local_folder <- "/tmp/data/app_acolite"  # Replace with the local folder path

if (!dir.exists(local_folder)) {
  dir.create(local_folder, recursive = TRUE)
}

download_files_from_minio(bucket = bucket_name, folder = minio_folder, local_path = local_folder)

station = "DANTZGND"
filepaths = list.files(local_folder, pattern = station, full.names = TRUE)
RWS_RS <- lapply(filepaths, function(x) read.csv(x))
RWS_RS <- do.call("rbind", RWS_RS)
RWS_RS$time = as.POSIXct(RWS_RS$time, format = "%Y-%m-%d %H:%M:%S")
RWS_RS

                 
read_acolite_files <- function(station, ...){
    filepaths <- list.files(local_folder, pattern = station, full.names = TRUE)
    files <- lapply(filepaths, function(x) read.csv(x))
    RWS_RS <- do.call("rbind", files)
    RWS_RS$time = as.POSIXct(RWS_RS$time, format = "%Y-%m-%d %H:%M:%S")
    RWS_RS <- RWS_RS[order(RWS_RS$time), ]
    RWS_RS$station = station
    return(RWS_RS)
}

Haha = "Sowhat"
# capturing outputs
print('Serialization of Haha')
file <- file(paste0('/tmp/Haha_', id, '.json'))
writeLines(toJSON(Haha, auto_unbox=TRUE), file)
close(file)
