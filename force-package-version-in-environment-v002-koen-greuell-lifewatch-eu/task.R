setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("bioRad", quietly = TRUE)) {
	install.packages("bioRad", repos="http://cran.us.r-project.org")
}
library(bioRad)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("getRad", quietly = TRUE)) {
	install.packages("getRad", repos="http://cran.us.r-project.org")
}
library(getRad)
if (!requireNamespace("remotes", quietly = TRUE)) {
	install.packages("remotes", repos="http://cran.us.r-project.org")
}
library(remotes)
if (!requireNamespace("vol2birdR", quietly = TRUE)) {
	install.packages("vol2birdR", repos="http://cran.us.r-project.org")
}
library(vol2birdR)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_package"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_version"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_package")
var = opt$param_package
print(var)
var_len = length(var)
print(paste("Variable param_package has length", var_len))

param_package <- gsub("\"", "", opt$param_package)
print("Retrieving param_version")
var = opt$param_version
print(var)
var_len = length(var)
print(paste("Variable param_version has length", var_len))

param_version <- gsub("\"", "", opt$param_version)


print("Running the cell")
remotes::install_version(package = param_package, version=param_version, repos = "https://cloud.r-project.org/")
package_name <- param_package
# capturing outputs
print('Serialization of package_name')
file <- file(paste0('/tmp/package_name_', id, '.json'))
writeLines(toJSON(package_name, auto_unbox=TRUE), file)
close(file)
