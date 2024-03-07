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
if (!requireNamespace("vegan", quietly = TRUE)) {
	install.packages("vegan", repos="http://cran.us.r-project.org")
}
library(vegan)


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
conf_s3_folder = 'vl-phytoplankton'


conf_output = '/tmp/data/'
conf_s3_folder = 'vl-phytoplankton'




library(vegan)

Sys.setenv(
    "AWS_ACCESS_KEY_ID" = param_s3_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = param_s3_secret_access_key,
    "AWS_S3_ENDPOINT" = param_s3_endpoint
    )

dataset=read.csv(output_filtering,stringsAsFactors=FALSE,sep = ";", dec = ".")

conf_cluster_whole = param_cluster_whole_ci
conf_cluster_country = param_cluster_country_ci
conf_cluster_locality = param_cluster_locality_ci
conf_cluster_year = param_cluster_year_ci
conf_cluster_month = param_cluster_month_ci
conf_cluster_day = param_cluster_day_ci
conf_cluster_parenteventid = param_cluster_parenteventid_ci
conf_cluster_eventid = param_cluster_eventid_ci
conf_R = param_R_ci
conf_Shannon_H = param_Shannon_H_ci
conf_Simpson_D = param_Simpson_D_ci
conf_Menhinick_D = param_Menhinick_D_ci
conf_Margalef_D = param_Margalef_D_ci

if(!'density'%in%names(dataset))dataset[,'density']=1
if(!'biovolume'%in%names(dataset))dataset[,'biovolume']=NA
if(!'cellcarboncontent'%in%names(dataset))dataset[,'cellcarboncontent']=NA

ID = ''
info = ''
i = ''
x = ''
ttxx = ''
subt = ''
subtitle = ''
cl.legend = ''
file_graph = ''
final = ''
den_matz = ''
index_fun = ''

index_fun<-list(
  R=function(x)length(x[x>0]),
  Shannon_H=function(x)diversity(x),
  Shannon_H_Eq=function(x)exp(diversity(x)),
  Simpson_D=function(x)diversity(x,index='simpson'),
  Simpson_D_Eq=function(x)1/diversity(x,index='simpson'),
  Menhinick_D=function(x)length(x[x>0])/sqrt(sum(x,na.rm=T)),
  Margalef_D=function(x)(length(x[x>0])-1)/log(sum(x,na.rm=T)),
  Gleason_D=function(x)length(x[x>0])/log(sum(x)),
  McInthosh_M=function(x)(sum(x)+sqrt(sum(x^2)))/(sum(x)+sqrt(sum(x))),
  Hurlbert_PIE=function(x)(length(x[x>0])/(length(x[x>0])-1))*(1-sum((x/sum(x))^2)),
  Pielou_J=function(x)diversity(x[!is.na(x)])/log(specnumber(x[!is.na(x)])),
  Sheldon_J=function(x)exp(diversity(x[!is.na(x)]))/specnumber(x[!is.na(x)]),
  LudwReyn_J=function(x)(exp(diversity(x[!is.na(x)]))-1)/(specnumber(x[!is.na(x)])-1),
  BergerParker_B=function(x)max(x,na.rm=T)/sum(x,na.rm=T),
  McNaughton_Alpha=function(x)(max(x,na.rm=T)+max(x[-which.max(x)],na.rm=T))/sum(x,na.rm=T),
  Hulburt=function(x)((max(x,na.rm=T)+max(x[-which.max(x)],na.rm=T))/sum(x,na.rm=T))*100
)

outputs = c()

