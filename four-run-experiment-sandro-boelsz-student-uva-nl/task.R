setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("XML", quietly = TRUE)) {
	install.packages("XML", repos="http://cran.us.r-project.org")
}
library(XML)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("readr", quietly = TRUE)) {
	install.packages("readr", repos="http://cran.us.r-project.org")
}
library(readr)
if (!requireNamespace("stats", quietly = TRUE)) {
	install.packages("stats", repos="http://cran.us.r-project.org")
}
library(stats)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)

secret_s3_access_id = Sys.getenv('secret_s3_access_id')
secret_s3_secret_key = Sys.getenv('secret_s3_secret_key')

print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--input_file"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--netlogo_input"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_buffer"), action="store", default=NA, type="integer", help="my description"), 
make_option(c("--param_input_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_locations"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_lookup_table"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_map_aux"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_model"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_netlogo_jar_path"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_output_dir"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_parameters"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_bucket"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_endpoint"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_region"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_s3_user_prefix"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--param_simulation"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--weather_file"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving input_file")
var = opt$input_file
print(var)
var_len = length(var)
print(paste("Variable input_file has length", var_len))

input_file <- gsub("\"", "", opt$input_file)
print("Retrieving netlogo_input")
var = opt$netlogo_input
print(var)
var_len = length(var)
print(paste("Variable netlogo_input has length", var_len))

print("------------------------Running var_serialization for netlogo_input-----------------------")
print(opt$netlogo_input)
netlogo_input = var_serialization(opt$netlogo_input)
print("---------------------------------------------------------------------------------")

print("Retrieving param_buffer")
var = opt$param_buffer
print(var)
var_len = length(var)
print(paste("Variable param_buffer has length", var_len))

param_buffer = opt$param_buffer
print("Retrieving param_input_dir")
var = opt$param_input_dir
print(var)
var_len = length(var)
print(paste("Variable param_input_dir has length", var_len))

param_input_dir <- gsub("\"", "", opt$param_input_dir)
print("Retrieving param_locations")
var = opt$param_locations
print(var)
var_len = length(var)
print(paste("Variable param_locations has length", var_len))

param_locations <- gsub("\"", "", opt$param_locations)
print("Retrieving param_lookup_table")
var = opt$param_lookup_table
print(var)
var_len = length(var)
print(paste("Variable param_lookup_table has length", var_len))

param_lookup_table <- gsub("\"", "", opt$param_lookup_table)
print("Retrieving param_map")
var = opt$param_map
print(var)
var_len = length(var)
print(paste("Variable param_map has length", var_len))

param_map <- gsub("\"", "", opt$param_map)
print("Retrieving param_map_aux")
var = opt$param_map_aux
print(var)
var_len = length(var)
print(paste("Variable param_map_aux has length", var_len))

param_map_aux <- gsub("\"", "", opt$param_map_aux)
print("Retrieving param_model")
var = opt$param_model
print(var)
var_len = length(var)
print(paste("Variable param_model has length", var_len))

param_model <- gsub("\"", "", opt$param_model)
print("Retrieving param_netlogo_jar_path")
var = opt$param_netlogo_jar_path
print(var)
var_len = length(var)
print(paste("Variable param_netlogo_jar_path has length", var_len))

param_netlogo_jar_path <- gsub("\"", "", opt$param_netlogo_jar_path)
print("Retrieving param_output_dir")
var = opt$param_output_dir
print(var)
var_len = length(var)
print(paste("Variable param_output_dir has length", var_len))

param_output_dir <- gsub("\"", "", opt$param_output_dir)
print("Retrieving param_parameters")
var = opt$param_parameters
print(var)
var_len = length(var)
print(paste("Variable param_parameters has length", var_len))

param_parameters <- gsub("\"", "", opt$param_parameters)
print("Retrieving param_s3_bucket")
var = opt$param_s3_bucket
print(var)
var_len = length(var)
print(paste("Variable param_s3_bucket has length", var_len))

param_s3_bucket <- gsub("\"", "", opt$param_s3_bucket)
print("Retrieving param_s3_endpoint")
var = opt$param_s3_endpoint
print(var)
var_len = length(var)
print(paste("Variable param_s3_endpoint has length", var_len))

param_s3_endpoint <- gsub("\"", "", opt$param_s3_endpoint)
print("Retrieving param_s3_region")
var = opt$param_s3_region
print(var)
var_len = length(var)
print(paste("Variable param_s3_region has length", var_len))

param_s3_region <- gsub("\"", "", opt$param_s3_region)
print("Retrieving param_s3_user_prefix")
var = opt$param_s3_user_prefix
print(var)
var_len = length(var)
print(paste("Variable param_s3_user_prefix has length", var_len))

param_s3_user_prefix <- gsub("\"", "", opt$param_s3_user_prefix)
print("Retrieving param_simulation")
var = opt$param_simulation
print(var)
var_len = length(var)
print(paste("Variable param_simulation has length", var_len))

param_simulation <- gsub("\"", "", opt$param_simulation)
print("Retrieving weather_file")
var = opt$weather_file
print(var)
var_len = length(var)
print(paste("Variable weather_file has length", var_len))

weather_file <- gsub("\"", "", opt$weather_file)


print("Running the cell")

library(readr)
library(purrr)
library(stringr)
library(stats)
library(dplyr)
library(XML)

user_params <- netlogo_input

if (!is.null(user_params$variables$HoneyHarvesting)) {
  user_params$variables$HoneyHarvesting <- ifelse(user_params$variables$HoneyHarvesting == 0, "false", "true")
}
if (!is.null(user_params$variables$VarroaTreatment)) {
  user_params$variables$VarroaTreatment <- ifelse(user_params$variables$VarroaTreatment == 0, "false", "true")
}
if (!is.null(user_params$variables$DroneBroodRemoval)) {
  user_params$variables$DroneBroodRemoval <- ifelse(user_params$variables$DroneBroodRemoval == 0, "false", "true")
}

stopifnot(file.exists(input_file))
stopifnot(file.exists(weather_file))

weather_content <- read_file(weather_file)

weather_values <- str_split(gsub("\\[|\\]", "", weather_content), " ", simplify = TRUE)

weather <- suppressWarnings(as.numeric(weather_values))

weather <- na.omit(weather)
weather <- rep(weather, 10)

make_nl_XML <- function(input_list){
  
 experimentXML <- newXMLDoc()

  experiment <- newXMLNode(
    "experiment",
    attrs = list(
      name = "Exp1",
      repetitions = "1",
      runMetricsEveryStep = "true"
    )
  ) 
  experiment <- experiment |>
    addChildren(
      newXMLNode(
        "setup",
        "setup",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "go",
        "go",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "timeLimit",
        attrs = c(steps = input_list$sim_days),
        parent = experiment
      )
    )
  
  for (i in seq_along(input_list$metric)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "metric",
          input_list$metrics[[i]],
          parent = experiment
        )
      )
  }
  
  variables_names <- input_list$variables |>
    names()
  
  for (i in seq_along(input_list$variables)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "enumeratedValueSet",
          newXMLNode(
            "value",
            attrs = c(value = input_list$variables[[i]])
          ),
          attrs = c(variable = variables_names[i]),
          parent = experiment
        )
      )
  }
  
  experiments <- newXMLNode(
    "experiments",
    experiment,
    doc = experimentXML
  )
  
  return(experiments)
}

