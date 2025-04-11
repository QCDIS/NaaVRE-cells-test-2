setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--float"), action="store", default=NA, type="numeric", help="my description"),
make_option(c("--name"), action="store", default=NA, type="character", help="my description"),
make_option(c("--number"), action="store", default=NA, type="integer", help="my description"),
make_option(c("--id"), action="store", default=NA, type="character", help="task id")
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

print("Retrieving float")
var = opt$float
print(var)
var_len = length(var)
print(paste("Variable float has length", var_len))

float = opt$float
print("Retrieving name")
var = opt$name
print(var)
var_len = length(var)
print(paste("Variable name has length", var_len))

name <- gsub("\"", "", opt$name)
print("Retrieving number")
var = opt$number
print(var)
var_len = length(var)
print(paste("Variable number has length", var_len))

number = opt$number
id <- gsub('"', '', opt$id)


print("Running the cell")
print(name)
print(number)
print(float)
