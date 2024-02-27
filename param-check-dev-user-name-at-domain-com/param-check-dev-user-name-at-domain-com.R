setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_float"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_int"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_string"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_string_with_comment"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))

id <- gsub('"', '', opt$id)

param_float = opt$param_float
param_int = opt$param_int
param_string = opt$param_string
param_string_with_comment = opt$param_string_with_comment




print(param_string)
print(param_string_with_comment)
print(param_int)
print(param_float)



