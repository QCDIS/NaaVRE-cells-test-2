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


dir_SCHIL =	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PCShell/")	# location of PCShell

dir_DATM = paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/")					# location of DATM implementation (excel)

file_DATM	=	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PL613162.xls") # file name of the DATM implementation
work_case   =	"R_base_work_case"                      												# name of work case
modelname 	=	"_org"																					# name of the model (suffix to specific model files)

nCORES	=	4

tGENERATE_INIT	=	FALSE

source(paste(dir_SCHIL,"scripts/R_system/functions.r",sep=""))  					 # Define functions
cpp_files <- list.files(file.path(dir_DATM,paste("Frameworks/Osiris/3.01/PCLake/",sep="")), full.names = TRUE)[
					which((lapply(strsplit(x=list.files(file.path(dir_DATM,paste("Frameworks/Osiris/3.01/PCLake/",sep="")), full.names = TRUE), split="[/]"), 
							function(x) which(x %in% c("pl61316ra.cpp","pl61316rc.cpp","pl61316rd.cpp","pl61316ri.cpp","pl61316rp.cpp","pl61316rs.cpp",
														"pl61316sa.cpp","pl61316sc.cpp","pl61316sd.cpp","pl61316si.cpp","pl61316sp.cpp","pl61316ss.cpp")))>0)==TRUE)]		
file.copy(cpp_files, file.path(dir_SCHIL, work_case,"source_cpp"),overwrite=T)

source(paste(dir_SCHIL,"scripts/R_system/201703_initialisationDATM.r",sep=""))    	 # Initialisation (read user defined input + convert cpp files of model + compile model)

Bifur_PLoads = list(0.0001,0.002)
