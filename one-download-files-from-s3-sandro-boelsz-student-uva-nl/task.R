setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)

secret_s3_access_id = Sys.getenv('secret_s3_access_id')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map_aux"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_model"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_netlogo_jar_path"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_output_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_parameters"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_bucket"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_region"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_simulation"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_buffer")
var = opt$param_buffer
print(var)
var_len = length(var)
print(paste("Variable param_buffer has length", var_len))

param_buffer = opt$param_buffer
print("Retrieving param_input_dir")
var = opt$param_input_dir
print(var)
var_len = length(var)
print(paste("Variable param_input_dir has length", var_len))

param_input_dir <- gsub("\"", "", opt$param_input_dir)
print("Retrieving param_locations")
var = opt$param_locations
print(var)
var_len = length(var)
print(paste("Variable param_locations has length", var_len))

param_locations <- gsub("\"", "", opt$param_locations)
print("Retrieving param_lookup_table")
var = opt$param_lookup_table
print(var)
var_len = length(var)
print(paste("Variable param_lookup_table has length", var_len))

param_lookup_table <- gsub("\"", "", opt$param_lookup_table)
print("Retrieving param_map")
var = opt$param_map
print(var)
var_len = length(var)
print(paste("Variable param_map has length", var_len))

param_map <- gsub("\"", "", opt$param_map)
print("Retrieving param_map_aux")
var = opt$param_map_aux
print(var)
var_len = length(var)
print(paste("Variable param_map_aux has length", var_len))

param_map_aux <- gsub("\"", "", opt$param_map_aux)
print("Retrieving param_model")
var = opt$param_model
print(var)
var_len = length(var)
print(paste("Variable param_model has length", var_len))

param_model <- gsub("\"", "", opt$param_model)
print("Retrieving param_netlogo_jar_path")
var = opt$param_netlogo_jar_path
print(var)
var_len = length(var)
print(paste("Variable param_netlogo_jar_path has length", var_len))

param_netlogo_jar_path <- gsub("\"", "", opt$param_netlogo_jar_path)
print("Retrieving param_output_dir")
var = opt$param_output_dir
print(var)
var_len = length(var)
print(paste("Variable param_output_dir has length", var_len))

param_output_dir <- gsub("\"", "", opt$param_output_dir)
print("Retrieving param_parameters")
var = opt$param_parameters
print(var)
var_len = length(var)
print(paste("Variable param_parameters has length", var_len))

param_parameters <- gsub("\"", "", opt$param_parameters)
print("Retrieving param_s3_bucket")
var = opt$param_s3_bucket
print(var)
var_len = length(var)
print(paste("Variable param_s3_bucket has length", var_len))

param_s3_bucket <- gsub("\"", "", opt$param_s3_bucket)
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving param_s3_region")
var = opt$param_s3_region
print(var)
var_len = length(var)
print(paste("Variable param_s3_region has length", var_len))

param_s3_region <- gsub("\"", "", opt$param_s3_region)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)
print("Retrieving param_simulation")
var = opt$param_simulation
print(var)
var_len = length(var)
print(paste("Variable param_simulation has length", var_len))

param_simulation <- gsub("\"", "", opt$param_simulation)


print("Running the cell")

library(aws.s3)
Sys.setenv(
  "AWS_ACCESS_KEY_ID" = secret_s3_access_id,
  "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
  "AWS_DEFAULT_REGION" = param_s3_region,
  "AWS_S3_ENDPOINT" = param_s3_endpoint,
  "AWS_S3_VERIFY" = "FALSE"
)

filenames <- c(param_map, param_map_aux, param_lookup_table, param_locations, param_parameters, param_simulation, param_model)
s3_locations <- paste0(param_s3_user_prefix, "/input/", filenames)
download_locations <- paste0(param_input_dir, filenames)

download_file <- function(s3_path, local_path, bucket) {
  tryCatch({
    save_object(object = s3_path, 
                bucket = bucket, 
                file = local_path)
    
    if (file.exists(local_path)) {
      message(paste("Downloaded:", s3_path, "to", local_path))
      return(TRUE)
    } else {
      warning(paste("File not found after download attempt:", s3_path))
      return(FALSE)
    }
  }, error = function(e) {
    warning(paste("Failed to download:", s3_path, "Error:", e$message))
      return(FALSE)
  })
}

results <- mapply(download_file, s3_locations, download_locations, param_s3_bucket)

is_file_download_succesful <- as.integer(all(results))
if (is_file_download_succesful == 1) {
  message("All files downloaded successfully!")
} else {
  warning("Some files failed to download.")
  stop("Some files failed to download.")
}
# capturing outputs
print('Serialization of is_file_download_succesful')
file <- file(paste0('/tmp/is_file_download_succesful_', id, '.json'))
writeLines(toJSON(is_file_download_succesful, auto_unbox=TRUE), file)
close(file)
