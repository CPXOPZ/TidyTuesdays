
# in ----------------------------------------------------------------------


tuesdata <- tidytuesdayR::tt_load('2022-01-18')
tuesdata <- tidytuesdayR::tt_load(2022, week = 3)

chocolate <- tuesdata$chocolate

# Or read in the data manually

chocolate <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-18/chocolate.csv')


# out ---------------------------------------------------------------------

folder_name <- "20220118-W03-Chocolate Bar ratings"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2022/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

