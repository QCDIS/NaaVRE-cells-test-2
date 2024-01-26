setwd('/app')

# retrieve input parameters

library(optparse)
library(jsonlite)
if (!requireNamespace("climwin", quietly = TRUE)) {
	install.packages("climwin", repos="http://cran.us.r-project.org")
}
library(climwin)
if (!requireNamespace("dplyr", quietly = TRUE)) {
	install.packages("dplyr", repos="http://cran.us.r-project.org")
}
library(dplyr)
if (!requireNamespace("ggpubr", quietly = TRUE)) {
	install.packages("ggpubr", repos="http://cran.us.r-project.org")
}
library(ggpubr)
if (!requireNamespace("lubridate", quietly = TRUE)) {
	install.packages("lubridate", repos="http://cran.us.r-project.org")
}
library(lubridate)
if (!requireNamespace("purrr", quietly = TRUE)) {
	install.packages("purrr", repos="http://cran.us.r-project.org")
}
library(purrr)
if (!requireNamespace("stringr", quietly = TRUE)) {
	install.packages("stringr", repos="http://cran.us.r-project.org")
}
library(stringr)


option_list = list(

make_option(c("--firstWindow_file"), action="store", default=NA, type="character", help="my description"), 
make_option(c("--id"), action="store", default=NA, type="character", help="my description")

)

# set input parameters accordingly
opt = parse_args(OptionParser(option_list=option_list))


firstWindow_file <- gsub('"', '', opt$firstWindow_file)
id <- gsub('"', '', opt$id)







load(firstWindow_file)



colour_pal <- c("#48d3d3", "#FC8D59", "#D53E4F", "#FFD560", "#3288BD")



plot_climwin_output <- function(x){

  # create a heat map of model delta AICc values
  AIC_heatmap <- climwin::plotdelta(dataset = x$best_window[[1]]$Dataset,
                                    arrow = TRUE) +
    ggplot2::theme_classic() +
    ggplot2::labs(subtitle = x$biological_data$scientificName %>% unique())

  # get annual mean temperatures of the best window
  mean_temp_in_window <- temp %>%
    dplyr::filter(dummy > (lubridate::month(x$start_date) * 100 + lubridate::day(x$start_date)) &
                    dummy < (lubridate::month(x$end_date) * 100 + lubridate::day(x$end_date))) %>%
    dplyr::summarise(mean_temp = mean(temperature, na.rm = TRUE),
                     .by = c("year", "locID"))

  # add mean temperatures to annual bud burst data
  annual_budburst_and_temp <- dplyr::left_join(x$biological_data,
                                               mean_temp_in_window %>%
                                                 dplyr::select("year", "mean_temp", "locID"),
                                               by = c("year", "locID"))

  # plot annual mean temperatures of the best window against annual average bud burst dates
  plot_budburst_temperature<-  ggplot2::ggplot(data = annual_budburst_and_temp,
                                               mapping = aes(x = mean_temp, y = avg_bud_burst_DOY, colour = locID)) +
    ggplot2::geom_point(size = 2, alpha = 0.75) +
    ggplot2::geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
    ggplot2::theme_classic() +
    ggplot2::scale_colour_manual(values = colour_pal) +
    ggplot2::labs(subtitle = x$biological_data$scientificName %>% unique(),
                  title = "Annual bud burst date ~ annual mean temperature in best window",
                  x = "Mean temperature [°C]",
                  y = "Annual mean bud burst date")

  # arrange both plots in one figure
  ggpubr::ggarrange(AIC_heatmap,  plot_budburst_temperature)

}

Fig_Qrobur <- plot_climwin_output(first_window_Qrobur)
Fig_Qrobur



