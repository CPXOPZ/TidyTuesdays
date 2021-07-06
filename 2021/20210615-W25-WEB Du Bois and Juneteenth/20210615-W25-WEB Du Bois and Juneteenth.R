
# packages ----------------------------------------------------------------


# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-06-15')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 25)
# 
# tweets <- tuesdata$tweets

# Or read in the data manually

tweets <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-15/tweets.csv')
