
# packages ----------------------------------------------------------------


# data import -------------------------------------------------------------

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-12-07')
tuesdata <- tidytuesdayR::tt_load(2021, week = 50)

spiders <- tuesdata$spiders

# Or read in the data manually

spiders <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-12-07/spiders.csv')


# data output -------------------------------------------------------------

write.csv(spiders, here::here("2021/20211207-W50-Spiders","spides.csv"),row.names = F,na = "")

