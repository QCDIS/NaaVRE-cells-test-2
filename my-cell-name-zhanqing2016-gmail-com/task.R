setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--testFile"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving testFile")
var = opt$testFile
print(var)
var_len = length(var)
print(paste("Variable testFile has length", var_len))

testFile <- gsub("\"", "", opt$testFile)


print("Running the cell")

plotVals <- function(data,         # the dataset
                     stat = 1,     # name of station to be plotted
                     val  = 2,     # name of value to be plotted
                     std  = NULL,  # name of standard error to be plotted (if NULL: min-max)
                     main = paste("Station", stat), 
                     ylab = val, 
                     ...){
  
  dat  <- subset(data, subset=station == stat)
  
  mean <- aggregate(x   = dat[, val], 
                    by  = list(dat[, "date"]), 
                    FUN = mean) 
  
  if (is.null(std)){
    min <- aggregate(dat[, val], by=list(dat[, "date"]), FUN = min)[,2]
    max <- aggregate(dat[, val], by=list(dat[, "date"]), FUN = max)[,2]
  
  } else { # use standard error
      
    stdev <- aggregate(dat[, std], by=list(dat[, "date"]), FUN=mean, na.rm=TRUE)
    
    min <- mean[,2] - stdev[,2]
    max <- mean[,2] + stdev[,2]
  }
  
  
  yrange <- range(c(max, min), na.rm=TRUE)
  plot(mean[,1], mean[,2], 
       main = main, xlab = "time", ylab = ylab,
       type = "b", pch = 16, ylim = yrange, 
       ...)
  arrows(mean[,1], min, mean[,1], max, 
         code = 3, length = 0.02, angle = 90)
}


readEms <- function(File, keep=NULL){
  Dir      <- "/home/jovyan/C14/readEMSdata/Benthic"
  Data    <- read.csv2(file = paste(Dir, File, sep="/")) 
  if (ncol(Data) == 1)
    Data    <- read.csv(file = paste(Dir, File, sep="/")) 
  if (! is.null(keep))
    Data <- Data[,keep]
  Data
}

B_Chl <- readEms(testFile) 
head(B_Chl)
B_Chl <- B_Chl[ ,c("Station", "Date", "ug.chla.g_Sed", "ChlaSed_mgm2")]

B_Chl$Date <- as.Date(B_Chl$Date, format="%d/%m/%Y")

colnames(B_Chl) <- c("station", "date", "Chl_sed_ug.g", "Chl_sed_mg.m2")

B_ChlVar <- data.frame(variable = c("Chl_sed_ug.g",   "Chl_sed_mg.m2"), 
                         unit   = c("ug Chl a/g sed", "mg Chl a/m2"),
                         method = c("Spectrophotometric measurements", 
                                    "Spectrophotometric - converted to areal, based on sediment density"),
                         description=c("Chlorophyll a concentration, per g bulk sediment in the top 0.5 cm", 
                                       "Sediment surface-integrated Chlorophyll a concentration (0.5 cm0"),
                         ref =  "https://library.wur.nl/WebQuery/wurpubs/489709")

summary(B_Chl)
attributes(B_Chl)$station   <- bstat
attributes(B_Chl)$variables <- B_ChlVar
# capturing outputs
print('Serialization of B_Chl')
file <- file(paste0('/tmp/B_Chl_', id, '.json'))
writeLines(toJSON(B_Chl, auto_unbox=TRUE), file)
close(file)
