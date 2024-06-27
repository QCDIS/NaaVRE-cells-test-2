setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("plot3D", quietly = TRUE)) {
	install.packages("plot3D", repos="http://cran.us.r-project.org")
}
library(plot3D)


print('option_list')
option_list = list(

make_option(c("--BAlpha_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Bat_xyv"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--BEopt_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--BPs_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--depth"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Irrad_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Kd"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--Sediment_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--silt"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--WAlpha_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--WEopt_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--WHeight_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--WKd_Ems"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--WPs_Ems"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving BAlpha_Ems")
var = opt$BAlpha_Ems
print(var)
var_len = length(var)
print(paste("Variable BAlpha_Ems has length", var_len))

print("------------------------Running var_serialization for BAlpha_Ems-----------------------")
print(opt$BAlpha_Ems)
BAlpha_Ems = var_serialization(opt$BAlpha_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving Bat_xyv")
var = opt$Bat_xyv
print(var)
var_len = length(var)
print(paste("Variable Bat_xyv has length", var_len))

print("------------------------Running var_serialization for Bat_xyv-----------------------")
print(opt$Bat_xyv)
Bat_xyv = var_serialization(opt$Bat_xyv)
print("---------------------------------------------------------------------------------")

print("Retrieving BEopt_Ems")
var = opt$BEopt_Ems
print(var)
var_len = length(var)
print(paste("Variable BEopt_Ems has length", var_len))

print("------------------------Running var_serialization for BEopt_Ems-----------------------")
print(opt$BEopt_Ems)
BEopt_Ems = var_serialization(opt$BEopt_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving BPs_Ems")
var = opt$BPs_Ems
print(var)
var_len = length(var)
print(paste("Variable BPs_Ems has length", var_len))

print("------------------------Running var_serialization for BPs_Ems-----------------------")
print(opt$BPs_Ems)
BPs_Ems = var_serialization(opt$BPs_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving depth")
var = opt$depth
print(var)
var_len = length(var)
print(paste("Variable depth has length", var_len))

depth = opt$depth
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving Irrad_Ems")
var = opt$Irrad_Ems
print(var)
var_len = length(var)
print(paste("Variable Irrad_Ems has length", var_len))

print("------------------------Running var_serialization for Irrad_Ems-----------------------")
print(opt$Irrad_Ems)
Irrad_Ems = var_serialization(opt$Irrad_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving Kd")
var = opt$Kd
print(var)
var_len = length(var)
print(paste("Variable Kd has length", var_len))

Kd = opt$Kd
print("Retrieving Sediment_Ems")
var = opt$Sediment_Ems
print(var)
var_len = length(var)
print(paste("Variable Sediment_Ems has length", var_len))

print("------------------------Running var_serialization for Sediment_Ems-----------------------")
print(opt$Sediment_Ems)
Sediment_Ems = var_serialization(opt$Sediment_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving silt")
var = opt$silt
print(var)
var_len = length(var)
print(paste("Variable silt has length", var_len))

silt = opt$silt
print("Retrieving WAlpha_Ems")
var = opt$WAlpha_Ems
print(var)
var_len = length(var)
print(paste("Variable WAlpha_Ems has length", var_len))

print("------------------------Running var_serialization for WAlpha_Ems-----------------------")
print(opt$WAlpha_Ems)
WAlpha_Ems = var_serialization(opt$WAlpha_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving WEopt_Ems")
var = opt$WEopt_Ems
print(var)
var_len = length(var)
print(paste("Variable WEopt_Ems has length", var_len))

print("------------------------Running var_serialization for WEopt_Ems-----------------------")
print(opt$WEopt_Ems)
WEopt_Ems = var_serialization(opt$WEopt_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving WHeight_Ems")
var = opt$WHeight_Ems
print(var)
var_len = length(var)
print(paste("Variable WHeight_Ems has length", var_len))

print("------------------------Running var_serialization for WHeight_Ems-----------------------")
print(opt$WHeight_Ems)
WHeight_Ems = var_serialization(opt$WHeight_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving WKd_Ems")
var = opt$WKd_Ems
print(var)
var_len = length(var)
print(paste("Variable WKd_Ems has length", var_len))

print("------------------------Running var_serialization for WKd_Ems-----------------------")
print(opt$WKd_Ems)
WKd_Ems = var_serialization(opt$WKd_Ems)
print("---------------------------------------------------------------------------------")

print("Retrieving WPs_Ems")
var = opt$WPs_Ems
print(var)
var_len = length(var)
print(paste("Variable WPs_Ems has length", var_len))

print("------------------------Running var_serialization for WPs_Ems-----------------------")
print(opt$WPs_Ems)
WPs_Ems = var_serialization(opt$WPs_Ems)
print("---------------------------------------------------------------------------------")



print("Running the cell")
require(Rcpp)
sourceCpp("intPP2D.cpp")  # compiles the C++ code and loads the functions

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
# capturing outputs
print('Serialization of ppPel')
file <- file(paste0('/tmp/ppPel_', id, '.json'))
writeLines(toJSON(ppPel, auto_unbox=TRUE), file)
close(file)
print('Serialization of Rad')
file <- file(paste0('/tmp/Rad_', id, '.json'))
writeLines(toJSON(Rad, auto_unbox=TRUE), file)
close(file)
print('Serialization of ppBen')
file <- file(paste0('/tmp/ppBen_', id, '.json'))
writeLines(toJSON(ppBen, auto_unbox=TRUE), file)
close(file)
