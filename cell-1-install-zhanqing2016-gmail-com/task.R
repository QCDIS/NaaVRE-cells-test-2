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

secret_github_auth_token = Sys.getenv('secret_github_auth_token')
secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

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


devtools::install_github("LTER-LIFE/dtR/dtLife",depend=TRUE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)

require(dtLife)
require(dtWad)
require(dtPP)

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )




stns <- c("huisdnbsd", "marsdnd", "helsdr", "malzn", "doovbwt",     
"vliesm",   "westmp",    "blauwsot",    "harlghvmwt", "harlgvhvn",  
"oostmp",   "boschgwt", "borndp", "dantzgnd", "dantzgt", "holwdbg",   
"zoutkplzgt", "zoutkplg", "lauwohvmd", "eildbg", "lauws",       
"zuidolwnot", "zuidolwot", "noordpdzl", "ra"          )
dgN <- c( 52.96, 52.98, 52.96, 52.99,
 53.05, 53.31, 53.29, 53.22,
    53.18,  53.17, 53.31, 53.40, 53.44,
 53.40, 53.40, 53.45,   53.48,
 53.43, 53.41, 53.47, 53.52,    53.48, 53.45, 53.45, 53.48)
 
dgE <- c(   4.73,   4.75,   4.75,   4.90,   5.03,   5.16,   5.23,   5.28,
    5.40,   5.41,   5.41,   5.50,   5.60,   5.72,   5.73,   5.96,
    6.08,   6.13,   6.20,   6.34, 6.44, 6.45,   6.51,   6.60,   6.66) 

RWSstations <- data.frame(station=stns, latitude=dgN, longitude=dgE)
save(file="/tmp/data/RWSstations.rda", RWSstations)

put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file="/tmp/data/RWSstations.rda", 
    object="/waterinfo_RWS/processed_data/RWSstations.rda")



















put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file="/tmp/data/RWSbiogeo.rda", 
    object="/waterinfo_RWS/processed_data/RWSbiogeo.rda")

fig_out_all_data = "/tmp/data/all_data.png"
png(fig_out_all_data)
par(mar=c(3,4,3,1), las=1)
plot(RWSbiogeo, type="l", cvar="station", mfrow=c(4,4))
dev.off()

put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_out_all_data, 
    object="/waterinfo_RWS/plots/all_data.png")

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
    object="/waterinfo_RWS/plots/wad_stations.png")
# capturing outputs
print('Serialization of stations')
file <- file(paste0('/tmp/stations_', id, '.json'))
writeLines(toJSON(stations, auto_unbox=TRUE), file)
close(file)
print('Serialization of LS')
file <- file(paste0('/tmp/LS_', id, '.json'))
writeLines(toJSON(LS, auto_unbox=TRUE), file)
close(file)
