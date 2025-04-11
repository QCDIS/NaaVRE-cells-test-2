setwd('/app')
library(optparse)
library(jsonlite)




print('option_list')
option_list = list(

make_option(c("--floats"), action="store", default=NA, type="character", help="my description"),
make_option(c("--names"), action="store", default=NA, type="character", help="my description"),
make_option(c("--numbers"), action="store", default=NA, type="character", help="my description"),
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

print("Retrieving floats")
var = opt$floats
print(var)
var_len = length(var)
print(paste("Variable floats has length", var_len))

print("------------------------Running var_serialization for floats-----------------------")
print(opt$floats)
floats = var_serialization(opt$floats)
print("---------------------------------------------------------------------------------")

print("Retrieving names")
var = opt$names
print(var)
var_len = length(var)
print(paste("Variable names has length", var_len))

print("------------------------Running var_serialization for names-----------------------")
print(opt$names)
names = var_serialization(opt$names)
print("---------------------------------------------------------------------------------")

print("Retrieving numbers")
var = opt$numbers
print(var)
var_len = length(var)
print(paste("Variable numbers has length", var_len))

print("------------------------Running var_serialization for numbers-----------------------")
print(opt$numbers)
numbers = var_serialization(opt$numbers)
print("---------------------------------------------------------------------------------")

id <- gsub('"', '', opt$id)


print("Running the cell")
for (name in names) {
  print(sprintf("Hello, %s!", name))
}
for (number in numbers) {
  print(sprintf("This is number %i", number))
}
for (float in floats) {
    print(sprintf("This is a decimal %f", float))
}
