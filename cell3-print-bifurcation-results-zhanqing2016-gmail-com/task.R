setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("minioclient", quietly = TRUE)) {
	install.packages("minioclient", repos="http://cran.us.r-project.org")
}
library(minioclient)
if (!requireNamespace("processx", quietly = TRUE)) {
	install.packages("processx", repos="http://cran.us.r-project.org")
}
library(processx)

secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--bifur_output"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_server"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving bifur_output")
var = opt$bifur_output
print(var)
var_len = length(var)
print(paste("Variable bifur_output has length", var_len))

print("------------------------Running var_serialization for bifur_output-----------------------")
print(opt$bifur_output)
bifur_output = var_serialization(opt$bifur_output)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_s3_server")
var = opt$param_s3_server
print(var)
var_len = length(var)
print(paste("Variable param_s3_server has length", var_len))

param_s3_server <- gsub("\"", "", opt$param_s3_server)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)


print("Running the cell")



for (df_output in bifur_output){
    df <- read.csv(df_output)
    
    for (i in 1:nrow(df)){
    data_time = df[i,"time"]
    data_PLoad = df[i,"PLoad"]
    data_oChla = df[i,"oChla"]
    data_Secchi = df[i,"aSecchi"]
    
    sink(filename, append = T)
    cat(data_time)
    cat(",")
    cat(data_PLoad)
    cat(",")
    cat(data_oChla)
    cat(",")
    cat(data_Secchi)
    cat("\n")
    sink()
    }
}

output_filename = "/home/jovyan/PCLake_Naavre/PCLake_output.csv"

devtools::install_github("cboettig/minioclient")

library(minioclient)
install_mc()

library(processx)
processx::run("apt-get", "update", error_on_status=FALSE)
processx::run("apt-get", c("install", "-y", "ca-certificates"), error_on_status=FALSE)

mc_alias_set(
    alias = "scruffy",
    endpoint = param_s3_server,
    access_key = secret_s3_access_key,
    secret_key = secret_s3_secret_key,
)
mc_cp(output_filename, paste0("scruffy/naa-vre-user-data/", param_s3_user_prefix, "/PCLake_output.csv"))
      
      
      
      



