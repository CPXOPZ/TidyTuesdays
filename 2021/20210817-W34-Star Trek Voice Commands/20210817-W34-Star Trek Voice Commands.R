
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-08-17')
tuesdata <- tidytuesdayR::tt_load(2021, week = 34)

computer <- tuesdata$computer

# Or read in the data manually

computer <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-17/computer.csv')


# out ---------------------------------------------------------------------

folder_name <- "20210817-W34-Star Trek Voice Commands"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

