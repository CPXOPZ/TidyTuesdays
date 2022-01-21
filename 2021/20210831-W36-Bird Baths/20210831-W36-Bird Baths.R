
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-08-31')
tuesdata <- tidytuesdayR::tt_load(2021, week = 36)

bird_baths <- tuesdata$bird_baths

# Or read in the data manually

bird_baths <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-31/bird_baths.csv')


# out ---------------------------------------------------------------------

folder_name <- "20210831-W36-Bird Baths"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}


