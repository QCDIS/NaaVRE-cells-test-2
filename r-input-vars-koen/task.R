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
name = "Napoli"
number = 4
float = 4.1
# capturing outputs
print('Serialization of float')
file <- file(paste0('/tmp/float_', id, '.json'))
writeLines(toJSON(float, auto_unbox=TRUE), file)
close(file)
print('Serialization of name')
file <- file(paste0('/tmp/name_', id, '.json'))
writeLines(toJSON(name, auto_unbox=TRUE), file)
close(file)
print('Serialization of number')
file <- file(paste0('/tmp/number_', id, '.json'))
writeLines(toJSON(number, auto_unbox=TRUE), file)
close(file)
