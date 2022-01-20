
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-08-24')
tuesdata <- tidytuesdayR::tt_load(2021, week = 35)

lemurs <- tuesdata$lemurs

# Or read in the data manually

lemurs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-24/lemur_data.csv')

# out ---------------------------------------------------------------------

folder_name <- "20210824-W35-Lemurs"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

