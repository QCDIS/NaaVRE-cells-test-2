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
options(warn=0)

benchmark_code <- function() {
    1 + 1
}

cpu_results <- list()

for (benchmark in benchmarks) {
    benchmark_num_string <- sub(".*_(\\d+)$", "\\1", benchmark)
    benchmark_num <- as.integer(benchmark_num_string)

    if (grepl("MEM", benchmark, fixed = TRUE)) {



    } else if (grepl("CPU", benchmark, fixed = TRUE)) {
        start_time <- proc.time()
        benchmark_code()
        end_time <- proc.time()

        cpu_time <- end_time - start_time

        new_results <- list(cpu_time = cpu_time)
        cpu_results <- c(cpu_results, new_results)
    } else {
        print("################# No benchmark type specified! #################")
    }
}
# capturing outputs
print('Serialization of cpu_results')
file <- file(paste0('/tmp/cpu_results_', id, '.json'))
writeLines(toJSON(cpu_results, auto_unbox=TRUE), file)
close(file)
