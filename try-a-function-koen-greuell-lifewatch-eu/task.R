setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("getPass", quietly = TRUE)) {
	install.packages("getPass", repos="http://cran.us.r-project.org")
}
library(getPass)
if (!requireNamespace("rstudioapi", quietly = TRUE)) {
	install.packages("rstudioapi", repos="http://cran.us.r-project.org")
}
library(rstudioapi)


print('option_list')
option_list = list(

make_option(c("--a"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving a")
var = opt$a
print(var)
var_len = length(var)
print(paste("Variable a has length", var_len))

a <- gsub("\"", "", opt$a)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")
get_password <- function() {
cat("Password: ")
system("stty -echo")
a <- readline()
system("stty echo")
cat("\n")
return(a)
}
