
# data --------------------------------------------------------------------

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-10-26')
tuesdata <- tidytuesdayR::tt_load(2021, week = 44)

ultra_rankings <- tuesdata$ultra_rankings

# Or read in the data manually

ultra_rankings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/ultra_rankings.csv')
race <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-26/race.csv')


# export ------------------------------------------------------------------

write.csv(ultra_rankings,here::here("2021/20211026-W44-Ultra Trail Running","ultra_rankings.csv"), row.names = F, na = "")
write.csv(race,here::here("2021/20211026-W44-Ultra Trail Running","race.csv"), row.names = F, na = "")
