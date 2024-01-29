setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)


option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--output_traitscomp"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_cluster"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_taxlev"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_threshold"), action="store", default=NA, type="numeric", help="my description"), 
make_option(c("--param_traits"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)
output_traitscomp <- gsub('"', '', opt$output_traitscomp)

param_cluster = opt$param_cluster
param_taxlev = opt$param_taxlev
param_threshold = opt$param_threshold
param_traits = opt$param_traits











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
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'density'],na.rm=TRUE)
    matz=tapply(ddd[,'density'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall density
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for density
  dataset.d = do.call('rbind',IDLIST)
  
} else dataset.d = dataset[FALSE,]

                
if ('totalbiovolume'%in%traits) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalbiovolume'],na.rm=TRUE)
    matz=tapply(ddd[,'totalbiovolume'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total biovolume
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
  }
  
  # filtered dataset for total biovolume
  dataset.b = do.call('rbind',IDLIST)
  
} else dataset.b = dataset[FALSE,]
                 
                 

if ('totalcarboncontent'%in%traits) {
  
  IDZ=unique(ID)  
  IDLIST=list()
  length(IDLIST)=length(IDZ)
  names(IDLIST)=IDZ
  
  # ranked distribution of the taxa
  for(j in 1:length(IDZ)){
    ddd=dataset[ID==IDZ[j],]
    totz=sum(ddd[,'totalcarboncontent'],na.rm=TRUE)
    matz=tapply(ddd[,'totalcarboncontent'],ddd[,taxlev],function(x)sum(x,na.rm=TRUE)/totz)
    matz=sort(matz,decreasing=TRUE) 
    
    # cumulative contribution to the overall total cell carbon content
    k=2
    trs=max(matz)
    while (trs<threshold) {
      matz[k]=matz[k-1]+matz[k]
      trs=matz[k]
      k=k+1 }
    
    matzx=matz[1:k-1]
    
    IDLIST[[j]] = ddd[ddd[,taxlev]%in%names(matzx),]
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
