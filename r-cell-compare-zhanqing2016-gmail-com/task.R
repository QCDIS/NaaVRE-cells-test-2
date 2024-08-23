setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)

secret_github_auth_token = Sys.getenv('secret_github_auth_token')
secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--rws_file_path"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--RWSstations"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving rws_file_path")
var = opt$rws_file_path
print(var)
var_len = length(var)
print(paste("Variable rws_file_path has length", var_len))

rws_file_path <- gsub("\"", "", opt$rws_file_path)
print("Retrieving RWSstations")
var = opt$RWSstations
print(var)
var_len = length(var)
print(paste("Variable RWSstations has length", var_len))

print("------------------------Running var_serialization for RWSstations-----------------------")
print(opt$RWSstations)
RWSstations = var_serialization(opt$RWSstations)
print("---------------------------------------------------------------------------------")



print("Running the cell")

station_info = RWSstations[[1]]

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

require(lubridate)

devtools::install_github("LTER-LIFE/dtR/dtLife",depend=TRUE, force=TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=FALSE, force=TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=FALSE, force=TRUE, auth_token=secret_github_auth_token)

require(dtLife)
require(dtWad)
require(dtPP)

file_path <- paste0("/tmp/data/",station_info$Code,"Chl_2021.csv",sep="")

Wad_biogeo_RWS <- read.csv(file_path)

for (std in plot_RWSstations) {
    
    
    if (std == "DANTZGT"){
        acolite_std_name <- "DANTZGND"}
    else if(std == "DOOVBWT"){
        acolite_std_name <- "DOOVWST"}else{
        acolite_std_name <- std}
    
    acolite_file <- paste0(acolite_std_name,"_2021.csv")
    
    save_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=paste0("/tmp/data/",acolite_file), 
    object= paste0("/waterinfo_RWS/acolite_processed_data/",acolite_file))
    
    acolite_data <- read.csv(paste0("/tmp/data/",acolite_file))
    acolite_data$time <- ymd_hms(acolite_data$time)
 
    fig_out = paste0("/tmp/data/",std,"_2021.png")
    png(fig_out)
    plot(Wad_biogeo_RWS$datetime[which(Wad_biogeo_RWS$LocatieCode==std)], 
     Wad_biogeo_RWS$Chl[which(Wad_biogeo_RWS$LocatieCode==std)],type="o",pch=19,
    col="black",xlab = "2021", ylab = "Chl (ug/l)", main = std)
    
    points(acolite_data$time, acolite_data$chl_re_gons,type="p",col="red",pch=19,cex=1.6)
    dev.off()
    
    put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_out, 
    object=paste0("/waterinfo_RWS/plots/",std,"_2021_2021.png"))
}

print_RWSstations <- list(plot_RWSstations)
# capturing outputs
print('Serialization of print_RWSstations')
file <- file(paste0('/tmp/print_RWSstations_', id, '.json'))
writeLines(toJSON(print_RWSstations, auto_unbox=TRUE), file)
close(file)