run_simulation <- function(
    netlogo_jar_path,
    model_path,
    output_path,
    input_list,
    xml_path = NULL,
    memory = 2048,
    threads = 1
) {
  if (is.null(xml_path)) {
    xml_path <- paste0(tempfile(pattern = "netlogo_xml_"), ".xml")
  }
  
  simulation_xml <- make_nl_XML(input_list)

  saveXML(
    simulation_xml,
    file = xml_path
  )

  netlogo_jar_path <- gsub('^"|"$', '', netlogo_jar_path)
  model_path <- gsub('^"|"$', '', model_path)
  xml_path <- gsub('^"|"$', '', xml_path)
  output_path <- gsub('^"|"$', '', output_path)

  print(paste("NetLogo JAR Path:", netlogo_jar_path))
  print(paste("Model Path:", model_path))
  print(paste("XML Path:", xml_path))
  print(paste("Output Path:", output_path))

  system_cmd <- paste(
    'java',
    paste0('-Xmx', memory, 'm -Dfile.encoding=UTF-8'),
    '-classpath', shQuote(netlogo_jar_path),
    'org.nlogo.headless.Main',
    '--model', shQuote(model_path),
    '--setup-file', shQuote(xml_path),
    '--experiment Exp1',
    '--table', shQuote(output_path),
    '--threads', threads
  )

  print(system_cmd)
  system(system_cmd)
  
  results <- read_csv(
    output_path,
    skip = 6,
    col_types = cols()
  )
  
  return(results)
}

