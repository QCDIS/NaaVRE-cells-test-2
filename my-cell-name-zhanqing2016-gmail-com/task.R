setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--File"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving File")
var = opt$File
print(var)
var_len = length(var)
print(paste("Variable File has length", var_len))

File <- gsub("\"", "", opt$File)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")

readEms <- function(File, keep=NULL){
  Dir      <- "/home/jovyan/C14/readEMSdata/Benthic"
  Data    <- read.csv2(file = paste(Dir, File, sep="/")) 
  if (ncol(Data) == 1)
    Data    <- read.csv(file = paste(Dir, File, sep="/")) 
  if (! is.null(keep))
    Data <- Data[,keep]
  Data
}
# capturing outputs
print('Serialization of Data')
file <- file(paste0('/tmp/Data_', id, '.json'))
writeLines(toJSON(Data, auto_unbox=TRUE), file)
close(file)
