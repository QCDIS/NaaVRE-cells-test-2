setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("bioRad", quietly = TRUE)) {
	install.packages("bioRad", repos="http://cran.us.r-project.org")
}
library(bioRad)
if (!requireNamespace("ggplot2", quietly = TRUE)) {
	install.packages("ggplot2", repos="http://cran.us.r-project.org")
}
library(ggplot2)
if (!requireNamespace("rosm", quietly = TRUE)) {
	install.packages("rosm", repos="http://cran.us.r-project.org")
}
library(rosm)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_elevation"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--param_param"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--pvol_paths"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_elevation")
var = opt$param_elevation
print(var)
var_len = length(var)
print(paste("Variable param_elevation has length", var_len))

param_elevation = opt$param_elevation
print("Retrieving param_param")
var = opt$param_param
print(var)
var_len = length(var)
print(paste("Variable param_param has length", var_len))

param_param <- gsub("\"", "", opt$param_param)
print("Retrieving pvol_paths")
var = opt$pvol_paths
print(var)
var_len = length(var)
print(paste("Variable pvol_paths has length", var_len))

print("------------------------Running var_serialization for pvol_paths-----------------------")
print(opt$pvol_paths)
pvol_paths = var_serialization(opt$pvol_paths)
print("---------------------------------------------------------------------------------")


conf_local_pvol<-"/home/jovyan/workshop_data/vl-vol2bird/ravl-tutorial/pvol"
conf_local_ppi<-"/home/jovyan/workshop_data/vl-vol2bird/ravl-tutorial/ppi"

print("Running the cell")
conf_local_pvol<-"/home/jovyan/workshop_data/vl-vol2bird/ravl-tutorial/pvol"
conf_local_ppi<-"/home/jovyan/workshop_data/vl-vol2bird/ravl-tutorial/ppi"

library('bioRad')
library("stringr")
library("ggplot2")
title_from_pvol <- function(pvol) {
  date_prefix <- strftime(my_pvol$datetime, format = "%Y/%m/%d T %H:%M UTC", tz = "UTC")
  corad <- pvol$radar
  co <- substring(corad, 1, 2)
  rad <- substring(corad, 3, 5)
  corad_prefix <- paste0(c(co, rad), collapse = "/")
  corad_prefix <- toupper(corad_prefix)
  title_str <- paste0(c(co, rad, date_prefix), collapse = " ")
  title_str <- toupper(title_str)
  return(title_str)
}
basemap <- rosm::osm.types()[1]
ppi_paths <- list()
for (pvol_path in pvol_paths) {
  my_pvol <- read_pvolfile(pvol_path, param = c("DBZH", "VRADH"))
  my_scan <- get_scan(
    x = my_pvol,
    elev = param_elevation,
    all = FALSE
  )
  my_param <- get_param(my_scan, param = param_param)
  ppi <- project_as_ppi(my_param)
  elev <- my_scan$attributes$where$elangle %>% str_replace("\\.", "-")
  imname <- basename(pvol_path) %>%
    str_replace(".h5", ".png") %>%
    str_replace("pvol", paste("ppi", param_param, elev, sep = "_"))
  print(imname)
  impath_dir <- pvol_path %>%
    str_replace(conf_local_pvol, conf_local_ppi) %>%
    str_replace(basename(pvol_path), "")
  impath_dir <- paste(impath_dir, param_param, elev, sep = "/")
  dir.create(file.path(impath_dir), recursive = TRUE, showWarnings = FALSE)
  impath <- paste(impath_dir, imname, sep = "/")
  title_str <- title_from_pvol(my_pvol)  
  subtitle_str <- paste("param:",param_param, "- elevation angle:",param_elevation)
  png(impath, width = 1024, height = 1024, units = "px")
  plt <- map(ppi, map = basemap, alpha = 0.6) +
    ggtitle(title_str, subtitle = subtitle_str) +
    theme(plot.title = element_text(size = 40, face = "bold", hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(plt)
  dev.off()
  ppi_paths <- append(ppi_paths, impath)
}
# capturing outputs
print('Serialization of ppi_paths')
file <- file(paste0('/tmp/ppi_paths_', id, '.json'))
writeLines(toJSON(ppi_paths, auto_unbox=TRUE), file)
close(file)
