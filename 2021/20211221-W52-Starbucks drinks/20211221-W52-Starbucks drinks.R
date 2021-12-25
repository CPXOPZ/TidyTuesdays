
# data import -------------------------------------------------------------


tuesdata <- tidytuesdayR::tt_load('2021-12-21')
tuesdata <- tidytuesdayR::tt_load(2021, week = 52)

starbucks <- tuesdata$starbucks

# Or read in the data manually

starbucks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-12-21/starbucks.csv')


# data output -------------------------------------------------------------

folder_name <- "20211221-W52-Starbucks drinks"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}
