setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("dtLife", quietly = TRUE)) {
	install.packages("dtLife", repos="http://cran.us.r-project.org")
}
library(dtLife)
if (!requireNamespace("dtPP", quietly = TRUE)) {
	install.packages("dtPP", repos="http://cran.us.r-project.org")
}
library(dtPP)
if (!requireNamespace("dtWad", quietly = TRUE)) {
	install.packages("dtWad", repos="http://cran.us.r-project.org")
}
library(dtWad)
if (!requireNamespace("ncdf4", quietly = TRUE)) {
	install.packages("ncdf4", repos="http://cran.us.r-project.org")
}
library(ncdf4)
if (!requireNamespace("plot3D", quietly = TRUE)) {
	install.packages("plot3D", repos="http://cran.us.r-project.org")
}
library(plot3D)

secret_copernicus_api = Sys.getenv('secret_copernicus_api')
secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--acolite_processing"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_copernicus_api"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_public_bucket"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_server"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving acolite_processing")
var = opt$acolite_processing
print(var)
var_len = length(var)
print(paste("Variable acolite_processing has length", var_len))

print("------------------------Running var_serialization for acolite_processing-----------------------")
print(opt$acolite_processing)
acolite_processing = var_serialization(opt$acolite_processing)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_copernicus_api")
var = opt$param_copernicus_api
print(var)
var_len = length(var)
print(paste("Variable param_copernicus_api has length", var_len))

param_copernicus_api <- gsub("\"", "", opt$param_copernicus_api)
print("Retrieving param_s3_public_bucket")
var = opt$param_s3_public_bucket
print(var)
var_len = length(var)
print(paste("Variable param_s3_public_bucket has length", var_len))

param_s3_public_bucket <- gsub("\"", "", opt$param_s3_public_bucket)
print("Retrieving param_s3_server")
var = opt$param_s3_server
print(var)
var_len = length(var)
print(paste("Variable param_s3_server has length", var_len))

param_s3_server <- gsub("\"", "", opt$param_s3_server)


print("Running the cell")

acolite_processing


Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_server
    )

download_files_from_minio <- function(bucket, folder, local_path) {
  
  objects <- get_bucket(bucket = bucket, prefix = folder, region="")
  
  for (object in objects) {
    file_name <- basename(object$Key)
    local_file_path <- file.path(local_path, file_name)
    cat("Downloading", object$Key, "to", local_file_path, "\n")
    
    save_object(object = object$Key, bucket = bucket, file = local_file_path, region="")
    
    cat("File", object$Key, "downloaded successfully.\n")
  }
}

bucket_name <- "naa-vre-waddenzee-shared"  # Replace with your bucket name
minio_folder <- "protoDT_WadPP/Input_data/processed_results/"  # Replace with your folder in the bucket
local_folder <- "/tmp/data/processed_results"  # Replace with the local folder path

if (!dir.exists(local_folder)) {
  dir.create(local_folder, recursive = TRUE)
}

download_files_from_minio(bucket = bucket_name, folder = minio_folder, local_path = local_folder)


                 
read_acolite_files <- function(station, ...){
    filepaths <- list.files(local_folder, pattern = station, full.names = TRUE)
    files <- lapply(filepaths, function(x) read.csv(x))
    RWS_RS <- do.call("rbind", files)
    RWS_RS$time = as.POSIXct(RWS_RS$time, format = "%Y-%m-%d %H:%M:%S")
    RWS_RS <- RWS_RS[order(RWS_RS$time), ]
    RWS_RS$station = station
    return(RWS_RS)
}

stations <- c("MARSDND", "DOOVWST", "DANTZGND", "VLIESM")
RWS_RS <- lapply(stations, function(x) read_acolite_files(x))
RWS_RS <- do.call("rbind", RWS_RS)


