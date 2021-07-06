
# packages ----------------------------------------------------------------
library(dplyr)

# data import -------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-06-08')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 24)
# 
# fishing <- tuesdata$fishing

# Or read in the data manually

fishing <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv')
stocked <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/stocked.csv')

# data pre ----------------------------------------------------------------
skimr::skim(fishing)
skimr::skim(stocked)

# plot --------------------------------------------------------------------


# final -------------------------------------------------------------------

# 20210608-W24-Great Lakes Fish
