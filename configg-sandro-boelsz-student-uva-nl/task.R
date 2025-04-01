setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("DBI", quietly = TRUE)) {
	install.packages("DBI", repos="http://cran.us.r-project.org")
}
library(DBI)
if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("abind", quietly = TRUE)) {
	install.packages("abind", repos="http://cran.us.r-project.org")
}
library(abind)
if (!requireNamespace("berryFunctions", quietly = TRUE)) {
	install.packages("berryFunctions", repos="http://cran.us.r-project.org")
}
library(berryFunctions)
if (!requireNamespace("bit", quietly = TRUE)) {
	install.packages("bit", repos="http://cran.us.r-project.org")
}
library(bit)
if (!requireNamespace("bit64", quietly = TRUE)) {
	install.packages("bit64", repos="http://cran.us.r-project.org")
}
library(bit64)
if (!requireNamespace("classInt", quietly = TRUE)) {
	install.packages("classInt", repos="http://cran.us.r-project.org")
}
library(classInt)
if (!requireNamespace("clipr", quietly = TRUE)) {
	install.packages("clipr", repos="http://cran.us.r-project.org")
}
library(clipr)
if (!requireNamespace("cpp11", quietly = TRUE)) {
	install.packages("cpp11", repos="http://cran.us.r-project.org")
}
library(cpp11)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("e1071", quietly = TRUE)) {
	install.packages("e1071", repos="http://cran.us.r-project.org")
}
library(e1071)
if (!requireNamespace("generics", quietly = TRUE)) {
	install.packages("generics", repos="http://cran.us.r-project.org")
}
library(generics)
if (!requireNamespace("hms", quietly = TRUE)) {
	install.packages("hms", repos="http://cran.us.r-project.org")
}
library(hms)
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
if (!requireNamespace("pbapply", quietly = TRUE)) {
	install.packages("pbapply", repos="http://cran.us.r-project.org")
}
library(pbapply)
if (!requireNamespace("progress", quietly = TRUE)) {
	install.packages("progress", repos="http://cran.us.r-project.org")
}
library(progress)
if (!requireNamespace("proxy", quietly = TRUE)) {
	install.packages("proxy", repos="http://cran.us.r-project.org")
}
library(proxy)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("raster", quietly = TRUE)) {
	install.packages("raster", repos="http://cran.us.r-project.org")
}
library(raster)
if (!requireNamespace("rdwd", quietly = TRUE)) {
	install.packages("rdwd", repos="http://cran.us.r-project.org")
}
library(rdwd)
if (!requireNamespace("readr", quietly = TRUE)) {
	install.packages("readr", repos="http://cran.us.r-project.org")
}
library(readr)
if (!requireNamespace("s2", quietly = TRUE)) {
	install.packages("s2", repos="http://cran.us.r-project.org")
}
library(s2)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("stats", quietly = TRUE)) {
	install.packages("stats", repos="http://cran.us.r-project.org")
}
library(stats)
if (!requireNamespace("stringi", quietly = TRUE)) {
	install.packages("stringi", repos="http://cran.us.r-project.org")
}
library(stringi)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)
if (!requireNamespace("tidyselect", quietly = TRUE)) {
	install.packages("tidyselect", repos="http://cran.us.r-project.org")
}
library(tidyselect)
if (!requireNamespace("timechange", quietly = TRUE)) {
	install.packages("timechange", repos="http://cran.us.r-project.org")
}
library(timechange)
if (!requireNamespace("tzdb", quietly = TRUE)) {
	install.packages("tzdb", repos="http://cran.us.r-project.org")
}
library(tzdb)
if (!requireNamespace("units", quietly = TRUE)) {
	install.packages("units", repos="http://cran.us.r-project.org")
}
library(units)
if (!requireNamespace("vroom", quietly = TRUE)) {
	install.packages("vroom", repos="http://cran.us.r-project.org")
}
library(vroom)
if (!requireNamespace("wk", quietly = TRUE)) {
	install.packages("wk", repos="http://cran.us.r-project.org")
}
library(wk)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_output_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_parameters"), action="store", default=NA, type="character", help="my description"), 
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
print("Retrieving param_simulation")
var = opt$param_simulation
print(var)
var_len = length(var)
print(paste("Variable param_simulation has length", var_len))

param_simulation <- gsub("\"", "", opt$param_simulation)


print("Running the cell")

print(param_input_dir)
print(param_output_dir)
print(param_buffer)
print(param_map)
print(param_lookup_table)
print(param_locations)
print(param_parameters)
print(param_simulation)
