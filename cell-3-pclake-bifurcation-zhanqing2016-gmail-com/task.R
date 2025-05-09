setwd('/app')
library(optparse)
library(jsonlite)



print('option_list')
option_list = list(

make_option(c("--Bifur_PLoads"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving Bifur_PLoads")
var = opt$Bifur_PLoads
print(var)
var_len = length(var)
print(paste("Variable Bifur_PLoads has length", var_len))

print("------------------------Running var_serialization for Bifur_PLoads-----------------------")
print(opt$Bifur_PLoads)
Bifur_PLoads = var_serialization(opt$Bifur_PLoads)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")


            
bifur_output = list()
for (n in 1:length(Bifur_PLoads)){
 PLoad = Bifur_PLoads[[n]]
    


dir_SCHIL =	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PCShell/")	# location of PCShell

dir_DATM = paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/")					# location of DATM implementation (excel)

file_DATM	=	paste0(dest_dir,"/PCModel/Licence_agreement/I_accept/PCModel1350/PCModel/3.00/Models/PCLake/6.13.16/PL613162.xls") # file name of the DATM implementation
work_case   =	"R_base_work_case"                      												# name of work case
modelname 	=	"_org"																					# name of the model (suffix to specific model files)

nCORES	=	4

tGENERATE_INIT	=	FALSE





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

    nSET = 1                             
    new_pars     =	dfPARAMS_INIT[,nSET]
    names(new_pars) <- rownames(dfPARAMS_INIT) 
    
    new_pars["ReadPLoad"] = 1
    new_pars["mPLoad"] = PLoad
    
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
    
    
    dfOUTPUT_FINAL	=	cbind.data.frame(PLoad = PLoad, nParamSet=nSET, nStateSet=nSET, output)
                                       
    output_folder= paste0("/tmp/data/bifurcation_output/Pvalue_",n)
    if (!dir.exists(output_folder)) {
      dir.create(output_folder, recursive = TRUE)
    }
    output_filename = paste0(output_folder,"/PLoad_",PLoad,".csv")                         
	write.csv(x=dfOUTPUT_FINAL, file= output_filename,sep=',',row.names=FALSE, col.names = TRUE, quote = FALSE) 
    dfOUTPUT_FINAL
    bifur_output = append(bifur_output, output_filename)
 }


bifur_output
# capturing outputs
print('Serialization of bifur_output')
file <- file(paste0('/tmp/bifur_output_', id, '.json'))
writeLines(toJSON(bifur_output, auto_unbox=TRUE), file)
close(file)
