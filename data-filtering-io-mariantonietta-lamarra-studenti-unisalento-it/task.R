setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("RCurl", quietly = TRUE)) {
	install.packages("RCurl", repos="http://cran.us.r-project.org")
}
library(RCurl)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("httr", quietly = TRUE)) {
	install.packages("httr", repos="http://cran.us.r-project.org")
}
library(httr)
if (!requireNamespace("reshape", quietly = TRUE)) {
	install.packages("reshape", repos="http://cran.us.r-project.org")
}
library(reshape)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--output_traitscomp"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_cluster"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_taxlev"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_threshold"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--param_traits"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving output_traitscomp")
var = opt$output_traitscomp
print(var)
var_len = length(var)
print(paste("Variable output_traitscomp has length", var_len))

output_traitscomp <- gsub("\"", "", opt$output_traitscomp)
print("Retrieving param_cluster")
var = opt$param_cluster
print(var)
var_len = length(var)
print(paste("Variable param_cluster has length", var_len))

param_cluster <- gsub("\"", "", opt$param_cluster)
print("Retrieving param_taxlev")
var = opt$param_taxlev
print(var)
var_len = length(var)
print(paste("Variable param_taxlev has length", var_len))

param_taxlev <- gsub("\"", "", opt$param_taxlev)
print("Retrieving param_threshold")
var = opt$param_threshold
print(var)
var_len = length(var)
print(paste("Variable param_threshold has length", var_len))

param_threshold = opt$param_threshold
print("Retrieving param_traits")
var = opt$param_traits
print(var)
var_len = length(var)
print(paste("Variable param_traits has length", var_len))

param_traits <- gsub("\"", "", opt$param_traits)


print("Running the cell")







dataset=read.csv(output_traitscomp,stringsAsFactors=FALSE,sep = ";", dec = ".")



if(!'density'%in%names(dataset)) dataset[,'density']=1
if(!'biovolume'%in%names(dataset)) dataset[,'biovolume']=1
if(!'cellcarboncontent'%in%names(dataset)) dataset[,'cellcarboncontent']=1
if(!'totalbiovolume'%in%names(dataset)) dataset[,'totalbiovolume']=dataset[,'biovolume']*dataset[,'density']
if(!'totalcarboncontent'%in%names(dataset)) dataset[,'totalcarboncontent']=dataset[,'cellcarboncontent']*dataset[,'density']




cluster = as.list(scan(text = param_cluster, what = "", sep = ","))

if(cluster!='WHOLE') {
  if(length(cluster)>1) ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
  if(length(cluster)==1) ID=dataset[,cluster]
} else {
  ID=rep('all',dim(dataset)[1]) }

                                 
traits = as.list(scan(text = param_traits, what = "", sep = ","))      
                                 
taxlev = param_taxlev
                                 
threshold = as.numeric(param_threshold)
    
if ('density'%in%traits) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'density'],na.rm=TRUE)
    matz=tapply(ddd[,'density'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
  }
  
  dataset.d = do.call('rbind',IDLIST)
  
} else dataset.d = dataset[FALSE,]

                
if ('totalbiovolume'%in%traits) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz=tapply(ddd[,'totalbiovolume'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
  }
  
  dataset.b = do.call('rbind',IDLIST)
  
} else dataset.b = dataset[FALSE,]
                 
                 

if ('totalcarboncontent'%in%traits) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz=tapply(ddd[,'totalcarboncontent'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
  }
  
  dataset.c = do.call('rbind',IDLIST)
  
} else dataset.c = dataset[FALSE,]
                 

dtc=rbind(dataset.d,dataset.b,dataset.c)
no_dupl = !duplicated(dtc[,'catalognumber'])
final = dtc[no_dupl,]
  

output_filtering = paste(conf_output, "df_filtering.csv",sep = "")
write.table(final,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
# capturing outputs
print('Serialization of output_filtering')
file <- file(paste0('/tmp/output_filtering_', id, '.json'))
writeLines(toJSON(output_filtering, auto_unbox=TRUE), file)
close(file)