bucket_name <- "naa-vre-waddenzee-shared"  # Replace with your bucket name
minio_folder <- "protoDT_WadPP/Input_data/in_situ/"  # Replace with your folder in the bucket
local_folder <- "/tmp/data/in_situ"  # Replace with the local folder path

if (!dir.exists(local_folder)) {
  dir.create(local_folder, recursive = TRUE)
}

download_files_from_minio(bucket = bucket_name, folder = minio_folder, local_path = local_folder)
                 
load(paste0(local_folder,'/RWSbiogeo.rda'))
load(paste0(local_folder,'/RWSstations.rda'))
                 
                 
local_folder <- "/tmp/data/output"  # Replace with the local folder path

if (!dir.exists(local_folder)) {
  dir.create(local_folder, recursive = TRUE)
}

file_name = "chl_validation.png"
file_path = paste0(local_folder, "/", file_name, sep="")

                 
png(file_path, width = 680, height = 580, units = "px", res = 100)
op <- par(mfrow = c(2, 2))
Wad_biogeo_RWS <- subset(RWSbiogeo, 
                        subset=datetime >= "2015-04-20" & datetime < "2021-10-31" & station == 'MARSDND')
plot(Wad_biogeo_RWS$datetime, Wad_biogeo_RWS$Chl, type = "o", pch = 19, col = 'black', ylim = c(0, 30),
     xlab = "", ylab = "Chl (ug/l)", main = "MARSDND")
idx <- which(RWS_RS$station == "MARSDND")
points(RWS_RS$time[idx], RWS_RS$chl_re_gons[idx], type = "p", pch = 19, cex = 1.5, col = "red")

Wad_biogeo_RWS <- subset(RWSbiogeo, 
                        subset=datetime >= "2015-04-20" & datetime < "2021-10-31" & station == 'DOOVBWT')
plot(Wad_biogeo_RWS$datetime, Wad_biogeo_RWS$Chl, type = "o", pch = 19, col = 'black',ylim = c(0, 40),
     xlab = "", ylab = "Chl (ug/l)", main = "DOOVWST")
idx <- which(RWS_RS$station == "DOOVWST")
points(RWS_RS$time[idx], RWS_RS$chl_re_gons[idx], type = "p", pch = 19, cex = 1.5, col = "red")

Wad_biogeo_RWS <- subset(RWSbiogeo, 
                        subset=datetime >= "2015-04-20" & datetime < "2021-10-31" & station == 'DANTZGT')
plot(Wad_biogeo_RWS$datetime, Wad_biogeo_RWS$Chl, type = "o", pch = 19, col = 'black',ylim = c(0, 70),
     xlab = "", ylab = "Chl (ug/l)", main = "DANTZGT")
idx <- which(RWS_RS$station == "DANTZGND")
points(RWS_RS$time[idx], RWS_RS$chl_re_gons[idx], type = "p", pch = 19, cex = 1.5, col = "red")

Wad_biogeo_RWS <- subset(RWSbiogeo, 
                        subset=datetime >= "2015-04-20" & datetime < "2021-10-31" & station == 'VLIESM')
plot(Wad_biogeo_RWS$datetime, Wad_biogeo_RWS$Chl, type = "o", pch = 19, col = 'black',ylim = c(0, 50),
     xlab = "", ylab = "Chl (ug/l)", main = "VLIESM")
idx <- which(RWS_RS$station == "VLIESM")
points(RWS_RS$time[idx], RWS_RS$chl_re_gons[idx], type = "p", pch = 19, cex = 1.5, col = "red")
par(op)
dev.off()


miniofile_path = paste0("/protoDT_WadPP/output/",file_name,sep="")
put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=file_path, 
    object= miniofile_path)
                 
dummy_output = "This one serves as a connection node to the next one"
# capturing outputs
print('Serialization of dummy_output')
file <- file(paste0('/tmp/dummy_output_', id, '.json'))
writeLines(toJSON(dummy_output, auto_unbox=TRUE), file)
close(file)
