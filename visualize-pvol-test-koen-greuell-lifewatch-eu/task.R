setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("bioRad", quietly = TRUE)) {
	install.packages("bioRad", repos="http://cran.us.r-project.org")
}
library(bioRad)
if (!requireNamespace("tools", quietly = TRUE)) {
	install.packages("tools", repos="http://cran.us.r-project.org")
}
library(tools)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--local_pvol_paths"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_elev"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--param_image_paths"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_param"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving local_pvol_paths")
var = opt$local_pvol_paths
print(var)
var_len = length(var)
print(paste("Variable local_pvol_paths has length", var_len))

print("------------------------Running var_serialization for local_pvol_paths-----------------------")
print(opt$local_pvol_paths)
local_pvol_paths = var_serialization(opt$local_pvol_paths)
print("---------------------------------------------------------------------------------")

print("Retrieving param_elev")
var = opt$param_elev
print(var)
var_len = length(var)
print(paste("Variable param_elev has length", var_len))

param_elev = opt$param_elev
print("Retrieving param_image_paths")
var = opt$param_image_paths
print(var)
var_len = length(var)
print(paste("Variable param_image_paths has length", var_len))

param_image_paths <- gsub("\"", "", opt$param_image_paths)
print("Retrieving param_param")
var = opt$param_param
print(var)
var_len = length(var)
print(paste("Variable param_param has length", var_len))

param_param <- gsub("\"", "", opt$param_param)

conf_local_visualization_output<-"/tmp/data/visualizatons/output"

print("Running the cell")
conf_local_visualization_output<-"/tmp/data/visualizatons/output"


pvol_path = ""
im_fname = ""
filename_noext = ""
filename_noext_parts = ""
filename = ""
local_image_path = ""

print(conf_local_visualization_output)

library('bioRad')
library('tools')
im_fname_from_path <- function(path,elev,param,imtype = 'ppi',im_ext="png"){
  filename <- basename(path)
  filename_noext <- tools::file_path_sans_ext(filename)
  filename_noext_parts <- unlist(strsplit(filename_noext,split="_"))
  im_fname<-paste0(
    c(filename_noext_parts[[1]],imtype,elev,param,filename_noext_parts[[3]],
      paste0(c(filename_noext_parts[[4]],im_ext),collapse=".",sep=""))
    ,collapse="_",sep="")
  return(im_fname)
}
prefix_from_pvol <- function(pvol){
    date_prefix <- strftime(pvol$datetime,format="%Y/%m/%d")
    corad <- pvol$radar
    co <- substring(corad,1,2)
    rad <- substring(corad,3,5)
    corad_prefix <- paste0(c(co,rad),collapse="/")
    corad_prefix <- toupper(corad_prefix)
    prefix <- paste0(c(corad_prefix,date_prefix),collapse="/")
    
}

dir.create(file.path(conf_local_visualization_output), showWarnings = FALSE)
idx=1
ppi_image_paths <- list()
for (pvol_path in local_pvol_paths) {
    my_pvol <- bioRad:::read_pvolfile(pvol_path)
    my_scan <- bioRad:::get_scan(x=my_pvol,
                             elev=param_elevation)
    my_ppi <- bioRad:::project_as_ppi(x=my_scan)
    image_filename <- im_fname_from_path(path=pvol_path,
                                         elev=param_elevation,
                                         param=param_param
                                         )
    local_prefix <- prefix_from_pvol(my_pvol)
    local_image_path <- paste(conf_local_visualization_output,local_prefix,image_filename,collapse="",sep="/")
    png(local_image_path)
    plot(x=my_ppi,
         param=param_param)
    dev.off()
    append(ppi_image_paths,local_image_path)
}
# capturing outputs
print('Serialization of ppi_image_paths')
file <- file(paste0('/tmp/ppi_image_paths_', id, '.json'))
writeLines(toJSON(ppi_image_paths, auto_unbox=TRUE), file)
close(file)
