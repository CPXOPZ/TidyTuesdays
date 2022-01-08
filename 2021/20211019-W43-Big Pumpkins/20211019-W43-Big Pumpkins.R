
# packages ----------------------------------------------------------------
library(dplyr)

# data import -------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-10-19')
tuesdata <- tidytuesdayR::tt_load(2021, week = 43)

pumpkins <- tuesdata$pumpkins

# Or read in the data manually

pumpkins <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-19/pumpkins.csv')

# data prepare ------------------------------------------------------------

tuesdata$pumpkins <- tuesdata$pumpkins %>% 
  dplyr::filter(stringr::str_detect(place, "Entries", negate = TRUE))

folder_name <- "20211019-W43-Big Pumpkins"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}
