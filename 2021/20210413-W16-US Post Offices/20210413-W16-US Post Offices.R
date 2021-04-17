
# package -----------------------------------------------------------------

library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(ggthemes)
library(gganimate)


# import data -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-04-13')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 16)
# 
# post_offices <- tuesdata$post_offices

# Or read in the data manually

post_offices <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-13/post_offices.csv')

# data prepare ------------------------------------------------------------

skimr::skim(post_offices)

by_year <- post_offices %>% 
  select(name, state, established, discontinued, longitude, latitude) %>% 
  replace_na(list(discontinued = 2003)) %>% 
  filter(established >= 1750, 
         discontinued <= 2021,
         is.na(discontinued)|discontinued >= established) %>% 
  mutate(year = map2(established, discontinued, seq)) %>% 
  unnest(year)

# plot --------------------------------------------------------------------

post_offices %>% 
  filter(!longitude>100) %>% 
  ggplot(aes(longitude,latitude))+
  borders("world", c("USA"), xlim=c(-180,-65), ylim=c(19,71),colour = "black")+
  geom_point(size = 0.05, alpha = 0.3, color = "grey50")+
  annotate("text", x = -100, y = 63, label = "US Post Offices\nOver Time",
           size = 10)+
  annotate("text", x = -155, y = 37, label = "Year", size = 9)+
  theme_map()+
  coord_map()

anim_graph <- by_year %>% 
  filter(!longitude>100) %>% 
  ggplot(aes(longitude,latitude,label = year))+
  borders("world", c("USA"), xlim=c(-180,-65), ylim=c(19,71),colour = "black")+
  geom_point(size = 0.05, alpha = 0.5)+
  annotate("text", x = -100, y = 63, label = "US Post Offices\nOver Time",
           size = 12)+
  geom_text(aes(-155,37), size = 11)+
  theme_map()+
  coord_map()+
  transition_manual(year)


animate(anim_graph, height = 640, width = 800, nframes = 600, fps = 8)
anim_save(here::here("2021/20210413-W16-US Post Offices", "20210413-W16-US_Post_Offices.gif"))

# final plot save ---------------------------------------------------------

# ggsave(here::here("2021/20210413-W16-US Post Offices", "20210413-W16-US_Post_Offices.png"))
