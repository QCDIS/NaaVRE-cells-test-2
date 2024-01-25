setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("climwin", quietly = TRUE)) {
	install.packages("climwin", repos="http://cran.us.r-project.org")
}
library(climwin)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("here", quietly = TRUE)) {
	install.packages("here", repos="http://cran.us.r-project.org")
}
library(here)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


option_list = list(

make_option(c("--budburst_climwin_input_file"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--temp_climwin_input_file"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


budburst_climwin_input_file <- gsub('"', '', opt$budburst_climwin_input_file)
id <- gsub('"', '', opt$id)
temp_climwin_input_file <- gsub('"', '', opt$temp_climwin_input_file)







temp <- read.csv(temp_climwin_input_file)

avg_annual_budburst_dates <- read.csv(budburst_climwin_input_file)




temp <- temp %>%
  dplyr::mutate(date = lubridate::as_date(date),
                year = lubridate::year(date),
                month = lubridate::month(date),
                day = lubridate::day(date),
                doy = lubridate::yday(date),
                # Create dummy for filtering window later. Format: 312 = March 12, 401 = April 1
                dummy = month * 100 + day,
                factor_date = as.factor(paste(day, month, year, sep = "/")))

avg_annual_budburst_dates <- avg_annual_budburst_dates %>%
  dplyr::mutate(date_info = paste(year, floor(avg_bud_burst_DOY)),
                date = strptime(date_info, "%Y %j"),
                date = as.factor(format(as.Date(date), "%d/%m/%Y"))) %>%
  # Create numeric dates to be used in the baseline model &
  # and exclude trees without coordinates
  dplyr::mutate(DOY = lubridate::yday(as.Date(avg_bud_burst_date))) |>
  dplyr::filter(!is.na(date), !is.na(locID))







find_climate_window <- function(biological_data = NULL,
                                range,
                                reference_day,
                                window_number = c("first", "second"),
                                first_window = NULL) {

  # Find 'first' or 'second' climate window
  if(window_number == "first") {

    # Return error if biological data is not provided when searching for first window
    if(is.null(biological_data)) {

      stop("If you want to find a first climate window, provide the biological data as `biological_data`.")

    }

    # Define baseline model
    baseline <- lm(DOY ~ year, data = biological_data)

  } else if(window_number == "second") {

    # Return error if first window output is not provided when searching for second window
    if(is.null(first_window)) {

      stop("If you want to find a second climate window, provide the output of the first iteration of `find_climate_window()` as `first_window`.")

    }

    biological_data <- first_window$biological_data

    # The first window is added as an explanatory variable to the baseline model
    baseline_data <- first_window$best_window[[1]]$BestModelData %>%
      dplyr::rename("first_window" = "climate",
                    "DOY" = "yvar")

    # Define baseline model
    baseline <- lm(DOY ~ year + first_window, data = baseline_data)

  }

  # climwin analysis: Find best window
  best_window <- climwin::slidingwin(baseline = baseline,
                                     xvar = list(Temp = temp$temperature),
                                     cdate = temp$factor_date,
                                     bdate = biological_data$date,
                                     type = "absolute",
                                     refday = reference_day,
                                     spatial = list(biological_data$locID, temp$locID),
                                     range = range,
                                     func = "lin",
                                     stat = "mean")

  # Back calculation of the opening and closing day of the calculated window to calender dates

  # Create a reference year for calculation of start and end date
  # Note: can be any year that is not a leap year, as dates should be calculated on the basis of regular years
  reference_year <- dplyr::if_else(condition = lubridate::leap_year(max(temp$year)),
                                   true = max(temp$year) - 1,
                                   false = max(temp$year))

  # Calculate calender date when window opens
  start_date <- lubridate::make_date(year = reference_year,
                                     month = reference_day[2],
                                     day = reference_day[1]) - best_window$combos[1,]$WindowOpen

  # Calculate calender date when window closes
  end_date <- lubridate::make_date(year = reference_year,
                                   month = reference_day[2],
                                   day = reference_day[1]) - best_window$combos[1,]$WindowClose

  return(tibble::lst(best_window, biological_data, baseline, range, reference_day, start_date, end_date))

}


first_window_Qrobur <- find_climate_window(biological_data = avg_annual_budburst_dates %>%
                                             dplyr::filter(stringr::str_detect(scientificName, "Quercus robur")) ,
                                           window_number = "first",
                                           reference_day = c(31, 5),
                                           range = c(181, 0))

firstWindow_file <- here::here("tmp", "data", "climwin_outputs_Qrobur.rda")
save(first_window_Qrobur, file = firstWindow_file)



# capturing outputs
file <- file(paste0('/tmp/firstWindow_file_', id, '.json'))
writeLines(toJSON(firstWindow_file, auto_unbox=TRUE), file)
close(file)
