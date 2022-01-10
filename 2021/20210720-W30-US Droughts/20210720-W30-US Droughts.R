
# packages ----------------------------------------------------------------


# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-07-20')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 30)
# 
# drought <- tuesdata$drought

# Or read in the data manually

drought <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-20/drought.csv')


# data prepare ------------------------------------------------------------

folder_name <- "20210720-W30-US Droughts"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

