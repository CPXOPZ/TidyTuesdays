
# data import -------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-11-23')
tuesdata <- tidytuesdayR::tt_load(2021, week = 48)

directors <- tuesdata$directors

# Or read in the data manually

directors <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/directors.csv')
episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/episodes.csv')
writers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/writers.csv')
imdb <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/imdb.csv')


# export ------------------------------------------------------------------

write.csv(directors,here::here("2021/20211123-W48-DrWho","directors.csv"), row.names = F, na = "")
write.csv(episodes,here::here("2021/20211123-W48-DrWho","episodes.csv"), row.names = F, na = "")
write.csv(writers,here::here("2021/20211123-W48-DrWho","writers.csv"), row.names = F, na = "")
write.csv(imdb,here::here("2021/20211123-W48-DrWho","imdbs.csv"), row.names = F, na = "")

haven::write_xpt(directors,here::here("2021/20211123-W48-DrWho","directors.xpt"),version = 5)
haven::write_xpt(episodes,here::here("2021/20211123-W48-DrWho","episodes.xpt"),version = 5)
haven::write_xpt(writers,here::here("2021/20211123-W48-DrWho","writers.xpt"),version = 5)
haven::write_xpt(imdb,here::here("2021/20211123-W48-DrWho","imdbs.xpt"),version = 5)

haven::write_sas(directors, here::here("2021/20211123-W48-DrWho","directors.sas7bdat"))
haven::write_sas(episodes, here::here("2021/20211123-W48-DrWho","episodes.sas7bdat"))
