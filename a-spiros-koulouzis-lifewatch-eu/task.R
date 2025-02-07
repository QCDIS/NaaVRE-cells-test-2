setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--avar"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving avar")
var = opt$avar
print(var)
var_len = length(var)
print(paste("Variable avar has length", var_len))

avar <- gsub("\"", "", opt$avar)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")

print(conf_a)
print(input_1)

b = 1 + 2 
# capturing outputs
print('Serialization of b')
file <- file(paste0('/tmp/b_', id, '.json'))
writeLines(toJSON(b, auto_unbox=TRUE), file)
close(file)
