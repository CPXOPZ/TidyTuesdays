
# packages
library(dplyr)

# data import
tuesdata <- tidytuesdayR::tt_load('2021-07-27')
tuesdata <- tidytuesdayR::tt_load(2021, week = 31)

olympics <- tuesdata$olympics

# Or read in the data manually

olympics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-27/olympics.csv')

# out
folder_name <- "20210727-W31-Olympic Medals"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

