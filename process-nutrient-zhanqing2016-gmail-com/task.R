setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--P_loads"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving P_loads")
var = opt$P_loads
print(var)
var_len = length(var)
print(paste("Variable P_loads has length", var_len))

print("------------------------Running var_serialization for P_loads-----------------------")
print(opt$P_loads)
P_loads = var_serialization(opt$P_loads)
print("---------------------------------------------------------------------------------")



print("Running the cell")


new_Ploads = list()
for (P_load in P_loads){
    new_Pload = P_load*2000+1
    new_Ploads = append(new_Ploads, new_Pload)
}
    
# capturing outputs
print('Serialization of new_Ploads')
file <- file(paste0('/tmp/new_Ploads_', id, '.json'))
writeLines(toJSON(new_Ploads, auto_unbox=TRUE), file)
close(file)
