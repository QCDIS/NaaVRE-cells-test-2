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
if (!requireNamespace("dtLife", quietly = TRUE)) {
	install.packages("dtLife", repos="http://cran.us.r-project.org")
}
library(dtLife)
if (!requireNamespace("dtPP", quietly = TRUE)) {
	install.packages("dtPP", repos="http://cran.us.r-project.org")
}
library(dtPP)
if (!requireNamespace("dtWad", quietly = TRUE)) {
	install.packages("dtWad", repos="http://cran.us.r-project.org")
}
library(dtWad)

secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--Filename"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving Filename")
var = opt$Filename
print(var)
var_len = length(var)
print(paste("Variable Filename has length", var_len))

Filename <- gsub("\"", "", opt$Filename)
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


print("Running the cell")

devtools::install_github("LTER-LIFE/dtR/dtLife", depend=TRUE)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=TRUE)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=TRUE)
require(dtLife)
require(dtWad)
require(dtPP)

Filename = "RWSbiogeo.rda"

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

save_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=paste0("/tmp/data/",Filename), 
    object="/waterinfo_RWS/processed_data/RWSbiogeo.rda")

load("/tmp/data/RWSbiogeo.rda")

fig_out_all_data = "/tmp/data/all_data.png"
png(fig_out_all_data)
par(mar=c(3,4,3,1), las=1)
plot(RWSbiogeo, type="l", cvar="station", mfrow=c(4,4))
dev.off()

put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_out_all_data, 
    object="/plots/all_data.png")


fig_out_wad_stations = "/tmp/data/wad_stations.png"
png(fig_out_wad_stations)
stats <- attributes(RWSbiogeo)$stations
plotBathymetry(WadDepth, 
               pts=stats[,c("longitude", "latitude")], 
               ptlist=list(cex=3, col= "white"), NAcol="grey", type="image",
               main="Biogeochemistry stations")
text(stats$longitude, stats$latitude, labels=1:nrow(stats), cex=0.7)
nr <- nrow(stats)
legend("bottomright", legend=c(1:(nr/2), stats$station[1:(nr/2)], 
                              (nr/2+1):nr, stats$station[(nr/2+1):nr]), 
       ncol=4, cex=0.5)
dev.off()

put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_out_wad_stations, 
    object="/plots/wad_stations.png")
# capturing outputs
print('Serialization of fig_out_all_data')
file <- file(paste0('/tmp/fig_out_all_data_', id, '.json'))
writeLines(toJSON(fig_out_all_data, auto_unbox=TRUE), file)
close(file)
print('Serialization of fig_out_wad_stations')
file <- file(paste0('/tmp/fig_out_wad_stations_', id, '.json'))
writeLines(toJSON(fig_out_wad_stations, auto_unbox=TRUE), file)
close(file)
