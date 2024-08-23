setwd('/app')
library(optparse)
library(jsonlite)



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


RWSstations <- list(
  list(Code = "DANTZGT", X = 681288.275516119, Y = 5920359.91317053),
  list(Code = "DOOVBWT", X = 636211.321319897, Y = 5880086.51911216),
  list(Code = "MARSDND", X = 617481.059435953, Y = 5871760.70559602),
  list(Code = "VLIESM", X = 643890.614308217, Y = 5909304.23136001)
)
RWSstations
# capturing outputs
print('Serialization of RWSstations')
file <- file(paste0('/tmp/RWSstations_', id, '.json'))
writeLines(toJSON(RWSstations, auto_unbox=TRUE), file)
close(file)
