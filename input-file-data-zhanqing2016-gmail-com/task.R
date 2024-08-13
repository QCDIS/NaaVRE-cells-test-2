setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("dtLife", quietly = TRUE)) {
	install.packages("dtLife", repos="http://cran.us.r-project.org")
}
library(dtLife)
if (!requireNamespace("dtPP", quietly = TRUE)) {
	install.packages("dtPP", repos="http://cran.us.r-project.org")
}
library(dtPP)
if (!requireNamespace("dtWad", quietly = TRUE)) {
	install.packages("dtWad", repos="http://cran.us.r-project.org")
}
library(dtWad)


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


Filename = "RWSbiogeo.rda"
# capturing outputs
print('Serialization of Filename')
file <- file(paste0('/tmp/Filename_', id, '.json'))
writeLines(toJSON(Filename, auto_unbox=TRUE), file)
close(file)
