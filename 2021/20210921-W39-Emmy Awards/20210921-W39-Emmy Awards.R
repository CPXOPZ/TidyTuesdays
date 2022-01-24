
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-09-21')
tuesdata <- tidytuesdayR::tt_load(2021, week = 39)

nominees <- tuesdata$nominees

# Or read in the data manually

nominees <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-21/nominees.csv')


# out ---------------------------------------------------------------------

folder_name <- "20210921-W39-Emmy Awards"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}



