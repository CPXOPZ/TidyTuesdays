
# in ----------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-09-07')
tuesdata <- tidytuesdayR::tt_load(2021, week = 37)

results <- tuesdata$results


# out ---------------------------------------------------------------------

folder_name <- "20210907-W37-Formula 1 Races"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}


