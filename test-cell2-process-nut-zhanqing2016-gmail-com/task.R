setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--df_list"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving df_list")
var = opt$df_list
print(var)
var_len = length(var)
print(paste("Variable df_list has length", var_len))

print("------------------------Running var_serialization for df_list-----------------------")
print(opt$df_list)
df_list = var_serialization(opt$df_list)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")


processed_df <- list()
for (df in df_list) {
    df[,"PLoad"] <- df[,"PLoad"] * 2
    df[,"Chla"] <- df[,"Chla"] * 100
    processed_df <- append(processed_df, list(df))
}
processed_df
# capturing outputs
print('Serialization of processed_df')
file <- file(paste0('/tmp/processed_df_', id, '.json'))
writeLines(toJSON(processed_df, auto_unbox=TRUE), file)
close(file)
