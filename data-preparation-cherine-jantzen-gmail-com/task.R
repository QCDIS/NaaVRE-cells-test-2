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

secret_minio_access_key = Sys.getenv('secret_minio_access_key')
secret_minio_secret_key = Sys.getenv('secret_minio_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_region"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_minio_user_prefix"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_minio_endpoint")
var = opt$param_minio_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_minio_endpoint has length", var_len))

param_minio_endpoint <- gsub("\"", "", opt$param_minio_endpoint)
print("Retrieving param_minio_region")
var = opt$param_minio_region
print(var)
var_len = length(var)
print(paste("Variable param_minio_region has length", var_len))

param_minio_region <- gsub("\"", "", opt$param_minio_region)
print("Retrieving param_minio_user_prefix")
var = opt$param_minio_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_minio_user_prefix has length", var_len))

param_minio_user_prefix <- gsub("\"", "", opt$param_minio_user_prefix)


print("Running the cell")

options(repos = c(CRAN = "https://cloud.r-project.org"))

install.packages("aws.s3")
install.packages("glmmTMB")
install.packages("dplyr")
install.packages("purrr")
install.packages("tidyr")

library(dplyr)
library(purrr)
library(tidyr)
library(glmmTMB)
library(aws.s3)
                 
Sys.setenv(
  "AWS_S3_ENDPOINT"  = param_minio_endpoint,
  "AWS_DEFAULT_REGION" = param_minio_region,
  "AWS_ACCESS_KEY_ID" = secret_minio_access_key,
  "AWS_SECRET_ACCESS_KEY" = secret_minio_secret_key
)

save_object(
  bucket = "naa-vre-user-data",
  object = paste0(param_minio_user_prefix, "/beechcrop-individualdata_processed.csv"),
  file = "di.csv"
)
                 
save_object(
  bucket = "naa-vre-user-data",
  object = paste0(param_minio_user_prefix, "/df_climate-processed-knmi-data.csv"),
  file = "df_climate.csv"
)

di <- read.csv("di.csv")
df_climate <- read.csv("df_climate.csv")

all_windows <- purrr::map(.x = c(7:214), # minimum window length 7 days, maximum length 214 days
                          .f = ~{
                            
                            window_length <- .x
                            
                            
                            temp_windows <- purrr::map(.x = (60:((274 + 1) - window_length)), 
                                                       .f = ~{
                                                         
                                                         df_climate %>% 
                                                           dplyr::group_by(year) %>% 
                                                           dplyr::slice(.x:(.x + (window_length - 1))) %>% 
                                                           dplyr::summarise(meanMeanWinTemp = mean(meanDayTemp, na.rm = TRUE), 
                                                                            meanMaxWinTemp = mean(maxDayTemp, na.rm = TRUE),
                                                                            meanMinWinTemp = mean(minDayTemp, na.rm = TRUE),
                                                                            sumWinPrec = sum(sumDayPrec, na.rm = TRUE),
                                                                            sumWinSunDuration = sum(sunDuration, na.rm = TRUE)) %>% 
                                                           dplyr::mutate(Start_DOY = .x,
                                                                         End_DOY = .x + (window_length - 1),
                                                                         windowID = paste(Start_DOY, End_DOY, sep = "_"))
                                                         
                                                       }
                            ) %>%  dplyr::bind_rows()
                          }, .progress = TRUE) %>% 
  dplyr::bind_rows()


di_sub <- di %>% 
  dplyr::arrange(WinterYear) %>% 
  dplyr::mutate(TotalNuts = floor(TotalNuts),
                TreeID = as.factor(TreeID),
                factor_year = as.factor(WinterYear)) %>%
  dplyr::select(TreeID, WinterYear, TotalNuts, factor_year, sun_sumSummer_T1, temp_meanGrow, temp_meanMaxSummer_T1, temp_meanMaxSummer_T2,
                prec_sumGrow, prec_sumSummer_T1, prec_sumSummer_T2)

summer_windows <- all_windows %>% 
  dplyr::filter(Start_DOY > 119)

di_win <- di_sub %>% 
  dplyr::left_join(summer_windows %>%
                     dplyr::mutate(year_T1 = year + 1), 
                   by = c("WinterYear" = "year_T1"), relationship = "many-to-many")

by_window <- di_win %>% 
  dplyr::group_by(windowID) %>% 
  tidyr::nest()

ls_by_window <- by_window %>% 
  dplyr::rowwise() %>% 
  dplyr::pull(data, name = windowID)

ls_by_window_sub <- ls_by_window[1:10]

# capturing outputs
print('Serialization of ls_by_window_sub')
file <- file(paste0('/tmp/ls_by_window_sub_', id, '.json'))
writeLines(toJSON(ls_by_window_sub, auto_unbox=TRUE), file)
close(file)
