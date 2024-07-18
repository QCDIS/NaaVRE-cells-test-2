setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--benchmarks"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving benchmarks")
var = opt$benchmarks
print(var)
var_len = length(var)
print(paste("Variable benchmarks has length", var_len))

print("------------------------Running var_serialization for benchmarks-----------------------")
print(opt$benchmarks)
benchmarks = var_serialization(opt$benchmarks)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")

for (benchmark in benchmarks) {
    benchmark_num_string <- sub(".*_(\\d+)$", "\\1", benchmark)
    print(benchmark_num_string)
    benchmark_num <- as.integer(benchmark_num_string)

    if (grepl("MEM", benchmark, fixed = TRUE)) {
        print(paste("Performing MEMORY benchmark ", benchmark_num_string))



    } else if (grepl("CPU", benchmark, fixed = TRUE)) {
    print(paste("Performing CPU benchmark ", benchmark_num_string))

    } else {
        print("################# No benchmark type specified! #################")
    }
}
