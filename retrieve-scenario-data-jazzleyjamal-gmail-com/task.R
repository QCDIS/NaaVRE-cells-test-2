setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("httr", quietly = TRUE)) {
	install.packages("httr", repos="http://cran.us.r-project.org")
}
library(httr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("readr", quietly = TRUE)) {
	install.packages("readr", repos="http://cran.us.r-project.org")
}
library(readr)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)


print('option_list')
option_list = list(

make_option(c("--filename"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving filename")
var = opt$filename
print(var)
var_len = length(var)
print(paste("Variable filename has length", var_len))

filename = opt$filename
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")

dir.create("/tmp/data")

master_branch <- httr::GET("https://api.github.com/repos/matt-long/bio-pop-ToE/git/trees/master?recursive=1")

file_path <- tibble::tibble(path = purrr::map_chr(httr::content(master_branch)$tree, "path")) %>%
  tidyr::separate_wider_delim(path, delim = '/', names = c('base', 'folder', 'filename'),
                              too_few = "align_end", too_many = "drop") %>%
  dplyr::filter(folder == 'data', stringr::str_detect(filename, '.csv'))

scenario_data_all <- tibble::tibble()

for (i in seq(1, nrow(file_path))){

  path <- paste0('https://raw.githubusercontent.com/matt-long/bio-pop-ToE/master/notebooks/data/', file_path$filename[i])

  df <- readr::read_csv(httr::content(httr::GET(path)))

  file_name <- file_path$filename[i]

  df1 <- df %>%
    dplyr::mutate(scenario_name = stringr::str_extract(file_name, pattern = "1pt5degC(?=\\.)|1pt5degC_OS|2pt0degC|RCP85|RCP45"),
                  member_id = as.character(member_id))

  scenario_data_all <- bind_rows(scenario_data_all, df1)

}

scenario_data_all <- scenario_data_all %>%
  dplyr::filter(time >= as.POSIXct("1985-01-01", tz = "UTC"))

scenario_data_all_file <- "/tmp/data/scenario_temperatures.csv"
write.csv(scenario_data_all, file = scenario_data_all_file, row.names = FALSE)
# capturing outputs
print('Serialization of scenario_data_all_file')
file <- file(paste0('/tmp/scenario_data_all_file_', id, '.json'))
writeLines(toJSON(scenario_data_all_file, auto_unbox=TRUE), file)
close(file)
