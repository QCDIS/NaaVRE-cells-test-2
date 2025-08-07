setwd('/app')
library(optparse)
library(jsonlite)

if (!requireNamespace("ggplot2", quietly = TRUE)) {
	install.packages("ggplot2", repos="http://cran.us.r-project.org")
}
library(ggplot2)
if (!requireNamespace("tools4watlas", quietly = TRUE)) {
	install.packages("tools4watlas", repos="http://cran.us.r-project.org")
}
library(tools4watlas)


print('option_list')
option_list = list(

make_option(c("--id"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--my_fake_input"), action="store", default=NA, type="character", help="my description")
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
print("Retrieving my_fake_input")
var = opt$my_fake_input
print(var)
var_len = length(var)
print(paste("Variable my_fake_input has length", var_len))

my_fake_input <- gsub("\"", "", opt$my_fake_input)


print("Running the cell")

my_fake_input <- "test"
my_fake_output <- "test_Bird"
library(tools4watlas)
library(ggplot2)

data <- data_example

bm <- atl_create_bm(data, buffer = 800)

bm +
  geom_path(
    data = data, aes(x, y, colour = species),
    linewidth = 0.5, alpha = 0.5, show.legend = FALSE
  ) +
  geom_point(
    data = data, aes(x, y, color = species),
    size = 0.5, alpha = 0.5, show.legend = TRUE
  ) +
  scale_color_manual(
    values = atl_spec_cols(),
    labels = atl_spec_labs("multiline"),
    name = ""
  ) +
  guides(colour = guide_legend(
    nrow = 1, override.aes = list(size = 7, pch = 16, alpha = 1)
  )) +
  theme(
    legend.position = "top",
    legend.justification = "center",
    legend.key = element_blank(),
    legend.background = element_rect(fill = "transparent")
  )
# capturing outputs
print('Serialization of my_fake_output')
file <- file(paste0('/tmp/my_fake_output_', id, '.json'))
writeLines(toJSON(my_fake_output, auto_unbox=TRUE), file)
close(file)
