setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("akima", quietly = TRUE)) {
	install.packages("akima", repos="http://cran.us.r-project.org")
}
library(akima)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("ncdf4", quietly = TRUE)) {
	install.packages("ncdf4", repos="http://cran.us.r-project.org")
}
library(ncdf4)

secret_github_auth_token = Sys.getenv('secret_github_auth_token')
secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_s3_server")
var = opt$param_s3_server
print(var)
var_len = length(var)
print(paste("Variable param_s3_server has length", var_len))

param_s3_server <- gsub("\"", "", opt$param_s3_server)


print("Running the cell")

devtools::install_github("LTER-LIFE/dtR/dtLife",depend=TRUE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)

require(dtLife)
require(dtWad)
require(dtPP)


library(dtLife)
library(dtWad); library(dtPP)
library(ncdf4)



Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_server
    )

bucket_name = "naa-vre-waddenzee-shared"  # Replace with your bucket name
file_name = "S2A_MSI_2016_04_11_10_56_07_T31UFV_L2W.nc"
minio_folder = "protoDT_WadPP/Input_data/RS_Download/"  # Replace with your folder in the bucket
miniofile_path = paste0(minio_folder,file_name,sep="")

local_folder = "/tmp/data/Input_data/RS_Download/"  # Replace with the local folder path
local_file_path = paste0(local_folder, file_name)

save_object(object = miniofile_path, bucket = bucket_name, file = local_file_path, region="")

nc = nc_open(local_file_path)
chla = ncvar_get(nc, "chl_re_mishra")

lon = ncvar_get(nc, "lon")
lat = ncvar_get(nc, "lat")
nc_close(nc)


dim(chla); dim(lon); dim(lat)

n <- dim(chla)[1]; m <- dim(chla)[2]
block = 10 # this changes resolution 

chla_block <- lon_block <- lat_block <- matrix(NA, nrow = n %/% block, ncol = m %/% block)

for(i in 1:(n %/% block)){
  for(j in 1:(m %/% block)){
    iblock <- (1:block) + block*(i - 1)
    jblock <- (1:block) + block*(j - 1)
    lon_block[i, j] <- mean(lon[iblock, jblock])
    lat_block[i, j] <- mean(lat[iblock, jblock])
    chla_block[i, j] <- mean(chla[iblock, jblock])
  }
}

dim(chla_block)
plot3D::image2D(x = lon_block, y = lat_block, z = chla_block, log = "z", asp = 3, main = "block-averaged\non 10 cells")

ChlLong <- data.frame(longitude   = as.vector(lon_block), 
                      latitude    = as.vector(lat_block), 
                      chlorophyll = as.vector(chla_block))



ChlLong_naomit <- na.omit(ChlLong)

zz <- mask_xy(ChlLong_naomit, shape = Wad_shape)
zz$chlorophyll[is.na(zz$mask)] <- NA

with(na.omit(zz), points2D(x = longitude, y = latitude, colvar = chlorophyll, log = "c", pch = 18, cex = 2, NAcol ="grey", asp = 1.162))

plot(Wad_shape[1], add = TRUE)

time <- as.POSIXct(c("2021-01-23 09:00:00 CET", "2021-01-24 13:00:00 CET", "2021-01-25 09:00:00 CET"))


st235   <- subset(Wad_weather, 
                  subset = 
                    station == 235                                 &
                    datetime >= as.POSIXct("2020-12-31 23:59:59")  &
                    datetime <= as.POSIXct("2021-04-01 01:00:10")  )
It.data <- st235[, c("datetime", "radiation")]
It.data$PAR <- It.data$radiation * 0.5
It.data$radiation <- NULL

Ht.data  <- Wad_waterheight_HR[ , c("datetime", "DENHDR")]
Ht.data  <- subset(Ht.data, 
                   subset =                                         
                     datetime >= as.POSIXct("2020-12-31 23:59:59")  &
                     datetime <= as.POSIXct("2021-04-01 01:00:10"))

Tt.data  <- Wad_watertemp_HR[ , c("datetime", "DENHDVSGR")]
Tt.data  <- subset(Tt.data, 
                   subset =                                         
                     datetime >= as.POSIXct("2020-12-31 23:59:59")  &
                     datetime <= as.POSIXct("2021-04-01 01:00:10"))

