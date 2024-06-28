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

make_option(c("--Bat_xyv"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--ppBen"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--ppPel"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--Rad"), action="store", default=NA, type="numeric", help="my description")
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

print("Retrieving Bat_xyv")
var = opt$Bat_xyv
print(var)
var_len = length(var)
print(paste("Variable Bat_xyv has length", var_len))

Bat_xyv = opt$Bat_xyv
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving ppBen")
var = opt$ppBen
print(var)
var_len = length(var)
print(paste("Variable ppBen has length", var_len))

ppBen = opt$ppBen
print("Retrieving ppPel")
var = opt$ppPel
print(var)
var_len = length(var)
print(paste("Variable ppPel has length", var_len))

ppPel = opt$ppPel
print("Retrieving Rad")
var = opt$Rad
print(var)
var_len = length(var)
print(paste("Variable Rad has length", var_len))

Rad = opt$Rad


print("Running the cell")

Pelagic_t <- apply(ppPel, MARGIN = 1, FUN = mean)
Benthic_t <- apply(ppBen, MARGIN = 1, FUN = mean)

Pelagic_xy <- data.frame(Bat_xyv, # longitude, latitude, depth
                         ppPel = apply(ppPel, MARGIN = 2, FUN = mean))
Benthic_xy <- data.frame(Bat_xyv, 
                         ppBen = apply(ppBen, MARGIN = 2, FUN = mean))
Rad_bottom <- data.frame(Bat_xyv, rad = colMeans(Rad))

# capturing outputs
print('Serialization of Pelagic_t')
file <- file(paste0('/tmp/Pelagic_t_', id, '.json'))
writeLines(toJSON(Pelagic_t, auto_unbox=TRUE), file)
close(file)
print('Serialization of Benthic_t')
file <- file(paste0('/tmp/Benthic_t_', id, '.json'))
writeLines(toJSON(Benthic_t, auto_unbox=TRUE), file)
close(file)
print('Serialization of Pelagic_xy')
file <- file(paste0('/tmp/Pelagic_xy_', id, '.json'))
writeLines(toJSON(Pelagic_xy, auto_unbox=TRUE), file)
close(file)
print('Serialization of Benthic_xy')
file <- file(paste0('/tmp/Benthic_xy_', id, '.json'))
writeLines(toJSON(Benthic_xy, auto_unbox=TRUE), file)
close(file)
print('Serialization of Rad_bottom')
file <- file(paste0('/tmp/Rad_bottom_', id, '.json'))
writeLines(toJSON(Rad_bottom, auto_unbox=TRUE), file)
close(file)
