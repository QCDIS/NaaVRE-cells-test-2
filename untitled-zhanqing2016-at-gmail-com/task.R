setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("FME", quietly = TRUE)) {
	install.packages("FME", repos="http://cran.us.r-project.org")
}
library(FME)
if (!requireNamespace("deSolve", quietly = TRUE)) {
	install.packages("deSolve", repos="http://cran.us.r-project.org")
}
library(deSolve)
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
if (!requireNamespace("sf", quietly = TRUE)) {
	install.packages("sf", repos="http://cran.us.r-project.org")
}
library(sf)


option_list = list(

make_option(c("--asp"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--Chlor2021"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--chlorophyll"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--latitude"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--longitude"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--month.abb"), action="store", default=NA, type="integer", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


asp = opt$asp
Chlor2021 = opt$Chlor2021
chlorophyll = opt$chlorophyll
id <- gsub('"', '', opt$id)
latitude = opt$latitude
longitude = opt$longitude
month.abb = opt$month.abb





mf <- par(mfrow=c(3,3), las=1, oma=c(0,0,2,0))

image2D(x=Chlor2021$longitude, 
        y=Chlor2021$latitude, 
        z=Chlor2021$chlorophyll[,,2:10], 
        asp=Chlor2021$asp, 
        log="c", clim=c(0.1, 50),
        clab="Chl, mg/m3", xlab="dgE", ylab="dgN",
        main=month.abb[2:10])
mtext(outer=TRUE, side=3, "Dataset Chlor2021", cex=1.5)



