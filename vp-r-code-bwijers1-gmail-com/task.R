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
make_option(c("--local_vp_paths"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving local_vp_paths")
var = opt$local_vp_paths
print(var)
var_len = length(var)
print(paste("Variable local_vp_paths has length", var_len))

print("------------------------Running var_serialization for local_vp_paths-----------------------")
print(opt$local_vp_paths)
local_vp_paths = var_serialization(opt$local_vp_paths)
print("---------------------------------------------------------------------------------")


conf_local_visualization_output="/tmp/data/visualizatons/output"

print("Running the cell")
conf_local_visualization_output="/tmp/data/visualizatons/output"

library('bioRad')

print(conf_local_visualization_output)

im_fname_from_vpts <- function(regvpts){
  date_range = regvpts$daterange
  radar = regvpts$radar
  imtype = "regvpts"
  dr1 <- as.character(date_range[[1]])
  dr2 <- as.character(date_range[[2]])
  dr2 <- strsplit(dr2,split=" ")
  dr2 <- paste0(dr2[[1]],collapse="T")
  dr_str <- paste0(c(dr1,dr2),collapse="_")
  fname_noext <- paste0(c(radar,imtype,dr_str),collapse="_")
  im_fname <- paste0(fname_noext,".png")
  return (im_fname)
}
prefix_from_vpts <- function(vpts){
    date_prefix <- strftime(vpts$datetime[[1]],format="%Y/%m") 
    corad <- vpts$radar
    co <- substring(corad,1,2)
    rad <- substring(corad,3,5)
    corad_prefix <- paste0(c(co,rad),collapse="/")
    corad_prefix <- toupper(corad_prefix)
    prefix <- paste0(c(corad_prefix,date_prefix),collapse="/")
    return (prefix)
}

    
print(local_vp_paths)
vpts <- bioRad:::read_vpfiles(local_vp_paths)
reg_vpts <- bioRad:::regularize_vpts(vpts)
image_filename = im_fname_from_vpts(reg_vpts)
local_prefix <- prefix_from_vpts(vpts)
local_image_path <- paste(conf_local_visualization_output,local_prefix,image_filename,collapse="",sep="/")
print(local_image_path)
local_vpts_paths <- list(local_image_path)
# capturing outputs
print('Serialization of local_vpts_paths')
file <- file(paste0('/tmp/local_vpts_paths_', id, '.json'))
writeLines(toJSON(local_vpts_paths, auto_unbox=TRUE), file)
close(file)
