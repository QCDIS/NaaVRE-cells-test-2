setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("utils", quietly = TRUE)) {
	install.packages("utils", repos="http://cran.us.r-project.org")
}
library(utils)


print('option_list')
option_list = list(

make_option(c("--bifur_output"), action="store", default=NA, type="character", help="my description"), 
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

print("Retrieving bifur_output")
var = opt$bifur_output
print(var)
var_len = length(var)
print(paste("Variable bifur_output has length", var_len))

print("------------------------Running var_serialization for bifur_output-----------------------")
print(opt$bifur_output)
bifur_output = var_serialization(opt$bifur_output)
print("---------------------------------------------------------------------------------")

print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)


print("Running the cell")





comb_df <- NULL
for (df_output in bifur_output){
    df <- read.csv(df_output)
    comb_df <- rbind(comb_df, df)
    print(mean(df[,"oChla"]))
    print(unique(df[,"PLoad"]))
}

unique(comb_df$PLoad)
head(comb_df)

PLoad_vec <- unique(comb_df$PLoad)
PLoad_vec


fig_PCLake_PLoads = "/tmp/data/PCLake_PLoads.png"

png(fig_PCLake_PLoads)
par(mfrow=c(3,3))
plot(comb_df$time[which(comb_df$PLoad==PLoad_vec[1])], comb_df$oChla[which(comb_df$PLoad==PLoad_vec[1])], 
     ylim= range(comb_df$oChla)*1.15,
     , col=1, t="l",
     ylab="oChla [mg/m3]", xlab="time")

for(ii in length(PLoad_vec[-1])){
    points(comb_df$time[which(comb_df$PLoad==PLoad_vec[ii+1])], comb_df$oChla[which(comb_df$PLoad==PLoad_vec[ii+1])]
           , col=ii+1, pch=19, cex=0.2)
}

legend("topleft",legend=paste0("PLoad=",PLoad_vec, " gP/m2/day"), text.col = 1:length(PLoad_vec))
dev.off()

