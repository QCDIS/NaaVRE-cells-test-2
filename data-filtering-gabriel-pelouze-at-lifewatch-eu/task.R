setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("aws.s3", quietly = TRUE)) {
	install.packages("aws.s3", repos="http://cran.us.r-project.org")
}
library(aws.s3)
if (!requireNamespace("dendextend", quietly = TRUE)) {
	install.packages("dendextend", repos="http://cran.us.r-project.org")
}
library(dendextend)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("fields", quietly = TRUE)) {
	install.packages("fields", repos="http://cran.us.r-project.org")
}
library(fields)
if (!requireNamespace("reshape", quietly = TRUE)) {
	install.packages("reshape", repos="http://cran.us.r-project.org")
}
library(reshape)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--output_traitscomp"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_dofiltering"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key_id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_access_key"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)
output_traitscomp <- gsub('"', '', opt$output_traitscomp)

param_dofiltering = opt$param_dofiltering
param_s3_access_key_id = opt$param_s3_access_key_id
param_s3_endpoint = opt$param_s3_endpoint
param_s3_prefix = opt$param_s3_prefix
param_s3_secret_access_key = opt$param_s3_secret_access_key


conf_output = '/tmp/data/'


conf_output = '/tmp/data/'







Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

if(param_dofiltering==1) {
dataset=read.csv(output_traitscomp,stringsAsFactors=FALSE,sep = ";", dec = ".")

conf_cluster_whole = 0
conf_cluster_country = 1
conf_cluster_locality = 1
conf_cluster_year = 1
conf_cluster_month = 1
conf_cluster_day = 1
conf_cluster_parenteventid = 1
conf_cluster_eventid = 1
conf_taxlev = 'scientificname'
conf_totalbiovolume = 1
conf_totalcarboncontent = 0
conf_density = 1
conf_threshold = 0.75


if(!'density'%in%names(dataset)) dataset[,'density']=1
if(!'biovolume'%in%names(dataset)) dataset[,'biovolume']=1
if(!'cellcarboncontent'%in%names(dataset)) dataset[,'cellcarboncontent']=1
if(!'totalbiovolume'%in%names(dataset)) dataset[,'totalbiovolume']=dataset[,'biovolume']*dataset[,'density']
if(!'totalcarboncontent'%in%names(dataset)) dataset[,'totalcarboncontent']=dataset[,'cellcarboncontent']*dataset[,'density']


ID = ''
IDLIST = ''
IDZ = ''
dataset.d = ''
ddd = ''
k = ''
j = ''
matz = ''
matzx = ''
totz = ''
trs = ''
x = ''


cluster = c()
if (conf_cluster_whole==1) cluster="whole"
if (conf_cluster_country==1) cluster=append(cluster,"country")
if (conf_cluster_locality==1) cluster=append(cluster,"locality")
if (conf_cluster_year==1) cluster=append(cluster,"year")
if (conf_cluster_month==1) cluster=append(cluster,"month")
if (conf_cluster_day==1) cluster=append(cluster,"day")
if (conf_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (conf_cluster_eventid==1) cluster=append(cluster,"eventid")

if(conf_cluster_whole==0) {
  if(length(cluster)>1) ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
  if(length(cluster)==1) ID=dataset[,cluster]
} else if(conf_cluster_whole==1) {
  ID=rep('all',dim(dataset)[1]) }

        
    
if (conf_density==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'density'],na.rm=TRUE)
    matz=tapply(ddd[,'density'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  dataset.d = do.call('rbind',IDLIST)
  
} else dataset.d = dataset[FALSE,]

                
if (conf_totalbiovolume==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz=tapply(ddd[,'totalbiovolume'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  dataset.b = do.call('rbind',IDLIST)
  
} else dataset.b = dataset[FALSE,]
                 
                 

if (conf_totalcarboncontent==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz=tapply(ddd[,'totalcarboncontent'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  dataset.c = do.call('rbind',IDLIST)
  
} else dataset.c = dataset[FALSE,]
                 

dtc=rbind(dataset.d,dataset.b,dataset.c)
no_dupl = !duplicated(dtc[,'catalognumber'])
final = dtc[no_dupl,]
                
output_filtering = paste(conf_output, "df_filtering.csv",sep = "")
write.table(final,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
put_object(region="", bucket="naa-vre-user-data", file=output_filtering, object=paste0(param_s3_prefix, "/myfile/df_filtering.csv"))
}
                
if(param_dofiltering==0) {
output_filtering = paste(conf_output, "df_traitscomp.csv",sep = "")
write.table(df.datain,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
}



# capturing outputs
file <- file(paste0('/tmp/output_filtering_', id, '.json'))
writeLines(toJSON(output_filtering, auto_unbox=TRUE), file)
close(file)
