setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("libgit2", quietly = TRUE)) {
	install.packages("libgit2", repos="http://cran.us.r-project.org")
}
library(libgit2)
if (!requireNamespace("usethis", quietly = TRUE)) {
	install.packages("usethis", repos="http://cran.us.r-project.org")
}
library(usethis)

secret_github_auth_token = Sys.getenv('secret_github_auth_token')

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
install.packages("libgit2", repos='http://cran.us.r-project.org')
Sys.setenv(
    "GITHUB_PAT" = secret_github_auth_token
    )
