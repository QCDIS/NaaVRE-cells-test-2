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

make_option(c("--batch_filenames"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving batch_filenames")
var = opt$batch_filenames
print(var)
var_len = length(var)
print(paste("Variable batch_filenames has length", var_len))

print("------------------------Running var_serialization for batch_filenames-----------------------")
print(opt$batch_filenames)
batch_filenames = var_serialization(opt$batch_filenames)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")


load(batch_filenames)

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


summary_maxTempT1 <- lapply(batch, model_maxTempT1)

summary_maxTempT1_file <- "/tmp/data/summary_maxTempT1.rda"
save(summary_maxTempT1, file = summary_maxTempT1_file)

model_output <- list(summary_maxTempT1_file)
# capturing outputs
print('Serialization of model_output')
file <- file(paste0('/tmp/model_output_', id, '.json'))
writeLines(toJSON(model_output, auto_unbox=TRUE), file)
close(file)