make_nl_XML <- function(input_list){
  
 experimentXML <- newXMLDoc()

  experiment <- newXMLNode(
    "experiment",
    attrs = list(
      name = "Exp1",
      repetitions = "1",
      runMetricsEveryStep = "true"
    )
  ) 
  experiment <- experiment |>
    addChildren(
      newXMLNode(
        "setup",
        "setup",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "go",
        "go",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "timeLimit",
        attrs = c(steps = input_list$sim_days),
        parent = experiment
      )
    )
  
  for (i in seq_along(input_list$metric)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "metric",
          input_list$metrics[[i]],
          parent = experiment
        )
      )
  }
  
  variables_names <- input_list$variables |>
    names()
  
  for (i in seq_along(input_list$variables)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "enumeratedValueSet",
          newXMLNode(
            "value",
            attrs = c(value = input_list$variables[[i]])
          ),
          attrs = c(variable = variables_names[i]),
          parent = experiment
        )
      )
  }
  
  experiments <- newXMLNode(
    "experiments",
    experiment,
    doc = experimentXML
  )
  
  return(experiments)
}#Step 3
make_nl_XML <- function(input_list){
  
 experimentXML <- newXMLDoc()

  experiment <- newXMLNode(
    "experiment",
    attrs = list(
      name = "Exp1",
      repetitions = "1",
      runMetricsEveryStep = "true"
    )
  ) 
  experiment <- experiment |>
    addChildren(
      newXMLNode(
        "setup",
        "setup",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "go",
        "go",
        parent = experiment
      )
    ) |>
    addChildren(
      newXMLNode(
        "timeLimit",
        attrs = c(steps = input_list$sim_days),
        parent = experiment
      )
    )
  
  for (i in seq_along(input_list$metric)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "metric",
          input_list$metrics[[i]],
          parent = experiment
        )
      )
  }
  
  variables_names <- input_list$variables |>
    names()
  
  for (i in seq_along(input_list$variables)) {
    experiment <- experiment |>
      addChildren(
        newXMLNode(
          "enumeratedValueSet",
          newXMLNode(
            "value",
            attrs = c(value = input_list$variables[[i]])
          ),
          attrs = c(variable = variables_names[i]),
          parent = experiment
        )
      )
  }
  
  experiments <- newXMLNode(
    "experiments",
    experiment,
    doc = experimentXML
  )
  
  return(experiments)
}

model_path <- paste0(param_input_dir, param_model)

results <- run_simulation(
  param_netlogo_jar_path,
  model_path,
  user_params$outpath,
  user_params
)

start_date <- user_params$start_day[[1]] |>
  as.Date()

results <- results |>
  mutate(weather = weather[1:nrow(results)],
         date = seq(from = start_date,
                    to = start_date + user_params$sim_days[[1]],
                    by = "day"))

write.table(results,
            file = user_params$outpath,
            sep = ",",
            row.names = FALSE)

output_file <- user_params$outpath
# capturing outputs
print('Serialization of output_file')
file <- file(paste0('/tmp/output_file_', id, '.json'))
writeLines(toJSON(output_file, auto_unbox=TRUE), file)
close(file)
