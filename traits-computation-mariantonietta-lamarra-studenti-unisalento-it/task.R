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
make_option(c("--param_CalcType"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_CompTraits"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_CountingStrategy"), action="store", default=NA, type="character", help="my description"), 
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
print("Retrieving param_CalcType")
var = opt$param_CalcType
print(var)
var_len = length(var)
print(paste("Variable param_CalcType has length", var_len))

param_CalcType <- gsub("\"", "", opt$param_CalcType)
print("Retrieving param_CompTraits")
var = opt$param_CompTraits
print(var)
var_len = length(var)
print(paste("Variable param_CompTraits has length", var_len))

param_CompTraits <- gsub("\"", "", opt$param_CompTraits)
print("Retrieving param_CountingStrategy")
var = opt$param_CountingStrategy
print(var)
var_len = length(var)
print(paste("Variable param_CountingStrategy has length", var_len))

param_CountingStrategy <- gsub("\"", "", opt$param_CountingStrategy)
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


print("Running the cell")







conf_datain1 = "Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv"
conf_datain2 = '2_FILEinformativo_OPERATORE.csv'

conf_output = '/tmp/data/'

CompTraits <- as.list(scan(text = param_CompTraits, what = "", sep = ","))

formulaforsurfacesimplified = ''
formulaforbiovolumesimplified = ''
volumeofsedimentationchamber = ''
formulaformissingdimensionsimplified = ''
formulaforweight2 = ''
cellcarboncontent = ''
formulaforweight1 = ''
formulaforsurface = ''
formulaforbiovolume = ''
formulaformissingdimension = ''
surfacearea = ''
biovolume = ''

install.packages("RCurl",repos = "http://cran.us.r-project.org")
library("RCurl")
install.packages("httr",repos = "http://cran.us.r-project.org")
library("httr")

auth = basicTextGatherer()
cred = paste(param_login, param_password, sep = ":")

file_name = "Phytoplankton__Progetto_Strategico_2009_2012_Australia.csv"
dest_1 = paste(conf_output, file_name,sep = "")
download_file = paste0(param_hostname,file_name)
print(download_file)
file_content <- getURL(download_file, curl = getCurlHandle(userpwd = cred))
write(file_content, file = dest_1)

file_name = "2_FILEinformativo_OPERATORE.csv"
dest_2 = paste(conf_output, file_name,sep = "")
download_file = paste0(param_hostname,file_name)
print(download_file)
file_content <- getURL(download_file, curl = getCurlHandle(userpwd = cred))
write(file_content, file = dest_2)


df.datain=read.csv(dest_1,stringsAsFactors=FALSE,sep = ";", dec = ".")
df.datain[,'measurementremarks'] = tolower(df.datain[,'measurementremarks']) # eliminate capital letters
df.datain[,'index'] = c(1:nrow(df.datain)) # needed to restore rows order later

df.operator=read.csv(dest_2,stringsAsFactors=FALSE,sep = ",", dec = ".") # load internal database 
df.operator[df.operator==('no')]<-NA
df.operator[df.operator==('see note')]<-NA

df.merged = merge(x = df.datain, y = df.operator, by = c("scientificname","measurementremarks"), all.x = TRUE)

if(!'diameterofsedimentationchamber'%in%names(df.merged))df.merged[,'diameterofsedimentationchamber']=NA
if(!'diameteroffieldofview'%in%names(df.merged))df.merged[,'diameteroffieldofview']=NA
if(!'transectcounting'%in%names(df.merged))df.merged[,'transectcounting']=NA
if(!'numberofcountedfields'%in%names(df.merged))df.merged[,'numberofcountedfields']=df.merged[,'transectcounting']
if(!'numberoftransects'%in%names(df.merged))df.merged[,'numberoftransects']=df.merged[,'transectcounting']
if(!'settlingvolume'%in%names(df.merged))df.merged[,'settlingvolume']=NA
if(!'dilutionfactor'%in%names(df.merged))df.merged[,'dilutionfactor']=1


