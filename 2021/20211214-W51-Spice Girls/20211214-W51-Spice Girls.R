
# data --------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-12-14')
tuesdata <- tidytuesdayR::tt_load(2021, week = 51)

studio_album_tracks <- tuesdata$studio_album_tracks

# Or read in the data manually

studio_album_tracks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-12-14/studio_album_tracks.csv')


# export ------------------------------------------------------------------

folder_name <- "20211214-W51-Spice Girls"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[i],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}
