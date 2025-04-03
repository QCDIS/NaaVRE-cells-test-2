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
if (!requireNamespace("rdwd", quietly = TRUE)) {
	install.packages("rdwd", repos="http://cran.us.r-project.org")
}
library(rdwd)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
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
library(rdwd)
library(lubridate)


weather_data_input <- function(bee_location,
                               to_date = "2016-12-31") {
  TrachtnetConv <- project(bee_location, "epsg:4326")
  Coordinates <- as.data.frame(crds(TrachtnetConv))
  
  WeatherStations <- nearbyStations(
    Coordinates$y,
    Coordinates$x,
    radius = 50,
    res = "daily", var = "kl", per = "historical", mindate = to_date
  ) |>
    filter(von_datum < from_date) |>
    mutate(
      url = map_chr(url,
      function(x){str_replace_all(x, "ftp://", "https://")})) 
  
  for (i in 1:nrow(WeatherStations)) {
    weather_data <- dataDWD(WeatherStations$url[i], varnames = TRUE, quiet = TRUE) |>
      select(MESS_DATUM,
             SDK.Sonnenscheindauer,
             TXK.Lufttemperatur_Max) |>
      filter(MESS_DATUM >= as.POSIXct(from_date, tz = "GMT"),
             MESS_DATUM <= as.POSIXct(to_date, tz = "GMT")) 

    if (anyNA(weather_data$SDK.Sonnenscheindauer) == FALSE & length(weather_data$SDK.Sonnenscheindauer) > 0) break
    
    if (i == length(WeatherStations$Stations_id)) {
      warning(paste("Final selected weather station includes NA values. No stations found without any NA within 50km distance. Station ID:", WeatherStations$Stations_id[i]))
    }
  }
  
  weather_data <- weather_data |>
    rename(Date = MESS_DATUM,
           T_max = TXK.Lufttemperatur_Max,
           Sun_hours = SDK.Sonnenscheindauer) |>
    mutate(Station_id = WeatherStations$Stations_id[i],
           Day = 1:n(),
           .before = Date) |>
    mutate(Sun_hours = ifelse(T_max < 15, 0, Sun_hours))
  
  weather_file <- paste("[", paste(weather_data$Sun_hours, collapse = " "), "]")
  
  return(list(weather_data, weather_file))
}

input_map <-
  rast(locations_output$input_tif_path)

bee_location <- vect(
  data.frame(
    id = locations_output$id,
    lon = locations_output$lon,
    lat = locations_output$lat
  ),
  geom = c("lon", "lat"),
  crs = "EPSG:4326"
) |>
  project(input_map)

to_date <- locations_output$start_day |>
  as.Date() + locations_output$sim_days

WeatherOutput <- weather_data_input(bee_location,
                                    to_date = to_date)

write.table(
  WeatherOutput[2],
  paste0(
    locations_output$location_path,
    "/weather",
    ".txt"
  ),
  quote = F,
  row.names = F,
  col.names = F
)

weather_file <- paste0(locations_output$location_path, "/weather.txt")
# capturing outputs
print('Serialization of weather_file')
file <- file(paste0('/tmp/weather_file_', id, '.json'))
writeLines(toJSON(weather_file, auto_unbox=TRUE), file)
close(file)
