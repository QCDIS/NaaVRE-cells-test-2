setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("jsonlite", quietly = TRUE)) {
	install.packages("jsonlite", repos="http://cran.us.r-project.org")
}
library(jsonlite)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("optparse", quietly = TRUE)) {
	install.packages("optparse", repos="http://cran.us.r-project.org")
}
library(optparse)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("rdwd", quietly = TRUE)) {
	install.packages("rdwd", repos="http://cran.us.r-project.org")
}
library(rdwd)
if (!requireNamespace("readr", quietly = TRUE)) {
	install.packages("readr", repos="http://cran.us.r-project.org")
}
library(readr)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("stats", quietly = TRUE)) {
	install.packages("stats", repos="http://cran.us.r-project.org")
}
library(stats)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description")
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


print("Running the cell")
input_dir <- "../data/input" 
output_dir <- "../data/output" 
buffer <- 3000L
map <- "map.tif"
lookup_table <- "lookup_table.csv"
locations <- "locations.csv"
parameters <- "parameters.csv"
simulation <- "simulation.csv"
# capturing outputs
print('Serialization of input_dir')
file <- file(paste0('/tmp/input_dir_', id, '.json'))
writeLines(toJSON(input_dir, auto_unbox=TRUE), file)
close(file)
print('Serialization of output_dir')
file <- file(paste0('/tmp/output_dir_', id, '.json'))
writeLines(toJSON(output_dir, auto_unbox=TRUE), file)
close(file)
print('Serialization of buffer')
file <- file(paste0('/tmp/buffer_', id, '.json'))
writeLines(toJSON(buffer, auto_unbox=TRUE), file)
close(file)
print('Serialization of map')
file <- file(paste0('/tmp/map_', id, '.json'))
writeLines(toJSON(map, auto_unbox=TRUE), file)
close(file)
print('Serialization of lookup_table')
file <- file(paste0('/tmp/lookup_table_', id, '.json'))
writeLines(toJSON(lookup_table, auto_unbox=TRUE), file)
close(file)
print('Serialization of locations')
file <- file(paste0('/tmp/locations_', id, '.json'))
writeLines(toJSON(locations, auto_unbox=TRUE), file)
close(file)
print('Serialization of parameters')
file <- file(paste0('/tmp/parameters_', id, '.json'))
writeLines(toJSON(parameters, auto_unbox=TRUE), file)
close(file)
print('Serialization of simulation')
file <- file(paste0('/tmp/simulation_', id, '.json'))
writeLines(toJSON(simulation, auto_unbox=TRUE), file)
close(file)
