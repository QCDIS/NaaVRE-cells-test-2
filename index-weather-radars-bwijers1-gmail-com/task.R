setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("getRad", quietly = TRUE)) {
	install.packages("getRad", repos="http://cran.us.r-project.org")
}
library(getRad)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--odimcode"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_country"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving odimcode")
var = opt$odimcode
print(var)
var_len = length(var)
print(paste("Variable odimcode has length", var_len))

odimcode <- gsub("\"", "", opt$odimcode)
print("Retrieving param_country")
var = opt$param_country
print(var)
var_len = length(var)
print(paste("Variable param_country has length", var_len))

param_country <- gsub("\"", "", opt$param_country)


print("Running the cell")





library("getRad")
library("tidyr")


odim_codes <- getRad::weather_radars() |>
    dplyr::filter(
        country == param_country, status == 1
    ) |>
    dplyr::select(odimcode)
odim_codes = list(odim_codes)
# capturing outputs
print('Serialization of odim_codes')
file <- file(paste0('/tmp/odim_codes_', id, '.json'))
writeLines(toJSON(odim_codes, auto_unbox=TRUE), file)
close(file)
