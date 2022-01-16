
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2022-01-11')
tuesdata <- tidytuesdayR::tt_load(2022, week = 2)

colony <- tuesdata$colony

# Or read in the data manually

colony <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-11/colony.csv')
stressor <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-11/stressor.csv')

# out ---------------------------------------------------------------------

folder_name <- "20220111-W02-Bee Colony losses"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2022/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

