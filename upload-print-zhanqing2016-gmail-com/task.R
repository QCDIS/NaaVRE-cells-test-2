setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--res"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving res")
var = opt$res
print(var)
var_len = length(var)
print(paste("Variable res has length", var_len))

res <- gsub("\"", "", opt$res)


print("Running the cell")

directory <- "/home/jovyan/workflow_test"
file_name <- "print_output.txt"

file_path <- file.path(directory, file_name)

for (message in res){
    writeLines(message, file_path)
cat("Message saved to", file_path)
}
# capturing outputs
print('Serialization of he')
file <- file(paste0('/tmp/he_', id, '.json'))
writeLines(toJSON(he, auto_unbox=TRUE), file)
close(file)
