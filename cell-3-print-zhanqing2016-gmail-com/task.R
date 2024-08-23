setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)

secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--print_RWSstations"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving print_RWSstations")
var = opt$print_RWSstations
print(var)
var_len = length(var)
print(paste("Variable print_RWSstations has length", var_len))

print("------------------------Running var_serialization for print_RWSstations-----------------------")
print(opt$print_RWSstations)
print_RWSstations = var_serialization(opt$print_RWSstations)
print("---------------------------------------------------------------------------------")



print("Running the cell")
plot_RWSstations <- c("DANTZGT","DOOVBWT","MARSDND","VLIESM")
print_RWSstations <- list(plot_RWSstations)
output_file <- "/tmp/data/output.txt"

output_results <- c()

for (name in print_RWSstations){

    up_res <- sprintf("Hello, %s!",name)
output_results <- c(output_results, up_res)
}

writeLines(text = output_results, output_file)


    put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=output_file, 
    object=paste0("/waterinfo_RWS/plots/output.txt"))

# capturing outputs
print('Serialization of output_results')
file <- file(paste0('/tmp/output_results_', id, '.json'))
writeLines(toJSON(output_results, auto_unbox=TRUE), file)
close(file)
