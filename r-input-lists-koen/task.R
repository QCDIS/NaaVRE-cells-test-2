setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

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

id <- gsub('"', '', opt$id)


print("Running the cell")
names = list("Alice", "Bob")
numbers = list(1, 2)
floats = list(1.1, 1.2)
# capturing outputs
print('Serialization of floats')
file <- file(paste0('/tmp/floats_', id, '.json'))
writeLines(toJSON(floats, auto_unbox=TRUE), file)
close(file)
print('Serialization of names')
file <- file(paste0('/tmp/names_', id, '.json'))
writeLines(toJSON(names, auto_unbox=TRUE), file)
close(file)
print('Serialization of numbers')
file <- file(paste0('/tmp/numbers_', id, '.json'))
writeLines(toJSON(numbers, auto_unbox=TRUE), file)
close(file)
