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
if (!requireNamespace("fields", quietly = TRUE)) {
	install.packages("fields", repos="http://cran.us.r-project.org")
}
library(fields)
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




install.packages("vegan",repos = "http://cran.us.r-project.org")
library(vegan)

install.packages("fields",repos = "http://cran.us.r-project.org")
library(fields)

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

dataset=read.csv(output_filtering,stringsAsFactors=FALSE,sep = ";", dec = ".")


conf_cluster_whole = 0
conf_cluster_country = 1
conf_cluster_locality = 1
conf_cluster_year = 1
conf_cluster_month = 1
conf_cluster_day = 1
conf_cluster_parenteventid = 1
conf_cluster_eventid = 1

conf_taxlev = 'scientificname'

conf_matrix = 'density'
conf_analysis = 'distance'
conf_cex = 1
conf_display = 'site'
conf_type = 'p'
conf_method = 'bray'

if(!'density'%in%names(dataset))dataset[,'density']=1
if(!'biovolume'%in%names(dataset))dataset[,'biovolume']=NA
if(!'cellcarboncontent'%in%names(dataset))dataset[,'cellcarboncontent']=NA
if(!'totalbiovolume'%in%names(dataset))dataset[,'totalbiovolume']=dataset[,'biovolume']*dataset[,'density']
if(!'totalcarboncontent'%in%names(dataset))dataset[,'totalcarboncontent']=dataset[,'cellcarboncontent']*dataset[,'density']

ID = ''
x = ''
mm = ''

cluster = c()
if (conf_cluster_whole==1) cluster="whole"
if (conf_cluster_country==1) cluster=append(cluster,"country")
if (conf_cluster_locality==1) cluster=append(cluster,"locality")
if (conf_cluster_year==1) cluster=append(cluster,"year")
if (conf_cluster_month==1) cluster=append(cluster,"month")
if (conf_cluster_day==1) cluster=append(cluster,"day")
if (conf_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (conf_cluster_eventid==1) cluster=append(cluster,"eventid")

if(length(cluster)>1)
  ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
if(length(cluster)==1 && conf_cluster_whole==0) 
  ID=dataset[,cluster]
if(conf_cluster_whole==1)
  ID=rep('all',dim(dataset)[1])  

matz=tapply(dataset[,conf_matrix],list(ID,dataset[,conf_taxlev]),function(x)sum(x,na.rm=TRUE))
matz[is.na(matz)]=0
  
output_matrix = paste(conf_output, "Matrix_Output.csv",sep = "")
write.table(matz, output_matrix,row.names=TRUE,sep = ";",dec = ".",quote=FALSE, col.names=NA)
            
dataset=matz  

file_graph=paste(conf_output,'CommunityAnalysis.pdf',sep='')
outputs=append(outputs,file_graph)
pdf(file_graph)
            
if(conf_analysis=='rarefaction') {
  rarecurve(round(dataset),step=1000,cex=conf_cex,col=4)
  #rarecurve(round(dataset),step=1000,cex=conf_cex,col=4,xlim=c(0,5000))
  dev.off() 
}

if(conf_analysis=='nmds'){
  mm=metaMDS(dataset)
  plot(mm,display=conf_display,cex=conf_cex,type=conf_type)
  dev.off()
}

if(conf_analysis=='cluster'){
  if(conf_display=='site') mm=vegdist(dataset,method=conf_method)
  if(conf_display=='species') mm=vegdist(t(dataset),method=conf_method)
  plot(hclust(mm),cex=conf_cex,xlab='', sub='')
  dev.off()
  # height values of the dendogram nodes
   if(!require('dendextend')) {
    install.packages('dendextend')
    library('dendextend')
  }
  hc=hclust(mm)
  dend= as.dendrogram(hc)
  hb=get_branches_heights(dend,sort=FALSE)
  output_matrix = paste(conf_output, "Matrix_Output_hb.csv",sep = "")
  write.table(hb,output_matrix ,row.names=TRUE,sep = ";",dec = ".",quote=FALSE)
}

if(conf_analysis=='betadiversity'){
  mm=betadiver(dataset)
  plot(mm,cex=conf_cex)
  dev.off()
}

if(conf_analysis=='distance'){
  if(conf_display=='site') mm=as.matrix(vegdist(dataset,method=conf_method))
  if(conf_display=='species') mm=as.matrix(vegdist(t(dataset),method=conf_method))
  mm=mm[order(apply(mm,1,function(x)sum(x))),order(apply(mm,1,function(x)sum(x)))]
  par(mar=c(8,8,6,6))
  image.plot(mm,cex=conf_cex,col=rev(heat.colors(10)),xaxt='n',yaxt='n',main=paste(conf_method,'distance'))
  axis(1,at=(1:dim(mm)[1]-1)/(dim(mm)[1]-1),labels=rownames(mm),las=2,cex.axis=0.4)
  axis(2,at=(1:dim(mm)[1]-1)/(dim(mm)[1]-1),labels=rownames(mm),las=2,cex.axis=0.4)
  dev.off()
}
output_matrix_hb= "Matrix_Output_hb.csv"
                                                         
put_object(region="", bucket="naa-vre-user-data", file=output_matrix, object=paste0(param_s3_prefix, "/myfile/Matrix_Output.csv"))
put_object(region="", bucket="naa-vre-user-data", file=file_graph, object=paste0(param_s3_prefix, "/myfile/CommunityAnalysis.pdf"))
put_object(region="", bucket="naa-vre-user-data", file=output_matrix_hb, object=paste0(param_s3_prefix, "/myfile/Matrix_Output_hb.csv"))



# capturing outputs
file <- file(paste0('/tmp/output_matrix_', id, '.json'))
writeLines(toJSON(output_matrix, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/file_graph_', id, '.json'))
writeLines(toJSON(file_graph, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/output_matrix_hb_', id, '.json'))
writeLines(toJSON(output_matrix_hb, auto_unbox=TRUE), file)
close(file)
