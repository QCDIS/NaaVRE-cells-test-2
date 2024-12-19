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
make_option(c("--output_filtering"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_hostname"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_login"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_password"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving output_filtering")
var = opt$output_filtering
print(var)
var_len = length(var)
print(paste("Variable output_filtering has length", var_len))

output_filtering <- gsub("\"", "", opt$output_filtering)
print("Retrieving param_hostname")
var = opt$param_hostname
print(var)
var_len = length(var)
print(paste("Variable param_hostname has length", var_len))

param_hostname <- gsub("\"", "", opt$param_hostname)
print("Retrieving param_login")
var = opt$param_login
print(var)
var_len = length(var)
print(paste("Variable param_login has length", var_len))

param_login <- gsub("\"", "", opt$param_login)
print("Retrieving param_password")
var = opt$param_password
print(var)
var_len = length(var)
print(paste("Variable param_password has length", var_len))

param_password <- gsub("\"", "", opt$param_password)

conf_output = '/tmp/data/'

print("Running the cell")
conf_output = '/tmp/data/'



install.packages("reshape",repos = "http://cran.us.r-project.org")
library("reshape")

install.packages("dplyr",repos = "http://cran.us.r-project.org")
library("dplyr")

install.packages("RCurl",repos = "http://cran.us.r-project.org")
library("RCurl")

install.packages("httr",repos = "http://cran.us.r-project.org")
library("httr")


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

conf_SizeUnit = 'biovolume'


if(!'density'%in%names(dataset))dataset[,'density']=1
if(!'biovolume'%in%names(dataset))dataset[,'biovolume']=NA
if(!'cellcarboncontent'%in%names(dataset))dataset[,'cellcarboncontent']=NA

r.squared = ''
m = ''
density = ''
L = ''
value = ''

outputs = c()


cluster = c()
if (conf_cluster_whole==1) cluster="whole"
if (conf_cluster_country==1) cluster=append(cluster,"country")
if (conf_cluster_locality==1) cluster=append(cluster,"locality")
if (conf_cluster_year==1) cluster=append(cluster,"year")
if (conf_cluster_month==1) cluster=append(cluster,"month")
if (conf_cluster_day==1) cluster=append(cluster,"day")
if (conf_cluster_parenteventid==1) cluster=append(cluster,"parenteventid")
if (conf_cluster_eventid==1) cluster=append(cluster,"eventid")

if (conf_taxlev!='community') {    
  if (length(unique(dataset[,conf_taxlev]))==1) conf_taxlev='community'
}

if(!(conf_taxlev=='community' & conf_cluster_whole==1)) {      # either taxlev or cluster, or both, are selected by the user
  
  if (conf_taxlev!='community' & conf_cluster_whole==0){
    if(length(cluster)>1){
      ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
      info=as.matrix(unique(dataset[,cluster]))
      rownames(info)=apply(info,1,function(x)paste(x,collapse='.'))
    } else if(length(cluster)==1) {
      ID=dataset[,cluster]
      info=as.matrix(unique(dataset[,cluster]))
      rownames(info)=info[,1]
      colnames(info)=cluster }
    den=melt(tapply(dataset[,'density'],list(ID,dataset[,conf_taxlev]),function(x)sum(x,na.rm=TRUE)))  # sum of the densities
    biom=melt(tapply(dataset[,'biovolume'],list(ID,dataset[,conf_taxlev]),function(x)mean(x,na.rm=TRUE)))  # average biovolume
    cc=melt(tapply(dataset[,'cellcarboncontent'],list(ID,dataset[,conf_taxlev]),function(x)mean(x,na.rm=TRUE)))  # average cell carbon content
    mat=cbind(den,biom$value,cc$value)
    if (length(cluster)>1) colnames(mat)=c('cluster',conf_taxlev,'density','biovolume','cellcarboncontent')
    else if (length(cluster)==1) colnames(mat)=c(cluster,conf_taxlev,'density','biovolume','cellcarboncontent')
  } else if (conf_taxlev=='community' & conf_cluster_whole==0) {  
    if(length(cluster)>1){
      ID=apply(dataset[,cluster],1,function(x)paste(x,collapse='.'))
      info=as.matrix(unique(dataset[,cluster]))
      rownames(info)=apply(info,1,function(x)paste(x,collapse='.'))
    } else if(length(cluster)==1) {
      ID=dataset[,cluster]
      info=as.matrix(unique(dataset[,cluster]))
      rownames(info)=info[,1]
      colnames(info)=cluster }
    den=tapply(dataset[,'density'],list(ID),function(x)sum(x,na.rm=TRUE))   # sum of the densities
    biom=tapply(dataset[,'biovolume'],list(ID),function(x)mean(x,na.rm=TRUE))   # average biovolume
    cc=tapply(dataset[,'cellcarboncontent'],list(ID),function(x)mean(x,na.rm=TRUE))   # average cell carbon content
    mat=cbind(den,biom,cc)
    colnames(mat)=c('density','biovolume','cellcarboncontent')
    if (dim(mat)[1]==1) {   # plot with only one point (if the selected cluster has only one value)
      xx=mat[,conf_SizeUnit]
      plot(xx,den,xlab="",ylab="")
      if(conf_SizeUnit=='biovolume') {title(xlab=expression(paste('average biovolume (',mu,m^3,')')),line=2.5)
      } else if(conf_SizeUnit=='cellcarboncontent') title(xlab='average cell carbon content (pg C)',line=2.5)
      title(ylab=expression(paste('density (cell·',L^-1,')')),line=2.5)
      title(paste('cluster',conf_taxlev,sep='*'), line = 2.5)
      subt = paste('cluster: ',paste(cluster,collapse = ', '))  
      subtitle = paste(strwrap(subt,width=50),collapse="\n")
      mtext(line = 0.5, subtitle)
      mat = cbind(rownames(mat), data.frame(mat, row.names=NULL))
      colnames(mat)=c('density','average biovolume','average cell carbon content')
      final=cbind(info,mat)
      write.table(final,paste(conf_output,'sizedensity_DATA.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
      outputs = append(outputs,paste(conf_output,'sizedensity_DATA.csv',sep=''))
    }
  } else if (conf_taxlev!='community' & conf_cluster_whole==1) {     
    den=tapply(dataset[,'density'],list(dataset[,conf_taxlev]),function(x)sum(x,na.rm=TRUE))   # sum of the densities
    biom=tapply(dataset[,'biovolume'],list(dataset[,conf_taxlev]),function(x)mean(x,na.rm=TRUE))   # average biovolume
    cc=tapply(dataset[,'cellcarboncontent'],list(dataset[,conf_taxlev]),function(x)mean(x,na.rm=TRUE))   # average cell carbon content
    mat=cbind(den,biom,cc)
    colnames(mat)=c('density','biovolume','cellcarboncontent')   
  }
  
  if (dim(mat)[1]>1) {
    
    xx=mat[,conf_SizeUnit]
    
    mod=lm(log(density)~log(xx),data=data.frame(mat))
    rr=summary(mod)[[4]]
    rr=cbind(rr,Rsquared=c(NA,summary(mod)$r.squared))
    rownames(rr)=c('Intercept',paste('log average',conf_SizeUnit))
    
    
    
    file_graph=paste(conf_output,'sizedensityOutput.pdf',sep='')
    outputs=append(outputs,file_graph)
    pdf(file_graph)
    
    sq=seq(min(mat[,conf_SizeUnit],na.rm=TRUE),max(mat[,conf_SizeUnit],na.rm=TRUE),length.out=101)
    pr=exp(predict(mod,list(xx=sq),interval='confidence'))
    
    if (conf_cluster_whole==0) {
      subt = paste('cluster: ',paste(cluster,collapse = ', '))  
      subtitle = paste(strwrap(subt,width=50),collapse="\n")
    } else {
      subtitle = "no temporal or spatial cluster"
    }
    par(mar = c(4,4.5,5,1.8))
    plot(density~xx,data=mat,log='xy',xlab="",ylab=expression(paste('density (cell·',L^-1,')')),
         ylim=range(c(mat[,'density'],pr),na.rm=TRUE),xaxt="n",yaxt="n")
    
    at.x = 10^(log10(axTicks(1)))[10^(log10(axTicks(1))) %% 1 == 0]
    lab.x = ifelse(log10(at.x) %% 1 == 0, sapply(log10(at.x),function(i) 
      as.expression(bquote(10^ .(i)))), NA)
    axis(1, at=at.x, labels=lab.x, las=1)
    at.y = 10^(log10(axTicks(2)))[10^(log10(axTicks(2))) %% 1 == 0]
    lab.y = ifelse(log10(at.y) %% 1 == 0, sapply(log10(at.y),function(i) 
      as.expression(bquote(10^ .(i)))), NA)
    axis(2, at=at.y, labels=lab.y, las=1)
    
    if(conf_SizeUnit=='biovolume') {title(xlab=expression(paste('average biovolume (',mu,m^3,')')),line=2.5)
    } else if(conf_SizeUnit=='cellcarboncontent') title(xlab='average cell carbon content (pg C)',line=2.5)
    
    if (conf_cluster_whole==0) title(paste('cluster',conf_taxlev,sep='*'), line = 3)
    if (conf_cluster_whole==1) title(paste('taxonomic level: ',conf_taxlev,sep=''), line = 3)
    mtext(line = 0.5, subtitle)
    
    lines(sq,pr[,1],col=2,lwd=3)
    lines(sq,pr[,2],col=2,lwd=3,lty=2)
    lines(sq,pr[,3],col=2,lwd=3,lty=2)
    
    eq=parse(text=paste(round(exp(coef(mod)[1]),2),'*M^',round(coef(mod)[2],2)))
    r2=parse(text=paste('R^2==',round(summary(mod)$r.squared,2)))
    legend('topright',legend=c(eq,r2),lty=c(1,NA),col=c(2,NA))
    
    
    
    if (conf_taxlev!='community' & conf_cluster_whole==0) {
      colnames(mat)=c('cluster',conf_taxlev,'density','average biovolume','average cell carbon content')
      if (length(cluster)>1) {
        final=cbind(info[mat$cluster,],mat)
        final = subset(final,select = -cluster)}
      if (length(cluster)==1) {
        colnames(mat)[1]=cluster
        final=mat}
      final = final[rowSums(is.na(final)) != 3,]
      final = final %>% mutate_if(function(x)is.numeric(x), function(x)round(x,2))
      write.table(final,paste(conf_output,'sizedensity_DATA.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE)  
      outputs=append(outputs,paste(conf_output,'sizedensity_DATA.csv',sep=''))
    } else if (conf_taxlev=='community' & conf_cluster_whole==0){
      mat = cbind(rownames(mat), data.frame(mat, row.names=NULL))
      colnames(mat)=c('cluster','density','average biovolume','average cell carbon content')
      final=cbind(info[mat$cluster,],mat[,-1])
      if (length(cluster)==1) colnames(final)[1]=cluster
      write.table(final,paste(conf_output,'sizedensity_DATA.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
      outputs=append(outputs,paste(conf_output,'sizedensity_DATA.csv',sep=''))
    } else if (conf_taxlev!='community' & conf_cluster_whole==1) {
      mat = cbind(rownames(mat), data.frame(round(mat,2), row.names=NULL))
      colnames(mat)=c(conf_taxlev,'density','average biovolume','average cell carbon content')
      write.table(mat,paste(conf_output,'sizedensity_DATA.csv',sep=''),row.names=FALSE,sep = ";",dec = ".",quote=FALSE) 
      outputs=append(outputs,paste(conf_output,'sizedensity_DATA.csv',sep=''))
    }  
    write.table(rr,paste(conf_output,'sizedensity_MODEL_LM.csv',sep=''),row.names=TRUE,col.names=NA,sep = ";",dec = ".",quote=FALSE)
    outputs=append(outputs,paste(conf_output,'sizedensity_MODEL_LM.csv',sep=''))
    
    dev.off()
  }
  
} else {          # no taxlev and no cluster are selcted by the user: only one point on the graph and no regression model
  
  den=sum(dataset[,'density'],na.rm=TRUE)
  biom=round(mean(dataset[,'biovolume'],na.rm=TRUE),2)
  cc=round(mean(dataset[,'cellcarboncontent'],na.rm=TRUE),2)
  mat=c(den,biom,cc)
  names(mat)=c('density','biovolume','cellcarboncontent')
  xx=mat[conf_SizeUnit]
  
  
  
  file_graph=paste(conf_output,'sizedensityOutput.pdf',sep='')
  outputs=append(outputs,file_graph)
  pdf(file_graph)
  
  plot(xx,den,xlab="",ylab="",main="Whole dataset")
  if(conf_SizeUnit=='biovolume') {title(xlab=expression(paste('average biovolume (',mu,m^3,')')),line=2.5)
  } else if(conf_SizeUnit=='cellcarboncontent') title(xlab='average cell carbon content (pg C)',line=2.5)
  title(ylab=expression(paste('density (cell·',L^-1,')')),line=2.5)
  
  
  names(mat)=c('density','average biovolume','average cell carbon content')
  write.table(mat,paste(conf_output,'sizedensity_DATA.csv',sep=''),row.names=TRUE,col.names=FALSE,sep = ";",dec = ".",quote=FALSE)
  outputs=append(outputs,paste(conf_output,'sizedensity_DATA.csv',sep=''))
  
  dev.off()

}
                                  
file = ''
size = 0 
category = '' 
file_name = '' 
response = ''
for (file in outputs) {
    file_content <- readBin(file, what = "raw", n = file.info(file)$size)
    file_name <- basename(file)
    response <- httr::PUT(
      url = paste0(param_hostname,'output/',file_name),
      body = file_content,
      httr::authenticate(user = param_login, password = param_password),
      verbose()
    )
    print(response)
}
