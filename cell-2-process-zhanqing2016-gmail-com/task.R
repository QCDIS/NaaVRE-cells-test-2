setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--names"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving names")
var = opt$names
print(var)
var_len = length(var)
print(paste("Variable names has length", var_len))

print("------------------------Running var_serialization for names-----------------------")
print(opt$names)
names = var_serialization(opt$names)
print("---------------------------------------------------------------------------------")



print("Running the cell")


output_names = list()
for (name in names){
    a = sprintf("Hello, %s!", name)
    output_names = append(output_names, a)
}
# capturing outputs
print('Serialization of output_names')
file <- file(paste0('/tmp/output_names_', id, '.json'))
writeLines(toJSON(output_names, auto_unbox=TRUE), file)
close(file)
