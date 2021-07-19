
# packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-06-15')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 25)
# 
# tweets <- tuesdata$tweets

# Or read in the data manually

tweets <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-15/tweets.csv')

# data prepare ------------------------------------------------------------

skimr::skim(tweets)

ggplot(tweets, aes(datetime, like_count))+
  geom_point()
ggplot(tweets, aes(datetime, retweet_count))+
  geom_point()

tweets %>% 
  mutate(day = lubridate::date(datetime)) %>% 
  group_by(day) %>% 
  count() %>% 
  ggplot(aes(day, n))+
  geom_line(color = "#DC143C", size = 1)+
  scale_x_date(breaks = lubridate::ymd(paste0("2021", c("0202", "0216", "0302", "0316", "0330", "0413", "0427", "0511"))),
               labels = scales::date_format(format = "%b %e"),
               limits = lubridate::ymd(paste0("2021", c("0202", "0511"))),
               expand = c(0.04, 0.04))+
  labs(title = "Tweets Over Time",
       subtitle = "#DuBoisChallenge tweets",
       caption = "#Tidytudsday | @CPXOPZ",
       x = NULL,
       y = NULL)+
  theme_minimal()+
  theme(plot.background = element_rect(fill = "#FAF0E6", color = NA),
        panel.grid = element_blank(),
        plot.title = element_text(face = "bold", size = 15),
        plot.caption.position = "plot")

ggsave(here::here("2021/20210615-W25-WEB Du Bois and Juneteenth", "20210615-W25-WEB_Du_Bois_and_Juneteenth.png"),
       width = 15, height = 8, units = "cm",
       dpi = 300)

