setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("devtools", quietly = TRUE)) {
	install.packages("devtools", repos="http://cran.us.r-project.org")
}
library(devtools)
if (!requireNamespace("ggplot2", quietly = TRUE)) {
	install.packages("ggplot2", repos="http://cran.us.r-project.org")
}
library(ggplot2)
if (!requireNamespace("minioclient", quietly = TRUE)) {
	install.packages("minioclient", repos="http://cran.us.r-project.org")
}
library(minioclient)
if (!requireNamespace("processx", quietly = TRUE)) {
	install.packages("processx", repos="http://cran.us.r-project.org")
}
library(processx)

secret_s3_access_key = Sys.getenv('secret_s3_access_key')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--combined_df_filename"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_server"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description")
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

print("Retrieving combined_df_filename")
var = opt$combined_df_filename
print(var)
var_len = length(var)
print(paste("Variable combined_df_filename has length", var_len))

combined_df_filename <- gsub("\"", "", opt$combined_df_filename)
print("Retrieving id")
var = opt$id
print(var)
var_len = length(var)
print(paste("Variable id has length", var_len))

id <- gsub("\"", "", opt$id)
print("Retrieving param_s3_server")
var = opt$param_s3_server
print(var)
var_len = length(var)
print(paste("Variable param_s3_server has length", var_len))

param_s3_server <- gsub("\"", "", opt$param_s3_server)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)


print("Running the cell")

comb_df = read.csv(combined_df_filename)
PLoad_vec = unique(comb_df$PLoad)

figname_PCLake_PLoads = "/home/jovyan/PCLake_Naavre/PCLake_PLoads.png" # save your plot in the current folder within virtual lab

png(figname_PCLake_PLoads, width=900, height=600)
library(ggplot2)


ggplot(comb_df, aes(x = time, y = oChla, color = factor(PLoad))) +
  geom_line() +
  geom_point(size = 0.2) +
  scale_color_manual(values = 1:length(PLoad_vec), 
                     labels = paste0("PLoad=", PLoad_vec, " gP/m2/day")) +
  labs(y = "oChla [mg/m3]", x = "time", color = "PLoad")  +
  theme_minimal() +
  theme(legend.position = "right", aspect.ratio=1/2, plot.margin=unit(c(0.1, 0.1, 0.1, 0.1),"cm"))
dev.off()

devtools::install_github("cboettig/minioclient")

library(minioclient)
install_mc()

library(processx)
processx::run("apt-get", "update", error_on_status=FALSE)
processx::run("apt-get", c("install", "-y", "ca-certificates"), error_on_status=FALSE)

mc_alias_set(
    alias = "scruffy",
    endpoint = param_s3_server,
    access_key = secret_s3_access_key,
    secret_key = secret_s3_secret_key,
)
  
mc_cp(combined_df_filename, paste0("scruffy/naa-vre-user-data/", param_s3_user_prefix, "/PCLake_output.csv"))     
mc_cp(figname_PCLake_PLoads, paste0("scruffy/naa-vre-user-data/", param_s3_user_prefix, "/PCLake_PLoads.png"))
