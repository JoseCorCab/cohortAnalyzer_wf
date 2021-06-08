#!/usr/bin/env Rscript

library(ggplot2)
library(dplyr)
args <- commandArgs(trailingOnly = TRUE)

data <- read.table(args[1], row.names = NULL, header = FALSE)

str(data)

data<- data[data$V2 != Inf,] 


data_sum <- data %>% group_by(V3, V4) %>% summarise(means = mean(V2))
print(data_sum)



pp <- ggplot2::ggplot(data, ggplot2::aes(y = V2, x = V4, fill = V3))+ ggplot2::geom_boxplot() 


if (!is.na(args[3])){

        fig_names <- unlist(strsplit(args[3], ","))

	pp <- pp + ggplot2::labs(x = fig_names[1], y = fig_names[2], fill = fig_names[3])
} else {
        message("You can specify titles as comma separated third argument: y_axis,x_axis,fill")
}

ggplot2::ggsave(filename = paste0(args[2],".png"),pp,width = 20, height = 20, dpi = 200, units = "cm", device='png')

