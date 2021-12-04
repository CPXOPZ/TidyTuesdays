

# packages ----------------------------------------------------------------


# data import -------------------------------------------------------------


tuesdata <- tidytuesdayR::tt_load('2021-11-30')
tuesdata <- tidytuesdayR::tt_load(2021, week = 49)

matches <- tuesdata$matches

# Or read in the data manually

matches <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-30/matches.csv')


write.csv(matches, here::here("2021/20211130-W49-World Cup Cricket","matches.csv"),row.names = F,na = "")


# haven::write_sas(matches,here::here("2021/20211130-W49-World Cup Cricket","matches.sas7bdat"))
