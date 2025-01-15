setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--dest_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving dest_dir")
var = opt$dest_dir
print(var)
var_len = length(var)
print(paste("Variable dest_dir has length", var_len))

dest_dir <- gsub("\"", "", opt$dest_dir)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")


library(jsonlite)
Bifur_PLoads = list(a=0.0001, b= 0.002)
write(toJSON(Bifur_PLoads, simplifyVector= TRUE), "/tmp/data/Bifur_PLoads.json")



dir_SCHIL =	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PCShell/")	# location of PCShell
dir_DATM = paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/")					# location of DATM implementation (excel)

file_DATM	=	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PL613162.xls") # file name of the DATM implementation
work_case   =	"R_base_work_case"                      												# name of work case
modelname 	=	"_org"																					# name of the model (suffix to specific model files)

nCORES	=	4

tGENERATE_INIT	=	FALSE




Bifur_PLoads
# capturing outputs
print('Serialization of Bifur_PLoads')
file <- file(paste0('/tmp/Bifur_PLoads_', id, '.json'))
writeLines(toJSON(Bifur_PLoads, auto_unbox=TRUE), file)
close(file)
