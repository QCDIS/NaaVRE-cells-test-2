setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


print('option_list')
option_list = list(

make_option(c("--event_file"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--extendedmeasurementorfact_file"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--occurrence_file"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving event_file")
var = opt$event_file
print(var)
var_len = length(var)
print(paste("Variable event_file has length", var_len))

event_file <- gsub("\"", "", opt$event_file)
print("Retrieving extendedmeasurementorfact_file")
var = opt$extendedmeasurementorfact_file
print(var)
var_len = length(var)
print(paste("Variable extendedmeasurementorfact_file has length", var_len))

extendedmeasurementorfact_file <- gsub("\"", "", opt$extendedmeasurementorfact_file)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving occurrence_file")
var = opt$occurrence_file
print(var)
var_len = length(var)
print(paste("Variable occurrence_file has length", var_len))

occurrence_file <- gsub("\"", "", opt$occurrence_file)


print("Running the cell")



event <- read.csv(event_file)
occ <- read.csv(occurrence_file)
mof <- read.csv(extendedmeasurementorfact_file)

d_bb <- dplyr::left_join(event, mof, by = "eventID")

d_bb <-
  occ %>%
  dplyr::select("eventID", "organismID", "scientificName") %>%
  dplyr::right_join(d_bb, by = "eventID", relationship = "many-to-many")



crit_measType <- "bud burst stage (PO:0025532) of the tree crown"

crit_measValue <- 1



d_bb_crown <-
  d_bb %>%
  dplyr::filter(measurementType == crit_measType) %>%
  dplyr::mutate(DOY = lubridate::yday(eventDate))

min_bb <- d_bb_crown %>%
  dplyr::filter(measurementValue >= crit_measValue) %>%
  dplyr::summarise(min_DOY_above_criterion = min(DOY),
                   min_value = measurementValue[DOY == min_DOY_above_criterion],
                   .by = c("year", "organismID"))

d_bb_crown2 <- dplyr::left_join(d_bb_crown,
                                min_bb,
                                by = c("year", "organismID"))

max_bb <- d_bb_crown2 %>%
  dplyr::filter(measurementValue < crit_measValue & DOY < min_DOY_above_criterion,
                .by = c("year", "organismID")) %>%
  dplyr::summarise(max_DOY_below_criterion = max(DOY),
                   max_value = measurementValue[DOY == max_DOY_below_criterion],
                   .by = c("year", "organismID"))

min_max_bb <- dplyr::left_join(min_bb,
                               max_bb,
                               by = c("year", "organismID"))


match_criterion <- min_max_bb %>%
  dplyr::filter(min_value == crit_measValue) %>%
  dplyr::mutate(bud_burst_date = min_DOY_above_criterion + lubridate::make_date(year, 1, 1) - 1) %>%
  dplyr::rename("bud_burst_DOY" = "min_DOY_above_criterion")

interpolated <- min_max_bb %>%
  dplyr::filter(min_value != crit_measValue) %>%
  dplyr::mutate(diff_date = min_DOY_above_criterion - max_DOY_below_criterion,
                diff_value = min_value - max_value,
                value_per_day = diff_value / diff_date,
                days_to_reach_criterion = (crit_measValue - max_value) / value_per_day,
                interpolated_DOY = max_DOY_below_criterion + days_to_reach_criterion,
                interpolated_value  = max_value + days_to_reach_criterion * value_per_day) %>%
  dplyr::mutate(bud_burst_date = round(interpolated_DOY) + lubridate::make_date(year, 1, 1) - 1) %>%
  dplyr::rename("bud_burst_DOY" = "interpolated_DOY")

bud_burst_dates <- dplyr::bind_rows(match_criterion %>%
                                      dplyr::select("year", "organismID", "bud_burst_date", "bud_burst_DOY"),
                                    interpolated %>%
                                      dplyr::select("year", "organismID", "bud_burst_date", "bud_burst_DOY")) %>%
  dplyr::left_join(d_bb_crown %>%
                     dplyr::select("year", "organismID", "verbatimLocality", "scientificName") %>%
                     dplyr::distinct(),
                   by = c("year", "organismID")) %>%
  dplyr::arrange(year, organismID)

budburst_file <- "/tmp/data/annual_budburst_per_tree.csv"
write.csv(bud_burst_dates, budburst_file, row.names = FALSE)
# capturing outputs
print('Serialization of budburst_file')
file <- file(paste0('/tmp/budburst_file_', id, '.json'))
writeLines(toJSON(budburst_file, auto_unbox=TRUE), file)
close(file)
