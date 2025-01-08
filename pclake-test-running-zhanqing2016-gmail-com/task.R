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


dir_SCHIL           =	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PCShell/")	# location of PCShell

dir_DATM			=	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/")					# location of DATM implementation (excel)

file_DATM			=	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PL613162.xls")																			# file name of the DATM implementation
work_case           =	"R_base_work_case"                      												# name of work case
modelname 			=	"_org"																					# name of the model (suffix to specific model files)

nCORES	=	4

tGENERATE_INIT	=	FALSE

source(paste(dir_SCHIL,"scripts/R_system/functions.r",sep=""))  					 # Define functions
cpp_files <- list.files(file.path(dir_DATM,paste("Frameworks/Osiris/3.01/PCLake/",sep="")), full.names = TRUE)[
					which((lapply(strsplit(x=list.files(file.path(dir_DATM,paste("Frameworks/Osiris/3.01/PCLake/",sep="")), full.names = TRUE), split="[/]"), 
							function(x) which(x %in% c("pl61316ra.cpp","pl61316rc.cpp","pl61316rd.cpp","pl61316ri.cpp","pl61316rp.cpp","pl61316rs.cpp",
														"pl61316sa.cpp","pl61316sc.cpp","pl61316sd.cpp","pl61316si.cpp","pl61316sp.cpp","pl61316ss.cpp")))>0)==TRUE)]		
file.copy(cpp_files, file.path(dir_SCHIL, work_case,"source_cpp"),overwrite=T)

source(paste(dir_SCHIL,"scripts/R_system/201703_initialisationDATM.r",sep=""))    	 # Initialisation (read user defined input + convert cpp files of model + compile model)

            

                      



WriteLogFile(LogFile,ln="- initialize model")
dfSTATES_INIT_T0	= 	as.data.frame(dfSTATES[,which(colnames(dfSTATES) %in% c('iReportState','sInitialStateName'))])
dfSTATES_INIT		=	as.data.frame(dfSTATES[,-which(colnames(dfSTATES) %in% c('iReportState','sInitialStateName'))])
for (nSET in 1:ncol(dfSTATES_INIT)){
	
	vSTATES_LIST		=	dfSTATES_INIT[,nSET]
	names(vSTATES_LIST)	=	dfSTATES$sInitialStateName
	InitializeModel(n_states, vSTATES_LIST)
	dfSTATES_INIT_T0=cbind.data.frame(dfSTATES_INIT_T0,states)
}
colnames(dfSTATES_INIT_T0)=colnames(dfSTATES)

dfPARAMS_INIT	=	as.data.frame(dfPARAMS[,-which(colnames(dfPARAMS) %in% c('iReport','sMinValue','sMaxValue')),drop=F])


for (nSET in 1:ncol(dfPARAMS_INIT)) {      # loop over sets
	
	new_pars     =	dfPARAMS_INIT[,nSET]
	names(new_pars) <- rownames(dfPARAMS_INIT) 
	
	new_states	=	dfSTATES_INIT_T0[,nSET+2]
	names(new_states) <- rownames(dfSTATES_INIT_T0) 
	
   
    int        <- "vode"
    error      <- class(tryCatch(output <- as.data.frame(RunModel(new_states,times,new_pars,forcings,aux_number,aux_names,"vode",state_names,internal_time_step)),error = function(e) e))[1] == "simpleError"
    output	   <- as.data.frame(subset(output, , subset=(time %in% c((fREP_START_YEAR*365):max(times)))))
    if(any(is.na(output)) | error) {  # run the model again when integrator "vode" returns negative or NA outputs, rerun with integrator "daspk"
      int        <- "daspk"
      error      <- class(tryCatch(output <- as.data.frame(RunModel(new_states,times,new_pars,forcings,aux_number,aux_names,"daspk",state_names,internal_time_step)),error = function(e) e))[1] == "simpleError"
      output	   <- as.data.frame(subset(output, subset=(time %in% c((fREP_START_YEAR*365):max(times)))))
      if(any(is.na(output)) | error) { # run the model again when integrator "daspk" returns negative or NA outputs, rerun with integrator "euler"
        int        <- "euler"
        error      <- class(tryCatch(output <- as.data.frame(RunModel(new_states,times,new_pars,forcings,aux_number,aux_names,"euler",state_names,0.003)),error = function(e) e))[1] == "simpleError"
        output	   <- as.data.frame(subset(output, subset=(time %in% c((fREP_START_YEAR*365):max(times)))))
        if(any(is.na(output)) | error) { # run the model again when integrator "euler" returns negative or NA outputs, rerun with integrator "euler" with timesept 0.002
		  error      <- class(tryCatch(output <- as.data.frame(RunModel(new_states,times,new_pars,forcings,aux_number,aux_names,"euler",state_names,0.002)),error = function(e) e))[1] == "simpleError"
          output	   <- as.data.frame(subset(output, subset=(time %in% c((fREP_START_YEAR*365):max(times)))))
        }
      }
    }
	
	
	
	if(colnames(dfPARAMS_INIT)[nSET]=="sDefault0"){
		dfOUTPUT_FINAL	=	cbind.data.frame(nParamSet=nSET, nStateSet=nSET, output)
					
	}else{
		dfOUTPUT_FINAL	=	rbind.data.frame(dfOUTPUT_FINAL, cbind.data.frame(nParamSet=nSET, nStateSet=nSET, output))
	}
	WriteLogFile(LogFile,ln=paste("Initials recorded for Set_",nSET-1,sep=""))
}

write.table(x=dfOUTPUT_FINAL, file=paste(dir_SCEN,"results/","singlerun_",work_case,".csv",sep=""),sep=',',row.names=FALSE, col.names = TRUE, quote = FALSE) 	
	
WriteLogFile(LogFile,ln=paste("end of PCShell at: ",Sys.time(),sep=""))

result_filename <- paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PCShell/R_base_work_case/results/singlerun_R_base_work_case.csv")
results_test_run <- read.csv(result_filename)
                                       
print(result_filename)
# capturing outputs
print('Serialization of result_filename')
file <- file(paste0('/tmp/result_filename_', id, '.json'))
writeLines(toJSON(result_filename, auto_unbox=TRUE), file)
close(file)
