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


load(file = "../input_data/Spatio_temporal_settings.rda")
load(file = "../input_data/WKd_Ems.rda")
load(file = "../input_data/Irrad_Ems.rda")
load(file = "../input_data/WAlpha_Ems.rda")
load(file = "../input_data/WEopt_Ems.rda")
load(file = "../input_data/WPs_Ems.rda")
load(file = "../input_data/WHeight_Ems.rda")
load(file = "../input_data/Sediment_Ems.rda")
load(file = "../input_data/BAlpha_Ems.rda")
load(file = "../input_data/BEopt_Ems.rda")
load(file = "../input_data/BPs_Ems.rda")

depth <- Bat_xyv$depth
WKd <- WKd_Ems
Irrad <- Irrad_Ems
WAlpha <- WAlpha_Ems
WEopt <- WEopt_Ems
WPs <- WPs_Ems
WHeight <- WHeight_Ems
Sediment <- Sediment_Ems
BAlpha <- BAlpha_Ems
BEopt <- BEopt_Ems
BPs <- BPs_Ems


# capturing outputs
print('Serialization of depth')
file <- file(paste0('/tmp/depth_', id, '.json'))
writeLines(toJSON(depth, auto_unbox=TRUE), file)
close(file)
print('Serialization of WKd')
file <- file(paste0('/tmp/WKd_', id, '.json'))
writeLines(toJSON(WKd, auto_unbox=TRUE), file)
close(file)
print('Serialization of Irrad')
file <- file(paste0('/tmp/Irrad_', id, '.json'))
writeLines(toJSON(Irrad, auto_unbox=TRUE), file)
close(file)
print('Serialization of WAlpha')
file <- file(paste0('/tmp/WAlpha_', id, '.json'))
writeLines(toJSON(WAlpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of WEopt')
file <- file(paste0('/tmp/WEopt_', id, '.json'))
writeLines(toJSON(WEopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of WPs')
file <- file(paste0('/tmp/WPs_', id, '.json'))
writeLines(toJSON(WPs, auto_unbox=TRUE), file)
close(file)
print('Serialization of WHeight')
file <- file(paste0('/tmp/WHeight_', id, '.json'))
writeLines(toJSON(WHeight, auto_unbox=TRUE), file)
close(file)
print('Serialization of Sediment')
file <- file(paste0('/tmp/Sediment_', id, '.json'))
writeLines(toJSON(Sediment, auto_unbox=TRUE), file)
close(file)
print('Serialization of BAlpha')
file <- file(paste0('/tmp/BAlpha_', id, '.json'))
writeLines(toJSON(BAlpha, auto_unbox=TRUE), file)
close(file)
print('Serialization of BEopt')
file <- file(paste0('/tmp/BEopt_', id, '.json'))
writeLines(toJSON(BEopt, auto_unbox=TRUE), file)
close(file)
print('Serialization of BPs')
file <- file(paste0('/tmp/BPs_', id, '.json'))
writeLines(toJSON(BPs, auto_unbox=TRUE), file)
close(file)
