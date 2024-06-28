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

make_option(c("--Benthic_xy"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Pelagic_xy"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Rad_bottom"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--Sediment_Ems"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving Benthic_xy")
var = opt$Benthic_xy
print(var)
var_len = length(var)
print(paste("Variable Benthic_xy has length", var_len))

print("------------------------Running var_serialization for Benthic_xy-----------------------")
print(opt$Benthic_xy)
Benthic_xy = var_serialization(opt$Benthic_xy)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving Pelagic_xy")
var = opt$Pelagic_xy
print(var)
var_len = length(var)
print(paste("Variable Pelagic_xy has length", var_len))

print("------------------------Running var_serialization for Pelagic_xy-----------------------")
print(opt$Pelagic_xy)
Pelagic_xy = var_serialization(opt$Pelagic_xy)
print("---------------------------------------------------------------------------------")

print("Retrieving Rad_bottom")
var = opt$Rad_bottom
print(var)
var_len = length(var)
print(paste("Variable Rad_bottom has length", var_len))

print("------------------------Running var_serialization for Rad_bottom-----------------------")
print(opt$Rad_bottom)
Rad_bottom = var_serialization(opt$Rad_bottom)
print("---------------------------------------------------------------------------------")

print("Retrieving Sediment_Ems")
var = opt$Sediment_Ems
print(var)
var_len = length(var)
print(paste("Variable Sediment_Ems has length", var_len))

print("------------------------Running var_serialization for Sediment_Ems-----------------------")
print(opt$Sediment_Ems)
Sediment_Ems = var_serialization(opt$Sediment_Ems)
print("---------------------------------------------------------------------------------")



print("Running the cell")

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