Tmon <- average_timeseries(Tt.data, avgOver="mon", 
                           value = "DENHDVSGR")


zz_naomit <- na.omit(zz)
with(zz_naomit, points2D(x = longitude, y = latitude, colvar = chlorophyll, log = "c", asp = 1))

zz_long <- data.frame(longitude = c(zz_naomit$longitude, zz_naomit$longitude), 
                      latitude = c(zz_naomit$latitude, zz_naomit$latitude), 
                      chlorophyll = c(zz_naomit$chlorophyll, zz_naomit$chlorophyll), 
                      mask = c(zz_naomit$mask, zz_naomit$mask), 
                      nr = rep(c(1, 2), each = length(zz_naomit$longitude)))
zz_long$date <- as.POSIXct("2021-01-23 09:00:00 CET")
zz_long$date[zz_long$nr == 2] <- as.POSIXct("2021-01-25 09:00:00 CET")

xy_stats <- unique(zz_long[, c("longitude", "latitude")])

Chl_stats <- map_xy(input.x = as.vector(Wad_depth$longitude), 
                    input.y = as.vector(Wad_depth$latitude), 
                    input.2D = Wad_depth$depth, 
                    output.xy = xy_stats)

Chl_stats$v[Chl_stats$v < 0] <- NA
Chl_stats <- Chl_stats[!(is.na(Chl_stats$v)), ]

points2D(Chl_stats$longitude, Chl_stats$latitude, colvar = Chl_stats$v)


temp <- as.data.frame(approx(Tt.data, xout=time)) 
PPall <- NULL


system.time(
  for(i in 1:nrow(Chl_stats)){
    Chl_data <- subset(zz_long, subset = longitude == Chl_stats$longitude[i] & latitude == Chl_stats$latitude[i])
    Chl_data <- Chl_data[, c("date", "chlorophyll")]
    Chl <- as.data.frame(approx(Chl_data, xout = time))
    
    ps <- 13*1.06^(temp$y-20)
    alpha <- 0.049  
    
    PI.par <- data.frame(time = time, 
                         alpha = 0.049*Chl$y,
                         eopt = 4*(150 + 15*temp$y), 
                         ps = ps*Chl$y)
    
    
    zmean <- Chl_stats$v[i]
    
    PP <- integratedPP(zmax = zmean, 
                       times = time, 
                       It.data = It.data, 
                       kz = 0.3, 
                       PI.par = PI.par, 
                       Ht.data= Ht.data, 
                       avgOver = "day")
    
    PPall <- cbind(PPall, PP$ts$PP)
  }
  
)

Haha = "sowhat"


dim(PPall)

points2D(Chl_stats$longitude, Chl_stats$latitude, colvar = PPall[1, ], xlab = "longitude", ylab = "latitude", clab = "Integrated PP")






pelagic_pp <- interp(x = Chl_stats$longitude, y = Chl_stats$latitude, z = PPall[1, ], linear = TRUE)

local_folder = "/tmp/data/output/"
file_name = "PP_calculation.png"
file_path = paste0(local_folder, file_name, sep="")

if (!dir.exists(local_folder)) {
  dir.create(local_folder, recursive = TRUE)
}

png(file_path, width = 80, height = 50, units = "cm", res = 100)
with(pelagic_pp, image2D(x = x, y = y, z = z, resfac = 3, asp = 4, 
                  main = "Pelagic Photosynthesis", xlab = "Longitude", 
                  ylab = "Latitude", clab = "mgC/m2/h"))

plot(Wad_shape[1], add = TRUE)

dev.off()

miniofile_path = paste0("/output/",file_name,sep="")
put_object(
    region="", 
    bucket="naa-vre-waddenzee-shared", 
    file=file_path, 
    object= miniofile_path)
                 
Haha = "sowhat"
# capturing outputs
print('Serialization of Haha')
file <- file(paste0('/tmp/Haha_', id, '.json'))
writeLines(toJSON(Haha, auto_unbox=TRUE), file)
close(file)
