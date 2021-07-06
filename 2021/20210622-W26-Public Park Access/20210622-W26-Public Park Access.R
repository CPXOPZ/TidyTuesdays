
# packages ----------------------------------------------------------------


# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-06-22')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 26)
# 
# parks <- tuesdata$parks
# 
# # Or read in the data manually

parks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-22/parks.csv')