cluster= c()
if (conf_cluster_whole==1) cluster="whole"
if (conf_cluster_country==1) cluster=append(cluster,"country")
if (conf_cluster_locality==1) cluster=append(cluster,"locality")
if (conf_cluster_year==1) cluster=append(cluster,"year")
if (conf_cluster_month==1) cluster=append(cluster,"month")
if (conf_cluster_day==1) cluster=append(cluster,"day")
if (conf_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (conf_cluster_eventid==1) cluster=append(cluster,"eventid")

index = c()
if (conf_R==1) index="R"
if (conf_Shannon_H==1) index=append(index,"Shannon_H")
if (conf_Simpson_D==1) index=append(index,"Simpson_D")
if (conf_Menhinick_D==1) index=append(index,"Menhinick_D")
if (conf_Margalef_D==1) index=append(index,"Margalef_D")
    
index_fun2=index_fun[index]

index_list=list()
length(index_list)=length(index_fun2)
names(index_list)=names(index_fun2)

if(length(cluster)>1) {
  ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
  info=as.matrix(unique(dataset[,cluster]))
  rownames(info)=apply(info,1,function(x)paste(x,collapse='.'))
  subt = paste('cluster: ',paste(cluster,collapse = ', '))  
  subtitle = paste(strwrap(subt,width=50),collapse="\n")
} else if(length(cluster)==1 && conf_cluster_whole==0) {
  ID=dataset[,cluster]
  info=as.matrix(unique(dataset[,cluster]))
  rownames(info)=info[,1]
  colnames(info)=cluster
  subt <- paste('cluster: ',cluster)  
  subtitle <- paste(strwrap(subt,width=50),collapse="\n")
} else if(conf_cluster_whole==1) {
  ID<-rep('all',dim(dataset)[1]) }

if (length(unique(ID))>1) {
  file_graph=paste(conf_output,'Index_Output.pdf',sep='')
  outputs=append(outputs,file_graph)
  pdf(file_graph)    
}
    
for(i in 1:length(index_fun2)){
  funz=index_fun2[[i]]
  den_matz=tapply(dataset[,'density'],list(ID,dataset[,'scientificname']),function(x)sum(x,na.rm=TRUE))
  den_matz[is.na(den_matz)]=0
  index_list[[i]]=apply(den_matz,1,function(x)funz(x))
  
  if(length(index_list[[i]][!is.na(index_list[[i]])])>1){
    par(las=2,mar = c(5.2,4.6,3.5,1.8))
    ttxx=index_list[[i]][!is.na(index_list[[i]])]
    ttxx=ttxx[ttxx!=Inf]
    if (max(nchar(ID))<10) {
    barplot(ttxx,main=names(index_list)[i],ylab='value',ylim=range(pretty(c(0,ttxx))))
    } else {
      barplot(ttxx,main=names(index_list)[i],ylab='value',ylim=range(pretty(c(0,ttxx))),
              names.arg=paste("Cluster",1:length(names(index_list[[i]]))))
    }
    mtext(line = -0.7,subtitle,las=1)
  }
}
                        
ind<-do.call('cbind',index_list)
if (conf_cluster_whole==1) {final=ind
} else {
  if (length(unique(ID))>1) final=cbind(info[rownames(ind),],round(ind,3))
  if (length(unique(ID))==1) final=cbind(info,round(ind,3))
  if(length(cluster)==1) colnames(final)[1]=cluster
}

if (length(unique(ID))>1) dev.off()                       
                        
if (max(nchar(ID))>10) {
  cl.legend=final[,cluster]
  rownames(cl.legend)=paste("Cluster",1:length(names(index_list[[i]])))
  output_Index = paste(conf_output, "Index_Cluster_Legend.csv",sep = "")
  write.table(cl.legend,output_Index,row.names=TRUE,sep = ";",dec = ".",quote=FALSE,col.names=NA)
}                        

output_Index = paste(conf_output, "Index_Output.csv",sep = "")
write.table(final, output_Index,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)

Index_Output=paste(conf_output,'Index_Output.pdf',sep='')
Index_Cluster_Legend= paste(conf_output, "Index_Cluster_Legend.csv", sep='')
                        
put_object(region="", bucket="naa-vre-user-data", file=output_Index, object=paste(param_s3_prefix,conf_s3_folder, "Index_Output.csv", sep='/'))
put_object(region="", bucket="naa-vre-user-data", file=Index_Output, object=paste(param_s3_prefix, conf_s3_folder,"Index_Output.pdf", sep='/'))
put_object(region="", bucket="naa-vre-user-data", file=Index_Cluster_Legend, object=paste(param_s3_prefix, conf_s3_folder,"Index_Cluster_Legend.csv", sep='/'))



# capturing outputs
file <- file(paste0('/tmp/output_Index_', id, '.json'))
writeLines(toJSON(output_Index, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/Index_Output_', id, '.json'))
writeLines(toJSON(Index_Output, auto_unbox=TRUE), file)
close(file)
file <- file(paste0('/tmp/Index_Cluster_Legend_', id, '.json'))
writeLines(toJSON(Index_Cluster_Legend, auto_unbox=TRUE), file)
close(file)
