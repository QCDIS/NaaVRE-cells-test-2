setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--num_cpu_benchmarks"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--num_mem_benchmarks"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving num_cpu_benchmarks")
var = opt$num_cpu_benchmarks
print(var)
var_len = length(var)
print(paste("Variable num_cpu_benchmarks has length", var_len))

num_cpu_benchmarks <- gsub("\"", "", opt$num_cpu_benchmarks)
print("Retrieving num_mem_benchmarks")
var = opt$num_mem_benchmarks
print(var)
var_len = length(var)
print(paste("Variable num_mem_benchmarks has length", var_len))

num_mem_benchmarks <- gsub("\"", "", opt$num_mem_benchmarks)


print("Running the cell")

benchmarks <- list()

for (i in 1:num_cpu_benchmarks) {
    benchmarks <- c(benchmarks, list(paste("CPU_BENCHMARK_", i)))
}

for (i in 1:num_mem_benchmarks) {
    benchmarks <- c(benchmarks, list(paste("MEM_BENCHMARK_", i)))
}
# capturing outputs
print('Serialization of benchmarks')
file <- file(paste0('/tmp/benchmarks_', id, '.json'))
writeLines(toJSON(benchmarks, auto_unbox=TRUE), file)
close(file)
