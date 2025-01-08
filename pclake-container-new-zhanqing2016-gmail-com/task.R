setwd('/app')
library(optparse)
library(jsonlite)


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

library(usethis)

b=3
Sys.setenv(
    "GITHUB_PAT" = secret_github_auth_token
    )


dest_dir <- "/tmp/data/pclake_Naavre"

if (!dir.exists(dest_dir)) {
  dir.create(dest_dir, recursive = TRUE)
}

usethis::create_from_github(repo_spec = "https://github.com/NIOZ-QingZ/PCModel/tree/PCLake_NaaVRE", destdir = "/tmp/data/pclake_Naavre", fork = FALSE)

dest_dir <- "/tmp/data/pclake_Naavre"
