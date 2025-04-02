setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("readr", quietly = TRUE)) {
	install.packages("readr", repos="http://cran.us.r-project.org")
}
library(readr)

secret_s3_access_id = Sys.getenv('secret_s3_access_id')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--isFileDownloadSuccessful"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map_aux"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_model"), action="store", default=NA, type="character", help="my description"), 
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
print("Retrieving isFileDownloadSuccessful")
var = opt$isFileDownloadSuccessful
print(var)
var_len = length(var)
print(paste("Variable isFileDownloadSuccessful has length", var_len))

isFileDownloadSuccessful = opt$isFileDownloadSuccessful
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

library(readr)
library(purrr)
library(dplyr)

if (!isFileDownloadSuccessful) {
  stop("File download failed! Stopping workflow.")
} else {
  message("All files downloaded successfully. Proceeding with input preparation.")
}

input_tif_path <- file.path(param_input_dir, param_map)
input_lookup_path <- file.path(param_input_dir, param_lookup_table)
input_locations_path <- file.path(param_input_dir, param_locations)
input_parameters_path <- file.path(param_input_dir, param_parameters)
input_simulation_path <- file.path(param_input_dir, param_simulation)

if (!dir.exists(param_output_dir)) {
  dir.create(param_output_dir)
}

location <- 
  read_delim(input_locations_path,
             delim = ",",
             col_types = list(
               id = "i",
               lat = "d",
               lon = "d"
  )) |>
  slice(1)

parameters <- 
  read_csv(
    file = input_parameters_path,
    col_types = list(
      Parameter = col_character(),
      Value = col_double(),
      `Default.Value` = col_skip()
    )
  ) |>
  rbind(
    data.frame(
      Parameter = c("INPUT_FILE", "WeatherFile", "random-seed"),
      Value = c(paste0("\"", param_input_dir, "locations", "/input.txt\""),
                paste0("\"", param_input_dir, "locations", "/weather.txt\""),
                sample(1:100000, 1))
    )
)

parameters_list <- parameters$Value |>
  map(~list(.x))
names(parameters_list) <- parameters$Parameter
  
simulation_df <- read_csv(
  file = input_simulation_path,
  col_types = list(
    sim_days = col_integer(),
    start_day = col_character()
  )
)
locations_output <- list(
  id = location$id,
  lat = location$lat,
  lon = location$lon,
  buffer_size = param_buffer,
  sim_days = simulation_df$sim_days[1],
  start_day = simulation_df$start_day[1],
  location_path = file.path(param_input_dir, "locations"),
  input_tif_path = input_tif_path,
  nectar_pollen_lookup_path = input_lookup_path
)
    
netlogo_output <- list(
  outpath = file.path(
    param_output_dir,
    paste0("output_id", location$id, ".csv")
  ),
  metrics = c(
    "TotalIHbees + TotalForagers",
    "(honeyEnergyStore / ( ENERGY_HONEY_per_g * 1000 ))",
    "PollenStore_g"
  ),
  variables = parameters_list,
  sim_days = simulation_df$sim_days[1],
  start_day = simulation_df$start_day[1]
)
# capturing outputs
print('Serialization of locations_output')
file <- file(paste0('/tmp/locations_output_', id, '.json'))
writeLines(toJSON(locations_output, auto_unbox=TRUE), file)
close(file)
print('Serialization of netlogo_output')
file <- file(paste0('/tmp/netlogo_output_', id, '.json'))
writeLines(toJSON(netlogo_output, auto_unbox=TRUE), file)
close(file)
