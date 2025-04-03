setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("raster", quietly = TRUE)) {
	install.packages("raster", repos="http://cran.us.r-project.org")
}
library(raster)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)

secret_s3_access_id = Sys.getenv('secret_s3_access_id')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--locations_output"), action="store", default=NA, type="character", help="my description"), 
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
print("Retrieving locations_output")
var = opt$locations_output
print(var)
var_len = length(var)
print(paste("Variable locations_output has length", var_len))

print("------------------------Running var_serialization for locations_output-----------------------")
print(opt$locations_output)
locations_output = var_serialization(opt$locations_output)
print("---------------------------------------------------------------------------------")

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


library(terra)
library(dplyr)
library(purrr)
library(stringr)
library(lubridate)

print("test")
# capturing outputs
print('Serialization of input_file')
file <- file(paste0('/tmp/input_file_', id, '.json'))
writeLines(toJSON(input_file, auto_unbox=TRUE), file)
close(file)
