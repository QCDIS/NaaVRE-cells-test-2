setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("knitr", quietly = TRUE)) {
	install.packages("knitr", repos="http://cran.us.r-project.org")
}
library(knitr)


print('option_list')
option_list = list(

make_option(c("--B_Chl"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving B_Chl")
var = opt$B_Chl
print(var)
var_len = length(var)
print(paste("Variable B_Chl has length", var_len))

print("------------------------Running var_serialization for B_Chl-----------------------")
print(opt$B_Chl)
B_Chl = var_serialization(opt$B_Chl)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


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
fig_out = "/tmp/data/B_Chl_Test.png"
png(fig_out)
plotVals(B_Chl, stat =1, val= "Chl_sed_mg.m2")
dev.off()
# capturing outputs
print('Serialization of fig_out')
file <- file(paste0('/tmp/fig_out_', id, '.json'))
writeLines(toJSON(fig_out, auto_unbox=TRUE), file)
close(file)
