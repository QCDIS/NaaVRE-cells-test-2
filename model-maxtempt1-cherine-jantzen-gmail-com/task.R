setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("glmmTMB", quietly = TRUE)) {
	install.packages("glmmTMB", repos="http://cran.us.r-project.org")
}
library(glmmTMB)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--ls_by_window"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving ls_by_window")
var = opt$ls_by_window
print(var)
var_len = length(var)
print(paste("Variable ls_by_window has length", var_len))

print("------------------------Running var_serialization for ls_by_window-----------------------")
print(opt$ls_by_window)
ls_by_window = var_serialization(opt$ls_by_window)
print("---------------------------------------------------------------------------------")



print("Running the cell")


model_maxTempT1 <- function(datfr) {
  
  output <- glmmTMB::glmmTMB(TotalNuts ~ 
                               sun_sumSummer_T1 +
                               temp_meanGrow + meanMaxWinTemp + temp_meanMaxSummer_T2 + 
                               prec_sumGrow + prec_sumSummer_T1  + prec_sumSummer_T2 + 
                               ar1(factor_year + 0|TreeID) + (1|TreeID),
                             data = datfr,
                             family = nbinom2(link = "log"),
                             ziformula = ~ .) %>%  
    summary()
}


summary_maxTempT1 <- lapply(ls_by_window, model_maxTempT1)
# capturing outputs
print('Serialization of summary_maxTempT1')
file <- file(paste0('/tmp/summary_maxTempT1_', id, '.json'))
writeLines(toJSON(summary_maxTempT1, auto_unbox=TRUE), file)
close(file)
