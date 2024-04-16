setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--x_output"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--y"), action="store", default=NA, type="integer", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)
x_output = fromJSON(opt$x_output)
y = opt$y






y=seq(21,30,length.out=10)
plot(x_output,y)



