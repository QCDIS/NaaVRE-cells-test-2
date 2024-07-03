setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("plot3D", quietly = TRUE)) {
	install.packages("plot3D", repos="http://cran.us.r-project.org")
}
library(plot3D)


print('option_list')
option_list = list(

make_option(c("--balpha"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--beopt"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--bps"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--irrad"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--sediment"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--spatio"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--walpha"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--weopt"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--wheight"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--wkd"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--wps"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving balpha")
var = opt$balpha
print(var)
var_len = length(var)
print(paste("Variable balpha has length", var_len))

balpha <- gsub("\"", "", opt$balpha)
print("Retrieving beopt")
var = opt$beopt
print(var)
var_len = length(var)
print(paste("Variable beopt has length", var_len))

beopt <- gsub("\"", "", opt$beopt)
print("Retrieving bps")
var = opt$bps
print(var)
var_len = length(var)
print(paste("Variable bps has length", var_len))

bps <- gsub("\"", "", opt$bps)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving irrad")
var = opt$irrad
print(var)
var_len = length(var)
print(paste("Variable irrad has length", var_len))

irrad <- gsub("\"", "", opt$irrad)
print("Retrieving sediment")
var = opt$sediment
print(var)
var_len = length(var)
print(paste("Variable sediment has length", var_len))

sediment <- gsub("\"", "", opt$sediment)
print("Retrieving spatio")
var = opt$spatio
print(var)
var_len = length(var)
print(paste("Variable spatio has length", var_len))

spatio <- gsub("\"", "", opt$spatio)
print("Retrieving walpha")
var = opt$walpha
print(var)
var_len = length(var)
print(paste("Variable walpha has length", var_len))

walpha <- gsub("\"", "", opt$walpha)
print("Retrieving weopt")
var = opt$weopt
print(var)
var_len = length(var)
print(paste("Variable weopt has length", var_len))

weopt <- gsub("\"", "", opt$weopt)
print("Retrieving wheight")
var = opt$wheight
print(var)
var_len = length(var)
print(paste("Variable wheight has length", var_len))

wheight <- gsub("\"", "", opt$wheight)
print("Retrieving wkd")
var = opt$wkd
print(var)
var_len = length(var)
print(paste("Variable wkd has length", var_len))

wkd <- gsub("\"", "", opt$wkd)
print("Retrieving wps")
var = opt$wps
print(var)
var_len = length(var)
print(paste("Variable wps has length", var_len))

wps <- gsub("\"", "", opt$wps)


print("Running the cell")

require(Rcpp)

load(file = spatio)
load(file = wkd)
load(file = irrad)
load(file = walpha)
load(file = weopt)
load(file = wps)
load(file = wheight)
load(file = sediment)
load(file = balpha)
load(file = beopt)
load(file = bps)
