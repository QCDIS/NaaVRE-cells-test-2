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
if (!requireNamespace("geosphere", quietly = TRUE)) {
	install.packages("geosphere", repos="http://cran.us.r-project.org")
}
library(geosphere)
if (!requireNamespace("here", quietly = TRUE)) {
	install.packages("here", repos="http://cran.us.r-project.org")
}
library(here)
if (!requireNamespace("httr", quietly = TRUE)) {
	install.packages("httr", repos="http://cran.us.r-project.org")
}
library(httr)
if (!requireNamespace("jsonlite", quietly = TRUE)) {
	install.packages("jsonlite", repos="http://cran.us.r-project.org")
}
library(jsonlite)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("pacman", quietly = TRUE)) {
	install.packages("pacman", repos="http://cran.us.r-project.org")
}
library(pacman)
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
if (!requireNamespace("taxize", quietly = TRUE)) {
	install.packages("taxize", repos="http://cran.us.r-project.org")
}
library(taxize)
if (!requireNamespace("tibble", quietly = TRUE)) {
	install.packages("tibble", repos="http://cran.us.r-project.org")
}
library(tibble)
if (!requireNamespace("tidyr", quietly = TRUE)) {
	install.packages("tidyr", repos="http://cran.us.r-project.org")
}
library(tidyr)


