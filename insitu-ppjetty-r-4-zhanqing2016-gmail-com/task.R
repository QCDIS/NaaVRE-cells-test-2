setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)

secret_github_auth_token = Sys.getenv('secret_github_auth_token')
secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)


print("Running the cell")

Haha = "Dummy"

devtools::install_github("LTER-LIFE/dtR/dtLife",depend=TRUE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtWad", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)
devtools::install_github("LTER-LIFE/dtR/dtPP", depend=FALSE, force = TRUE, auth_token=secret_github_auth_token)

require(dtLife)
require(dtWad)
require(dtPP)

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = secret_s3_access_key,
    "AWS_SECRET_ACCESS_KEY" = secret_s3_secret_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

save_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file="/tmp/data/Jetty.rda", 
    object= "/in_situ/Jetty.rda")

load("/tmp/data/Jetty.rda")
ChlJetty <- subset(Jetty,
subset = datetime >= as.POSIXct("1999-12-15") &
datetime <= as.POSIXct("2021-01-01"))
ChlJetty <- ChlJetty [, c("datetime", "Temperature", "Chl", "Secchi")]
head(ChlJetty)

save_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file="/tmp/data/Irradiance.rda", 
    object= "/in_situ/Irradiance.rda")

load("/tmp/data/Irradiance.rda")

save_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file="/tmp/data/WHeightJetty.rda", 
    object= "/in_situ/WHeightJetty.rda")

load("/tmp/data/WHeightJetty.rda")

fig_Jetty_tmp_Chl_Irr_WH = "/tmp/data/Jetty_tmp_Chl_Irr_WH.png"

png(fig_Jetty_tmp_Chl_Irr_WH)
par(mfrow=c(2,2))
with(ChlJetty,{
plot(datetime, Chl, type="l")
plot(datetime, Temperature, type="l")
})
plot(Irradiance$datetime, Irradiance$par, type="l")
plot(WHeightJetty$datetime, WHeightJetty$Height, type="l")
dev.off()

put_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_Jetty_tmp_Chl_Irr_WH, 
    object="/in_situ/plots/Jetty_tmp_Chl_Irr_WH.png")

ChlJetty$kz <- 7/ChlJetty$Secchi # in /m
ChlJetty$kz


alpha <- 0.049
eopt <- 4*(150 + 15*ChlJetty$Temperature)
ps <- 13*1.06^(ChlJetty$Temperature-20) # mgC/mgChl/h
PI.par <- data.frame(time = ChlJetty$datetime,
alpha = alpha*ChlJetty$Chl,
eopt = eopt,
ps = ps*ChlJetty$Chl)
head(PI.par)

datasource <- data.frame(
orig = c("NIOZ", "KNMI", "RWS"),
name = c("Jetty", "De Kooij", "OudeSchild"),
x = c(4.789, 4.7811, 4.850192 ),
y = c(53.002, 52.9269, 53.03884))

fig_Jetty_in_situ_station = "/tmp/data/in_situ_station.png"

png(fig_Jetty_in_situ_station)
plotBathymetry(Marsdiep,
pts = datasource[,c("x", "y")], ptlist = list(cex=4, col= "white"), NAcol="grey", type="image",
main = "Position of the data sets surrounding the NIOZ jetty")
text(datasource$x, datasource$y, labels=1:3, cex=0.7)
legend("bottomright", legend = c(1:3, datasource$name, datasource$orig),
ncol=3, cex=0.7)
dev.off()

put_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_Jetty_in_situ_station, 
    object="/in_situ/plots/Jetty_in_situ_station.png")


times <- seq(from = as.POSIXct("2000-01-01"),
to = as.POSIXct("2020-12-31"),
by = 3600)

Pprod_day <- integratedPP(
times = times,
convFac = 1,
Ht.data = WHeightJetty, # water height
PI.par = PI.par, # PI parameters
It.data = Irradiance, # Light
kz = ChlJetty[, c("datetime", "kz")],
avgOver = "day",
avgTime = 1)


fig_Jetty_PPs = "/tmp/data/Jetty_PPs.png"

png(fig_Jetty_PPs)
par(mfrow=c(3,3))
plot(Pprod_day, mass="mgC", length="m", time="h")
dev.off()

put_object(
    region="nl-uvalight", 
    bucket="naa-vre-waddenzee-shared", 
    file=fig_Jetty_PPs, 
    object="/in_situ/plots/Jetty_PPs.png")
# capturing outputs
print('Serialization of Haha')
file <- file(paste0('/tmp/Haha_', id, '.json'))
writeLines(toJSON(Haha, auto_unbox=TRUE), file)
close(file)