if(param_CalcType=='advanced'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimension']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimension']),'formulaformissingdimension'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimension==md.form)
    for(md in unique(df.temp[,'missingdimension'])){
      df.temp2 = df.temp[df.temp[,'missingdimension']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
} else if(param_CalcType=='simplified'){
  df.merged.concat = df.merged[is.na(df.merged[,'formulaformissingdimensionsimplified']),]
  md.formulas = unique(df.merged[!is.na(df.merged[,'formulaformissingdimensionsimplified']),'formulaformissingdimensionsimplified'])
  for(md.form in md.formulas){
    df.temp = subset(df.merged,formulaformissingdimensionsimplified==md.form)
    for(md in unique(df.temp[,'missingdimensionsimplified'])){
      df.temp2 = df.temp[df.temp[,'missingdimensionsimplified']==md,]
      df.temp2[[md]] = round(with(df.temp2,eval(parse(text=md.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp2)
    }
  }
  df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
  df.merged = df.merged.concat
}


if('biovolume'%in%CompTraits){
  if(param_CalcType=='advanced'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolume']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolume']),'formulaforbiovolume'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolume==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
  else if(param_CalcType=='simplified'){
    df.merged[,'biovolume'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforbiovolumesimplified']),]
    bv.formulas = unique(df.merged[!is.na(df.merged[,'formulaforbiovolumesimplified']),'formulaforbiovolumesimplified'])
    for(bv.form in bv.formulas){
      df.temp = subset(df.merged,formulaforbiovolumesimplified==bv.form)
      df.temp[,'biovolume'] = round(with(df.temp,eval(parse(text=bv.form))),2)
      df.merged.concat <- rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
} 


if('surfacearea'%in%CompTraits){
  if(param_CalcType=='advanced'){
    df.merged[,'surfacearea'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforsurface']),]
    sa.formulas = unique(df.merged[!is.na(df.merged[,'formulaforsurface']),'formulaforsurface'])
    for(sa.form in sa.formulas){
      df.temp = subset(df.merged,formulaforsurface==sa.form)
      df.temp[,'surfacearea'] = round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
  else if(param_CalcType=='simplified'){
    df.merged[,'surfacearea'] = rep(NA,length=nrow(df.merged))
    df.merged.concat = df.merged[is.na(df.merged[,'formulaforsurfacesimplified']),]
    sa.formulas = unique(df.merged[!is.na(df.merged[,'formulaforsurfacesimplified']),'formulaforsurfacesimplified'])
    for(sa.form in sa.formulas){
      df.temp = subset(df.merged,formulaforsurfacesimplified==sa.form)
      df.temp[,'surfacearea'] = round(with(df.temp,eval(parse(text=sa.form))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
}
    
    
if('cellcarboncontent'%in%CompTraits){
  df.merged[,'cellcarboncontent'] = rep(NA,length=nrow(df.merged))
  if('biovolume'%in%CompTraits){
    df.merged.concat = df.merged[is.na(df.merged[,'biovolume']),]
    df.cc = df.merged[!is.na(df.merged[,'biovolume']),]
    df.cc1 = subset(df.cc,biovolume <= 3000)
    df.cc2 = subset(df.cc,biovolume > 3000)
    cc.formulas1 = unique(df.merged[!is.na(df.merged[,'formulaforweight1']),'formulaforweight1'])
    for(cc.form in cc.formulas1){
      df.temp = subset(df.cc1,formulaforweight1==cc.form)
      df.temp[,'cellcarboncontent'] = round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    cc.formulas2 = unique(df.merged[!is.na(df.merged[,'formulaforweight2']),'formulaforweight2'])
    for(cc.form in cc.formulas2){
      df.temp = subset(df.cc2,formulaforweight2==cc.form)
      df.temp$cellcarboncontent = round(with(df.temp,eval(parse(text=tolower(cc.form)))),2)
      df.merged.concat = rbind(df.merged.concat,df.temp)
    }
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
  }
}

    
    
if('density'%in%CompTraits){
  df.merged[,'density'] = rep(NA,length=nrow(df.merged))
  if(param_CountingStrategy=='density0'){  
    df.merged.concat = df.merged[(is.na(df.merged[,'volumeofsedimentationchamber'])) & (is.na(df.merged[,'transectcounting'])),]
    df.temp = df.merged[!is.na(df.merged[,'volumeofsedimentationchamber']) & !is.na(df.merged[,'transectcounting']),]
    df.temp1 = subset(df.temp,volumeofsedimentationchamber <= 5)
    df.temp1[,'density'] = df.temp1[,'organismquantity']/df.temp1[,'transectcounting']*1000/0.001979
    df.merged.concat = rbind(df.merged.concat,df.temp1)
    df.temp2 = subset(df.temp,(volumeofsedimentationchamber > 5) & (volumeofsedimentationchamber <= 10))
    df.temp2[,'density'] = df.temp2[,'organismquantity']/df.temp2[,'transectcounting']*1000/0.00365
    df.merged.concat = rbind(df.merged.concat,df.temp2)
    df.temp3 = subset(df.temp,(volumeofsedimentationchamber > 10) & (volumeofsedimentationchamber <= 25))
    df.temp3[,'density'] = df.temp3[,'organismquantity']/df.temp3[,'transectcounting']*1000/0.010555
    df.merged.concat = rbind(df.merged.concat,df.temp3)
    df.temp4 = subset(df.temp,(volumeofsedimentationchamber > 25) & (volumeofsedimentationchamber <= 50))
    df.temp4[,'density'] = df.temp4[,'organismquantity']/df.temp4[,'transectcounting']*1000/0.021703
    df.merged.concat = rbind(df.merged.concat,df.temp4)
    df.temp5 = subset(df.temp,volumeofsedimentationchamber > 50)
    df.temp5[,'density'] = df.temp5[,'organismquantity']/df.temp5[,'transectcounting']*1000/0.041598
    df.merged.concat = rbind(df.merged.concat,df.temp5)
    df.merged.concat = df.merged.concat[order(df.merged.concat[,'index']),]
    df.merged = df.merged.concat
    df.merged[,'density'] = round(df.merged[,'density'],2)
  }
  else if(param_CountingStrategy=='density1'){
    df.merged[,'areaofsedimentationchamber'] = ((df.merged[,'diameterofsedimentationchamber']/2)^2)*pi
    df.merged[,'areaofcountingfield'] = ((df.merged[,'diameteroffieldofview']/2)^2)*pi
    df.merged[,'density'] = round(df.merged[,'organismquantity']*1000*df.merged[,'areaofsedimentationchamber']/df.merged[,'numberofcountedfields']*df.merged[,'areaofcountingfield']*df.merged[,'settlingvolume'],2)
  }
  else if(param_CountingStrategy=='density2'){
    df.merged[,'density'] = round(((df.merged[,'organismquantity']/df.merged[,'numberoftransects'])*(pi/4)*(df.merged[,'diameterofsedimentationchamber']/df.merged[,'diameteroffieldofview']))*1000/df.merged[,'settlingvolume'],2)
  }
  else if(param_CountingStrategy=='density3'){
    df.merged[,'density'] = round((df.merged[,'organismquantity']*1000)/df.merged[,'settlingvolume'],2)
  }
  df.merged[,'density'] = df.merged[,'density']/df.merged[,'dilutionfactor']
}   
  
    
if('totalbiovolume'%in%CompTraits){
  if((!'density'%in%CompTraits) & (!'density'%in%names(df.merged))) df.merged[,'density']=NA
  if((!'biovolume'%in%CompTraits) & (!'biovolume'%in%names(df.merged))) df.merged[,'biovolume']=NA
  df.merged[,'totalbiovolume'] = round(df.merged[,'density']*df.merged[,'biovolume'],2)
}
    
    
if('surfacevolumeratio'%in%CompTraits){
  if(('surfacearea'%in%CompTraits) & (!'surfacearea'%in%names(df.merged))) df.merged[,'surfacearea']=NA
  if(('biovolume'%in%CompTraits) & (!'biovolume'%in%names(df.merged))) df.merged[,'biovolume']=NA
  df.merged[,'surfacevolumeratio']=round(df.merged[,'surfacearea']/df.merged[,'biovolume'],2)
}
    
    
if('totalcarboncontent'%in%CompTraits){
  if((!'density'%in%CompTraits) & (!'density'%in%names(df.merged))) df.merged[,'density']=NA
  if((!'cellcarboncontent'%in%CompTraits) & (!'cellcarboncontent'%in%names(df.merged))) df.merged[,'cellcarboncontent']=NA
  df.merged[,'totalcarboncontent']=round(df.merged[,'density']*df.merged[,'cellcarboncontent'],2)
}    
    
    

if('biovolume'%in%CompTraits) {
    if('biovolume'%in%names(df.datain)) df.datain=subset(df.datain,select=-biovolume) # drop column if already present
    df.datain[,'biovolume'] = df.merged[,'biovolume'] # write column with the results at the end of the dataframe
    }
if('cellcarboncontent'%in%CompTraits) {
    if('cellcarboncontent'%in%names(df.datain)) df.datain=subset(df.datain,select=-cellcarboncontent)
    df.datain[,'cellcarboncontent'] = df.merged[,'cellcarboncontent']
    }
if('density'%in%CompTraits) {
    df.datain[,'density'] = df.merged[,'density']
    }
if('totalbiovolume'%in%CompTraits) {
    df.datain[,'totalbiovolume'] = df.merged[,'totalbiovolume']
    }
if('surfacearea'%in%CompTraits) {
    if('surfacearea'%in%names(df.datain)) df.datain=subset(df.datain,select=-surfacearea)
    df.datain[,'surfacearea'] = df.merged[,'surfacearea']
    }
if('surfacevolumeratio'%in%CompTraits) {
    df.datain[,'surfacevolumeratio'] = df.merged[,'surfacevolumeratio']
    }
if('totalcarboncontent'%in%CompTraits) {
    df.datain[,'totalcarboncontent'] = df.merged[,'totalcarboncontent']
    }
    

output_traitscomp = paste(conf_output, "df_traitscomp.csv",sep = "")
write.table(df.datain,output_traitscomp,row.names=FALSE,sep = ";",dec = ".",quote=FALSE)
# capturing outputs
print('Serialization of output_traitscomp')
file <- file(paste0('/tmp/output_traitscomp_', id, '.json'))
writeLines(toJSON(output_traitscomp, auto_unbox=TRUE), file)
close(file)
