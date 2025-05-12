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
make_option(c("--odim_code"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving odim_code")
var = opt$odim_code
print(var)
var_len = length(var)
print(paste("Variable odim_code has length", var_len))

odim_code <- gsub("\"", "", opt$odim_code)


print("Running the cell")

library("getRad")
library("tidyr")

conf_de_max_days <- 3
conf_de_time_interval <- "5 mins"

conf_aloft_endpoint = ""
secret_aloft_access_key <- ""
secret_aloft_secret_key <- ""

expand_grid(
    times = seq(
        as.POSIXct(
            Sys.Date() - conf_de_max_days
        ), as.POSIXct(Sys.Date()), "5 mins"
    )
)



head(20) |>
    mutate(
        vp = purrr::map2(
            odimcode, times, ~ calculate_vp(
                calculate_param(
                    getRad::get_pvol(
                        .x, .y
                    ),
                    RHOHV = urhohv
                )
            )
        )
    )
