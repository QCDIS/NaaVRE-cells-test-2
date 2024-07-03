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
make_option(c("--cppfile"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--irrad"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_key"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description"), 
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
print("Retrieving cppfile")
var = opt$cppfile
print(var)
var_len = length(var)
print(paste("Variable cppfile has length", var_len))

cppfile <- gsub("\"", "", opt$cppfile)
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
print("Retrieving param_s3_access_key")
var = opt$param_s3_access_key
print(var)
var_len = length(var)
print(paste("Variable param_s3_access_key has length", var_len))

param_s3_access_key <- gsub("\"", "", opt$param_s3_access_key)
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving param_s3_secret_key")
var = opt$param_s3_secret_key
print(var)
var_len = length(var)
print(paste("Variable param_s3_secret_key has length", var_len))

param_s3_secret_key <- gsub("\"", "", opt$param_s3_secret_key)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)
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

require(plot3D)
palette("Dark2")
options(width = 120)

install.packages("aws.s3")
library("aws.s3")

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

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

sourceCpp(file = cppfile)  # compiles the C++ code and loads the functions

print("STARTING FIRST CULCATIONS")
system.time(
  ppPel <- intPP_mixed(Bat_xyv$depth, 
                 as.matrix(WKd_Ems    [, -1]), 
                 as.matrix(Irrad_Ems  [, -1]), 
                 as.matrix(WAlpha_Ems [, -1]), 
                 as.matrix(WEopt_Ems  [, -1]), 
                 as.matrix(WPs_Ems    [, -1]), 
                 as.matrix(WHeight_Ems[, -1]))
)

system.time(
  Rad <- rad_bot(Bat_xyv$depth, 
                 as.matrix(WKd_Ems     [, -1]), 
                 as.matrix(Irrad_Ems  [, -1]), 
                 as.matrix(WHeight_Ems[, -1]))
)

zn <- 0.002  # depth of chlorophyll layer

system.time(
  ppBen <- intPP_exp(as.vector(rep(zn, times = nrow(Bat_xyv))), 
                    as.vector(Sediment_Ems$Kd), 
                    as.vector(Sediment_Ems$silt/100),
                    as.matrix(Rad), 
                    as.matrix(BAlpha_Ems      [, -1]), 
                    as.matrix(BEopt_Ems       [, -1]), 
                    as.matrix(BPs_Ems         [, -1]))
)

print("STARTING SECOND CULCATIONS")
Pelagic_t <- apply(ppPel, MARGIN = 1, FUN = mean)
Benthic_t <- apply(ppBen, MARGIN = 1, FUN = mean)

Pelagic_xy <- data.frame(Bat_xyv, # longitude, latitude, depth
                         ppPel = apply(ppPel, MARGIN = 2, FUN = mean))
Benthic_xy <- data.frame(Bat_xyv, 
                         ppBen = apply(ppBen, MARGIN = 2, FUN = mean))
Rad_bottom <- data.frame(Bat_xyv, rad = colMeans(Rad))

print("SAVING FILES")

print("STARTING VISUALIZATIONS")
png("output_plot.png", width = 1600, height = 1200)

par(mfrow=c(2,3))
with(Pelagic_xy, 
   points2D(longitude, latitude, colvar=depth, 
         main = "water depth", clab= "m",
         asp=1.8, pch=".", cex=4))

with(Pelagic_xy, 
   points2D(longitude, latitude, colvar=ppPel, 
         main = "Pelagic Photosynthesis", clab="mgC/m2/h",
         asp=1.8, pch=".", cex=4))

with(Benthic_xy, 
   points2D(longitude, latitude, colvar=ppBen, 
         main = "Benthic Photosynthesis", clab="mgC/m2/h", 
         asp=1.8, pch=".", cex=4))

with(Rad_bottom, 
   points2D(longitude, latitude, colvar=rad, 
         main = "Radiation at bottom", clab="uE/m2/s",
         asp=1.8, pch=".", cex=4))

with(Sediment_Ems, 
   points2D(longitude, latitude, colvar=Kd, 
         main = "Sediment extinction", clab="/m",
         asp=1.8, pch=".", cex=4))

dev.off()

print("SAVING FILE TO OBJECT STORAGE")
put_object(region="", bucket="naa-vre-user-data", file="output_plot.png", object=paste0(param_s3_user_prefix, "/outputs/output_plot.png"))
