setwd('/app')

# retrieve input parameters

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


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--output_traitscomp"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)
output_traitscomp <- gsub('"', '', opt$output_traitscomp)



conf_output = '/tmp/data/'


conf_output = '/tmp/data/'






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
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'density'],na.rm=TRUE)
    matz=tapply(ddd[,'density'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall density
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for density
  dataset.d = do.call('rbind',IDLIST)
  
} else dataset.d = dataset[FALSE,]

                
if (conf_totalbiovolume==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz=tapply(ddd[,'totalbiovolume'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total biovolume
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total biovolume
  dataset.b = do.call('rbind',IDLIST)
  
} else dataset.b = dataset[FALSE,]
                 
                 

if (conf_totalcarboncontent==1) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz=tapply(ddd[,'totalcarboncontent'],ddd[,conf_taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total cell carbon content
    k=2
    trs=max(matz)
    while (trs<conf_threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,conf_taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total cell carbon content
  dataset.c = do.call('rbind',IDLIST)
  
} else dataset.c = dataset[FALSE,]
                 

dtc=rbind(dataset.d,dataset.b,dataset.c)
no_dupl = !duplicated(dtc[,'catalognumber'])
final = dtc[no_dupl,]
  

output_filtering = paste(conf_output, "df_filtering.csv",sep = "")
write.table(final,output_filtering,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)



# capturing outputs
file <- file(paste0('/tmp/output_filtering_', id, '.json'))
writeLines(toJSON(output_filtering, auto_unbox=TRUE), file)
close(file)
