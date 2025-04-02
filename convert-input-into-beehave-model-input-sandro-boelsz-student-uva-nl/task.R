setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("Rcpp", quietly = TRUE)) {
	install.packages("Rcpp", repos="http://cran.us.r-project.org")
}
library(Rcpp)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("raster", quietly = TRUE)) {
	install.packages("raster", repos="http://cran.us.r-project.org")
}
library(raster)
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)
if (!requireNamespace("terra", quietly = TRUE)) {
	install.packages("terra", repos="http://cran.us.r-project.org")
}
library(terra)

secret_s3_access_id = Sys.getenv('secret_s3_access_id')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--locations_output"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map_aux"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_model"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_output_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_parameters"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_bucket"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_region"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_simulation"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving locations_output")
var = opt$locations_output
print(var)
var_len = length(var)
print(paste("Variable locations_output has length", var_len))

print("------------------------Running var_serialization for locations_output-----------------------")
print(opt$locations_output)
locations_output = var_serialization(opt$locations_output)
print("---------------------------------------------------------------------------------")

print("Retrieving param_buffer")
var = opt$param_buffer
print(var)
var_len = length(var)
print(paste("Variable param_buffer has length", var_len))

param_buffer = opt$param_buffer
print("Retrieving param_input_dir")
var = opt$param_input_dir
print(var)
var_len = length(var)
print(paste("Variable param_input_dir has length", var_len))

param_input_dir <- gsub("\"", "", opt$param_input_dir)
print("Retrieving param_locations")
var = opt$param_locations
print(var)
var_len = length(var)
print(paste("Variable param_locations has length", var_len))

param_locations <- gsub("\"", "", opt$param_locations)
print("Retrieving param_lookup_table")
var = opt$param_lookup_table
print(var)
var_len = length(var)
print(paste("Variable param_lookup_table has length", var_len))

param_lookup_table <- gsub("\"", "", opt$param_lookup_table)
print("Retrieving param_map")
var = opt$param_map
print(var)
var_len = length(var)
print(paste("Variable param_map has length", var_len))

param_map <- gsub("\"", "", opt$param_map)
print("Retrieving param_map_aux")
var = opt$param_map_aux
print(var)
var_len = length(var)
print(paste("Variable param_map_aux has length", var_len))

param_map_aux <- gsub("\"", "", opt$param_map_aux)
print("Retrieving param_model")
var = opt$param_model
print(var)
var_len = length(var)
print(paste("Variable param_model has length", var_len))

param_model <- gsub("\"", "", opt$param_model)
print("Retrieving param_output_dir")
var = opt$param_output_dir
print(var)
var_len = length(var)
print(paste("Variable param_output_dir has length", var_len))

param_output_dir <- gsub("\"", "", opt$param_output_dir)
print("Retrieving param_parameters")
var = opt$param_parameters
print(var)
var_len = length(var)
print(paste("Variable param_parameters has length", var_len))

param_parameters <- gsub("\"", "", opt$param_parameters)
print("Retrieving param_s3_bucket")
var = opt$param_s3_bucket
print(var)
var_len = length(var)
print(paste("Variable param_s3_bucket has length", var_len))

param_s3_bucket <- gsub("\"", "", opt$param_s3_bucket)
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving param_s3_region")
var = opt$param_s3_region
print(var)
var_len = length(var)
print(paste("Variable param_s3_region has length", var_len))

param_s3_region <- gsub("\"", "", opt$param_s3_region)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)
print("Retrieving param_simulation")
var = opt$param_simulation
print(var)
var_len = length(var)
print(paste("Variable param_simulation has length", var_len))

param_simulation <- gsub("\"", "", opt$param_simulation)


print("Running the cell")

library(terra)
library(sf)
library(dplyr)
library(lubridate)

if (!dir.exists(locations_output$location_path)) {
  dir.create(locations_output$location_path)
}

stopifnot(file.exists(locations_output$input_tif_path))
stopifnot(file.exists(paste0(locations_output$input_tif_path, ".aux.xml")))

input_map <-
  rast(locations_output$input_tif_path)

bee_location <- vect(
  data.frame(
    id = locations_output$id,
    lon = locations_output$lon,
    lat = locations_output$lat
  ),
  geom = c("lon", "lat"),
  crs = "EPSG:4326"
) |>
  project(input_map)

lookup_table <- read.csv(locations_output$nectar_pollen_lookup_path)

