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

make_option(c("--buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--output_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--parameters"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--simulation"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving buffer")
var = opt$buffer
print(var)
var_len = length(var)
print(paste("Variable buffer has length", var_len))

buffer = opt$buffer
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving input_dir")
var = opt$input_dir
print(var)
var_len = length(var)
print(paste("Variable input_dir has length", var_len))

input_dir <- gsub("\"", "", opt$input_dir)
print("Retrieving locations")
var = opt$locations
print(var)
var_len = length(var)
print(paste("Variable locations has length", var_len))

locations <- gsub("\"", "", opt$locations)
print("Retrieving lookup_table")
var = opt$lookup_table
print(var)
var_len = length(var)
print(paste("Variable lookup_table has length", var_len))

lookup_table <- gsub("\"", "", opt$lookup_table)
print("Retrieving map")
var = opt$map
print(var)
var_len = length(var)
print(paste("Variable map has length", var_len))

map <- gsub("\"", "", opt$map)
print("Retrieving output_dir")
var = opt$output_dir
print(var)
var_len = length(var)
print(paste("Variable output_dir has length", var_len))

output_dir <- gsub("\"", "", opt$output_dir)
print("Retrieving parameters")
var = opt$parameters
print(var)
var_len = length(var)
print(paste("Variable parameters has length", var_len))

parameters <- gsub("\"", "", opt$parameters)
print("Retrieving simulation")
var = opt$simulation
print(var)
var_len = length(var)
print(paste("Variable simulation has length", var_len))

simulation <- gsub("\"", "", opt$simulation)


print("Running the cell")
print(input_dir)
print(output_dir)
print(buffer)
print(map)
print(lookup_table)
print(locations)
print(parameters)
print(simulation)