option_list = list(

make_option(c("--."), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--.x"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--.y"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Area"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--AreaAbr"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--canonicalname"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--data"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--dataset"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--dataset_doi"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--dataset_files"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--dataset_id"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Day"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--decimalLatitude"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--DOY"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Elevation"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--eventDate"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--eventID"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--eventID_L1"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--eventID_L2"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--eventID_L3"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--filename"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--ID"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--key"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Latitude"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--location"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Longitude"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--matchtype"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--measurementType"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--minimumElevationInMeters"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Month"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--n"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--occurrenceID"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--server"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--species"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--status"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--tbl_area"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--tbl_budburst"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--tbl_tree"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--tbl_treeSpecies"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--TreeID"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--TreeSpeciesName"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--verbatimLocality"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--version"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Year"), action="store", default=NA, type="integer", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


. = opt$.
.x = opt$.x
.y = opt$.y
Area = opt$Area
AreaAbr = opt$AreaAbr
canonicalname = opt$canonicalname
data = opt$data
dataset = opt$dataset
dataset_doi = opt$dataset_doi
dataset_files = opt$dataset_files
dataset_id = opt$dataset_id
Day = opt$Day
decimalLatitude = opt$decimalLatitude
DOY = opt$DOY
Elevation = opt$Elevation
eventDate = opt$eventDate
eventID = opt$eventID
eventID_L1 = opt$eventID_L1
eventID_L2 = opt$eventID_L2
eventID_L3 = opt$eventID_L3
filename = opt$filename
ID = opt$ID
id <- gsub('"', '', opt$id)
id <- gsub('"', '', opt$id)
key = opt$key
Latitude = opt$Latitude
location = opt$location
Longitude = opt$Longitude
matchtype = opt$matchtype
measurementType = opt$measurementType
minimumElevationInMeters = opt$minimumElevationInMeters
Month = opt$Month
n = opt$n
occurrenceID = opt$occurrenceID
server = opt$server
species = opt$species
status = opt$status
tbl_area = opt$tbl_area
tbl_budburst = opt$tbl_budburst
tbl_tree = opt$tbl_tree
tbl_treeSpecies = opt$tbl_treeSpecies
TreeID = opt$TreeID
TreeSpeciesName = opt$TreeSpeciesName
verbatimLocality = opt$verbatimLocality
version = opt$version
Year = opt$Year






retrieve_dataverse_data <- function(dataset,
                                    version = ":latest",
                                    server = "demo.dataverse.nl",
                                    key = dataverse_api_key) {

  # Check if dataset is provided in right format (i.e., starting with "doi:")
  if(!stringr::str_starts(string = dataset, pattern = "doi:")) {

    dataset_doi <- paste0("doi:", stringr::str_remove(string = dataset, pattern = "DOI:|https://doi.org/"))

  } else {

    dataset_doi <- dataset

  }

  # Retrieve ID that belongs to the data set of interest
  dataset_id <- httr::GET(url = paste0("https://", server, "/api/",
                                       "datasets/:persistentId?persistentId=", dataset_doi),
                          httr::add_headers("X-Dataverse-key" = key)) |>
    httr::content(as = "text", encoding = "UTF-8") |>
    jsonlite::fromJSON() |>
    purrr::pluck("data") |>
    purrr::pluck("id")

  # Retrieve list of data files that are part of the data set
  dataset_files <- httr::GET(url = paste0("https://", server, "/api/",
                                          "datasets/", dataset_id, "/",
                                          "versions/", version, "/",
                                          "files"),
                             httr::add_headers("X-Dataverse-key" = key)) |>
    httr::content(as = "text", encoding = "UTF-8") |>
    jsonlite::fromJSON() |>
    purrr::pluck("data") |>
    purrr::pluck("dataFile")

  # Retrieve each data file in list using their unique IDs
  data <- purrr::map(.x = dataset_files$id,
                     .f = ~{

                       httr::GET(url = paste0("https://", server, "/api/",
                                              "access/datafile/", .x),
                                 httr::add_headers("X-Dataverse-key" = key)) |>
                         httr::content(encoding = "UTF-8")

                     }) |>
    purrr::set_names(stringr::str_remove_all(string = dataset_files$filename, "\\..*"))

  # If API is unsuccessful, prompt message to check DOI, version and/or server
  if(purrr::is_empty(data)) {

    stop("Dataverse API failed to fulfill the request. Check whether the provided dataset DOI, version, and/or server are correct.")

  } else {

    return(data)

  }

}

dataverse_list <- retrieve_dataverse_data(dataset = "doi:10.80227/test-QMGPSW")

purrr::walk2(.x = names(dataverse_list)[-1],
             .y = dataverse_list[-1],
             .f = ~{

               assign(.x, .y, envir = globalenv())

             })



d_tree <- tbl_tree %>%
  dplyr::left_join(tbl_area %>%
                     dplyr::select("AreaID", "AreaName", "AreaAbr" = "AreaShortName"),
                   by = "AreaID")

d_budburst <- tbl_budburst %>%
  dplyr::left_join(d_tree %>%
                     dplyr::select("Area" = "AreaName", "TreeID", "AreaAbr"),
                   by = "TreeID")

d_budburst <- d_budburst %>%
  dplyr::mutate("Area" = stringr::str_replace(string = Area, pattern = " ", replacement = "_"))

hierarchical_events <-
  d_budburst %>%
  dplyr::select("Year", "Month", "Day", "BudburstID", "Area", "AreaAbr", "TreeID") %>%
  dplyr::mutate(eventDate = lubridate::make_date(year = Year, month = Month, day = Day),
                DOY = lubridate::yday(eventDate),
                eventID_L1 = paste(AreaAbr, Year, sep = ""),
                eventID_L2 = paste(eventID_L1, DOY, sep = "_"),
                eventID_L3 = paste(eventID_L2, TreeID, sep = "_"))


areas_per_year <-
  d_budburst %>%
  dplyr::group_by(Year) %>%
  dplyr::distinct(Area, .keep_all = TRUE) %>%
  dplyr::summarise(location = paste(Area, collapse = ", ")) %>%
  dplyr::ungroup()

d_events_level1 <-
  hierarchical_events %>%
  dplyr::select("eventID_L1", "Year") %>%
  dplyr::distinct(eventID_L1, .keep_all = TRUE) %>%
  dplyr::mutate(eventDate = as.character(Year),
                month = NA,
                day = NA,
                samplingProtocol = NA,
                sampleSizeValue = NA,
                sampleSizeUnit = NA,
                parentEventID = NA,
                decimalLatitude = NA,
                decimalLongitude = NA,
                geodeticDatum = NA,
                minimumElevationInMeters = NA,
                maximumElevationInMeters = NA,
                verbatimLocality = areas_per_year$location[match(.$Year, areas_per_year$Year)]) %>%
  dplyr::rename("eventID" = "eventID_L1",
                "year" = "Year")


areas_per_day <-
  hierarchical_events %>%
  dplyr::group_by(eventDate) %>%
  dplyr::distinct(Area, .keep_all = TRUE) %>%
  dplyr::summarise(location = paste(Area, collapse = ", ")) %>%
  dplyr::ungroup()

d_events_level2 <-
  hierarchical_events %>%
  dplyr::select("eventID_L2", "eventID_L1", "eventDate", "Year", "Month", "Day") %>%
  dplyr::distinct(eventID_L2, .keep_all = TRUE) %>%
  dplyr::mutate(samplingProtocol = NA,
                sampleSizeValue = NA,
                sampleSizeUnit = NA,
                decimalLatitude = NA,
                decimalLongitude = NA,
                geodeticDatum = NA,
                minimumElevationInMeters = NA,
                maximumElevationInMeters = NA,
                verbatimLocality = areas_per_day$location[match(.$eventDate, areas_per_day$eventDate)]) %>%
  dplyr::rename("eventID" = "eventID_L2",
                "parentEventID" = "eventID_L1",
                "year" = "Year",
                "month" = "Month",
                "day" = "Day") %>%
  # Convert dates to characters to avoid merging problems later on
  dplyr::mutate(eventDate = as.character(eventDate))



d_budburst <- d_budburst %>%
  dplyr::left_join(hierarchical_events %>%
                     dplyr::select("eventID" = "eventID_L3", "BudburstID"),
                   by = "BudburstID")

d_events_level3 <-
  hierarchical_events %>%
  dplyr::select("eventID_L3", "eventID_L2", "eventDate", "Year", "Month", "Day", "TreeID") %>%
  dplyr::mutate(samplingProtocol = "https://doi.org/10.1098/rspb.2000.1363",
                sampleSizeValue = 1,
                sampleSizeUnit = "tree",
                decimalLatitude = d_tree$Latitude[match(.$TreeID, d_tree$TreeID)],
                decimalLongitude = d_tree$Longitude[match(.$TreeID, d_tree$TreeID)],
                minimumElevationInMeters = d_tree$Elevation[match(.$TreeID, d_tree$TreeID)],
                maximumElevationInMeters = minimumElevationInMeters,
                verbatimLocality = d_budburst$Area[match(.$eventID_L3, d_budburst$eventID)]) %>%
  dplyr::rename("eventID" = "eventID_L3",
                "parentEventID" = "eventID_L2",
                "year" = "Year",
                "month" = "Month",
                "day" = "Day") %>%
  dplyr::select(!"TreeID")

d_events_level3 <-
  d_events_level3 %>%
  dplyr::mutate(geodeticDatum = dplyr::case_when(!is.na(decimalLatitude) ~ "EPSG:4326",
                                                 TRUE ~ NA_character_),
                eventDate = as.character(eventDate))

event <-
  dplyr::bind_rows(d_events_level1, d_events_level2, d_events_level3) %>%
  dplyr::arrange(eventDate, eventID)

event <-
  event %>%
  dplyr::mutate(language = "en",
                country = "Netherlands",
                countryCode = "NL",
                institutionID = "https://ror.org/01g25jp36",
                institutionCode = "NIOO",
                type = "Event") %>%
  # Reorder event file according to GBIF list
  dplyr::select("eventID", "parentEventID", "samplingProtocol", "sampleSizeValue",
                "sampleSizeUnit", "eventDate", "year", "month", "day", "country",
                "countryCode", "verbatimLocality", "minimumElevationInMeters",
                "maximumElevationInMeters", "decimalLatitude", "decimalLongitude",
                "geodeticDatum", "type", "language", "institutionID", "institutionCode") %>%
  # Rename "Hoge Veluwe" back to original name
  dplyr::mutate(verbatimLocality = stringr::str_replace(string = verbatimLocality, pattern = "_", replacement = " "))

write.csv(event, file = here::here("data", "event.csv"), row.names = FALSE)



tree_species <-
  d_tree %>%
  dplyr::select("TreeID", "TreeSpeciesID") %>%
  #dplyr::select("TreeID", "TreeSpeciesID", "Remarks") %>%
  dplyr::left_join(tbl_treeSpecies, by = "TreeSpeciesID") %>%
  dplyr::right_join(d_budburst, by = "TreeID")



tree_species <-
  tree_species %>%
  dplyr::mutate(species = dplyr::case_when(TreeSpeciesName == "European oak" ~ "Quercus robur",
                                           TreeSpeciesName == "American oak" ~ "Quercus rubra",
                                           TreeSpeciesName == "Larch" ~ "Larix kaempferi",
                                           TreeSpeciesName == "Pine" ~ "Pinus sylvestris",
                                           TreeSpeciesName == "Birch" ~ "Betula pendula",
                                           TRUE ~ "Tracheophyta"))

sciNames <- unique(tree_species$species)

tax <- taxize::get_gbifid_(sci = sciNames) %>%
  dplyr::bind_rows() %>%
  dplyr::filter(status == "ACCEPTED" & matchtype == "EXACT") %>%
  tidyr::separate(canonicalname, c("Genus", "specificEpithet"), remove = FALSE) %>%
  dplyr::select("scientificName" = "scientificname", "canonicalname",
                "kingdom", "phylum", "class", "order", "family", "genus", "specificEpithet")


tree_species_tax <- dplyr::left_join(tree_species,
                                     tax,
                                     by = c("species" = "canonicalname"))



if(d_budburst %>% dplyr::count(eventID) %>% dplyr::filter(n > 1) %>% nrow() > 0) {

  stop(paste("In", d_budburst %>% dplyr::count(eventID) %>% dplyr::filter(n > 1) %>% nrow(),
             "instances of an event, more than one tree was sampled.",
             "This should not be the case for level-3 events."))

}

occID <-
  d_events_level3 %>%
  dplyr::arrange(eventDate) %>%
  dplyr::mutate(occurrenceID = paste(eventID, 1, sep = "_"))

occurrence <-
  tree_species_tax %>%
  dplyr::select("eventID", #"ObserverName",
                "kingdom", "phylum", "class", "order",
                "family", "genus", "specificEpithet", "scientificName", "TreeID") %>%
  dplyr::mutate(individualCount = 1,
                basisOfRecord = "HumanObservation",
                occurrenceStatus = "present",
                occurrenceRemarks = NA,
                recordedBy = NA, ## TODO: Replace when observer names are anonymised
                occurrenceID = occID$occurrenceID[match(.$eventID, occID$eventID)]) %>%
  dplyr::rename(#"recordedBy" = "ObserverName",
                "organismID" = "TreeID") %>%
  dplyr::select("eventID", "occurrenceID", "recordedBy",
                "individualCount", "basisOfRecord", "occurrenceStatus",
                "occurrenceRemarks", "organismID", "scientificName", "kingdom", "phylum", "class", "order",
                "family", "genus", "specificEpithet")

write.csv(occurrence, file = here::here("data", "occurrence.csv"), row.names = FALSE)


measurement_or_fact <-
  tree_species_tax %>%
  tidyr::pivot_longer(col = c("TreeTopScore", "TreeAllScore"),
                      names_to = "measurementType",
                      values_to = "measurementValue")  %>%
  dplyr::select("eventID", "measurementType", "measurementValue")%>%
  dplyr::mutate(measurementUnit = NA,
                measurementMethod = "https://doi.org/10.1098/rspb.2000.1363",
                measurementRemarks = NA)


measurement_or_fact <-
  measurement_or_fact %>%
  dplyr::group_by(eventID) %>%
  dplyr::mutate("ID" = 1:dplyr::n()) %>%
  dplyr::ungroup()

measurement_or_fact <-
  measurement_or_fact %>%
  dplyr::left_join(occurrence %>%
                     dplyr::select("occurrenceID", "eventID"),
                   by = "eventID") %>%
  dplyr::mutate(measurementID = paste(occurrenceID, ID, sep = "_")) %>%
  dplyr::select(!c("ID", "occurrenceID")) %>%
  # Rename measurement types to fit more controlled vocabulary
  dplyr::mutate(measurementType = dplyr::case_when(measurementType == "TreeTopScore" ~ "bud burst stage (PO:0025532) of the tree crown",
                                                   measurementType == "TreeAllScore" ~ "bud burst stage (PO:0025532) of the whole tree")) %>%
  # Reorder columns according to GBIF list
  dplyr::select("measurementID", "eventID", "measurementType", "measurementValue",
                "measurementUnit", "measurementMethod", "measurementRemarks")

write.csv(measurement_or_fact, file = here::here("data", "extendedmeasurementorfact.csv"), row.names = FALSE)