beehave_input <- function(input_map,
                          bee_location,
                          lookup_table,
                          polygon_size = 200000,
                          buffer_size = 3000,
                          beehave_levels = c(
                            "Maize",
                            "Legumes",
                            "Rapeseed",
                            "Strawberries",
                            "Stone Fruits",
                            "Vines",
                            "Asparagus",
                            "Grassland"
                          )) {
  RefCRS <- crs(input_map, parse = FALSE)

  clip_buffer <- buffer(bee_location, width = buffer_size)

  location_area <- crop(input_map, clip_buffer)

  bee_landscapes <- location_area |>
    cats() |>
    extract_list() |>
    filter(category %in% beehave_levels) |>
    pull(value)

  set.values(location_area, cells(location_area, setdiff(0:24, bee_landscapes)) |> unlist(), NA)

  location_area_poly <- as.polygons(location_area) |>
    disagg()

  values(location_area_poly) <- values(location_area_poly) |>
    mutate(id = 1:n(), .before = category) |>
    mutate(size_sqm = expanse(location_area_poly)) |>
    rename(PatchType = category)

  PolySelection <- subset(
    location_area_poly,
    location_area_poly$size_sqm > polygon_size
  )

  location_area_poly_sub <- subset(
    location_area_poly,
    location_area_poly$size_sqm < polygon_size
  )

  for (i in PolySelection$id) {
    split_polygon <- PolySelection |>
      subset(PolySelection$id == i)

    split_polygon <- SplitPolygonsEqual(split_polygon,
      polygon_size = polygon_size,
      RefCRS = RefCRS
    )

    location_area_poly_sub <- rbind(location_area_poly_sub, split_polygon)
  }

  location_area_poly <- location_area_poly_sub

  coordsPolys <- crds(centroids(location_area_poly))
  coordsBees <- crds(bee_location)

  LocationAttributes <- values(location_area_poly) |>
    mutate(
      id = 1:n() - 1,
      oldPatchID = id, .before = PatchType,
      size_sqm = round(expanse(location_area_poly)),
      distance_m = round(as.vector(distance(bee_location, location_area_poly))),
      xcor = round(coordsPolys[, 1] - coordsBees[, 1]),
      ycor = round(coordsPolys[, 2] - coordsBees[, 2])
    ) |>
    select(c("id", "oldPatchID", "PatchType", "distance_m", "xcor", "ycor", "size_sqm"))

  values(location_area_poly) <- LocationAttributes

  InputTable <- data.frame(LocationAttributes) |>
    slice(rep(1:n(), each = 365)) |>
    mutate(day = rep(1:365, nrow(LocationAttributes)), .before = id) |>
    left_join(lookup_table[, -c(7:8)], by = "PatchType") |>
    mutate(
      calculatedDetectionProb_per_trip = exp(-0.00073 * distance_m),
      modelledDetectionProb_per_trip = 0, .before = nectarGathering_s
    ) |>
    mutate(
      quantityNectar_l = quantityNectar_l * size_sqm,
      quantityPollen_g = quantityPollen_g * size_sqm,
      distance_m = ifelse(distance_m == 0, 0.1, distance_m)
    )

  for (i in 1:nrow(lookup_table)) {
    flowerStart <- lookup_table$flowerStart[i]
    flowerEnd <- lookup_table$flowerEnd[i]
    Patch <- lookup_table$PatchType[i]

    InputTable[which(InputTable$PatchType == Patch), ] <-
      InputTable[which(InputTable$PatchType == Patch), ] |>
      mutate(
        quantityNectar_l = ifelse(day >= flowerStart & day <= flowerEnd,
          quantityNectar_l, 0
        ),
        quantityPollen_g = ifelse(day >= flowerStart & day <= flowerEnd,
          quantityPollen_g, 0
        )
      )
  }
  
  return(list(InputTable, location_area_poly))
}

modify_input_file <- function(input, lookup_table) {
  if (is.list(input)) {
    input <- as.data.frame(input)
  }
  
  temp_start <- lookup_table[which(lookup_table$PatchType == "GrasslandSeason"), 7]
  temp_end <- lookup_table[which(lookup_table$PatchType == "GrasslandSeason"), 8]
  
  if (length(temp_start) == 0 | length(temp_end) == 0) {
    return(input)
  }
  
  temp_old_pollen <- lookup_table[which(lookup_table$PatchType == "Grassland"), 2]
  temp_season_pollen <- lookup_table[which(lookup_table$PatchType == "GrasslandSeason"), 2]

  index <- which(input$PatchType == "Grassland" & input$day > temp_start & input$day < temp_end)

  if (length(index) > 0) {
    input[index, ]$quantityPollen_g <- input[index, ]$quantityPollen_g/temp_old_pollen * temp_season_pollen
    temp_old_nectar <- lookup_table[which(lookup_table$PatchType == "Grassland"), 4]
    temp_season_nectar <- lookup_table[which(lookup_table$PatchType == "GrasslandSeason"), 4]
    input[index, ]$quantityNectar_l <- input[index, ]$quantityNectar_l/temp_old_nectar * temp_season_nectar
  }
  
  return(input)
}

input_patches <-
  beehave_input(input_map = input_map,
               bee_location = bee_location,
               lookup_table = lookup_table,
               polygon_size = 200000,
               buffer_size = locations_output$buffer_size)[[1]]

input_patches_modified <- modify_input_file(input_patches, lookup_table)

write.table(
  input_patches_modified,
  paste0(locations_output$location_path, "/input.txt"),
  sep = " ",
  row.names = FALSE
)


input_file_path <- paste0(locations_output$location_path, "/input.txt")
print(input_data <- read.table(input_file_path, header = TRUE, sep = " "))
