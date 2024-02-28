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
make_option(c("--output_filtering"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_access_key_id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_secret_access_key"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


id <- gsub('"', '', opt$id)
output_filtering <- gsub('"', '', opt$output_filtering)

param_s3_access_key_id = opt$param_s3_access_key_id
param_s3_endpoint = opt$param_s3_endpoint
param_s3_prefix = opt$param_s3_prefix
param_s3_secret_access_key = opt$param_s3_secret_access_key


conf_output = '/tmp/data/'


conf_output = '/tmp/data/'



install.packages("stringr",repos = "http://cran.us.r-project.org")
library(stringr)

install.packages("dplyr",repos = "http://cran.us.r-project.org")
library(dplyr)

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

save_object(region="", bucket="naa-vre-user-data", file=output_filtering, object=paste0(param_s3_prefix, "/myfile/df_filtering.csv"))
dataset=read.csv(output_filtering,stringsAsFactors=FALSE,sep = ";", dec = ".")


conf_SizeUnit = 'biovolume'
conf_cluster_whole = 0
conf_cluster_country = 1
conf_cluster_locality = 1
conf_cluster_year = 1
conf_cluster_month = 1
conf_cluster_day = 1
conf_cluster_parenteventid = 1
conf_cluster_eventid = 1
conf_base = 2

if(!'biovolume'%in%names(dataset)) dataset[,'biovolume']=NA
if(!'cellcarboncontent'%in%names(dataset)) dataset[,'cellcarboncontent']=NA

ID = ''
ccfun = ''
subt = ''
subtitle = ''
data_rbind = ''
x = ''
xlb = ''
xlabz = ''
mainz = ''
logvar = ''
cclist = ''
i = ''
idz = ''
ttz = ''
m = ''
var = ''
info = ''
final = ''
mu = ''
cctab = ''
file_graph = ''

cluster = c()
if (conf_cluster_whole==1) cluster="whole"
if (conf_cluster_country==1) cluster=append(cluster,"country")
if (conf_cluster_locality==1) cluster=append(cluster,"locality")
if (conf_cluster_year==1) cluster=append(cluster,"year")
if (conf_cluster_month==1) cluster=append(cluster,"month")
if (conf_cluster_day==1) cluster=append(cluster,"day")
if (conf_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (conf_cluster_eventid==1) cluster=append(cluster,"eventid")

if(conf_SizeUnit=='biovolume') {
  var=dataset[,'biovolume'][!is.na(dataset[,'biovolume'])]   # use the biovolume values
  if (conf_base==2 || conf_base==10) {xlabz=bquote(paste('log'[.(conf_base)]*' biovolume (',mu,m^3,')'))   # x label for the graphs
  } else {xlabz=bquote(paste('ln biovolume (',mu,m^3,')'))}
} else if (conf_SizeUnit=='cellcarboncontent'){
  var=dataset[,'cellcarboncontent'][!is.na(dataset[,'cellcarboncontent'])]   # use the carbon content values
  if (conf_base==2 || conf_base==10) {xlabz=bquote(paste('log'[.(conf_base)]*' cell carbon content (pg C)'))         # x label for the graphs
  } else {xlabz='ln cell carbon content (pg C)'}
}

if (conf_cluster_whole==1) {      # if no temporal/spatial selection, no clusterization (the whole dataset is used)
  
  logvar=ceiling(log(var,base=conf_base))    # logarithmic value of biovolume/carbon content
  if (min(logvar,na.rm=T)>0) min_logvar = 1
  else min_logvar = min(logvar,na.rm=T)
  ttz=table(logvar)                   # frequency table
    
 # plot and export the graph as pdf
    #file_graph=paste(conf_output,'SizeClassOutput.pdf',sep='')
  file_graph='SizeClassOutput.pdf'
  pdf(file_graph)
  par(mar=c(5.1,5.1,4.1,2.1))
  barplot(ttz,xlab=xlabz,ylab='N of cells',main="Whole dataset",ylim=range(pretty(c(0, ttz))))
  
  cctab=as.data.frame(ttz)          # data to be exported in .csv (N of cells)
  colnames(cctab)=c('conf_SizeUnit',"N of cells")
  
} else {                        # if temporal/spatial selection -> clusterization
  
  if(length(cluster)>1) {
    ID=apply(dataset[, cluster], 1, function(x)paste(x,collapse = '.'))[!is.na(dataset[,'biovolume'])]
    info=as.matrix(unique(dataset[,cluster]))
    rownames(info)=apply(info,1,function(x)paste(x,collapse = '.'))
  } else if (length(cluster) == 1) {
    ID=dataset[, cluster][!is.na(dataset[,'biovolume'])]
    info=as.matrix(unique(dataset[,cluster]))
    rownames(info)=info[,1]
    colnames(info)=cluster }
  
  
  subt = paste('cluster: ',paste(cluster,collapse = ', '))  
  subtitle = paste(strwrap(subt,width=50),collapse="\n")       # subtitle with the spatial and temporal levels 
  
  # function to plot the size class distribution for each cluster
  ccfun=function(x, mainz, xlb,subtitle) {            
    logvar = ceiling(log(var[x], base = conf_base))
      if (min(logvar,na.rm=T)>0) min_logvar = 1
    else min_logvar = min(logvar,na.rm=T)
    ttz = table(factor(logvar,levels=min(logvar,na.rm=TRUE):max(logvar,na.rm=TRUE)))
    par(mar=c(7,5.1,4.1,2.1))
    barplot(ttz,xlab=xlb,ylab='N of cells',main=paste(strwrap(mainz,width=50),collapse="\n"),ylim=range(pretty(c(0,ttz))))
    mtext(subtitle,side=1,line=5.5,cex=0.9)
    return(ttz)
  }
  
  # export the graphs as pf
  file_graph=paste(conf_output,'SizeClassOutput.pdf',sep='')
  #file_graph= 'SizeClassOutput.pdf'
  pdf(file_graph)
  
  # create a list containing the distribution information
  idz=unique(ID)
  cclist=list()
  length(cclist)=length(idz)
  names(cclist)=idz
  for (i in 1:length(idz))
    cclist[[i]]=ccfun(var[ID == idz[i]], mainz = idz[i],xlb=xlabz,subtitle=subtitle)    # call the function for plotting
                         
  dev.off()
                         
  # merge the information in a data frame to export to csv
  # Whit bind_rows, columns are matched by name, and any missing columns will be filled with NA    
  data_rbind = as.data.frame(bind_rows(cclist))                  
  data_rbind = data_rbind[ ,str_sort(names(data_rbind), numeric = TRUE)]
  # Add columns with the spatial/temporal clusters
  if (length(unique(ID))>1)final=cbind(info[names(cclist),],data_rbind)
  if (length(unique(ID))==1) final=cbind(info,data_rbind)
  if(length(cluster)==1)colnames(final)[1]=cluster
  final[is.na(final)] = 0

}


output_SizeClass = paste(conf_output, "df_sizeclass.csv",sep = "")
write.table(final,output_SizeClass,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
put_object(region="", bucket="naa-vre-user-data", file=output_SizeClass, object=paste0(param_s3_prefix, "/myfile/df_sizeclass.csv"))
put_object(region="", bucket="naa-vre-user-data", file=file_graph, object=paste0(param_s3_prefix, "/myfile/SizeClassOutput.pdf"))



# capturing outputs
file <- file(paste0('/tmp/output_SizeClass_', id, '.json'))
writeLines(toJSON(output_SizeClass, auto_unbox=TRUE), file)
close(file)
