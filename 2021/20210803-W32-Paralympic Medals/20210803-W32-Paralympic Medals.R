
# packages ----------------------------------------------------------------


# import data -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-08-03')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 32)
# 
# athletes <- tuesdata$athletes

# Or read in the data manually  

athletes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-03/athletes.csv')


# out ---------------------------------------------------------------------

folder_name <- "20210803-W32-Paralympic Medals"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

