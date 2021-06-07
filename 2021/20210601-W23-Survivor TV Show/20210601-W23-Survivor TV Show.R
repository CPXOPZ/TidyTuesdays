
# packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# data import -------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-06-01')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 23)
# 
# summary <- tuesdata$summary

# Or read in the data manually

summary <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-01/summary.csv')


# data viz ------------------------------------------------------------

# color <span style='color:#FF7F7F'>viewers at premier</span>

text <- "The red dots are the viewers at premier for each other episode, green dots are viewers at finale, blue dots are viewers for reunion; while the black line represents the average of the season and grey line represents the viewer ranking."

summary %>% 
  ggplot(aes(season, viewers_mean))+
  geom_point(aes(y = viewers_premier), alpha = 0.5, color = "red")+
  geom_point(aes(y = viewers_finale), alpha = 0.5, color = "green")+
  geom_point(aes(y = viewers_reunion), alpha = 0.5, color = "blue")+
  geom_line(alpha = 0.7)+
  geom_step(aes(season, rank), color = "grey50")+
  scale_x_continuous(limits = c(1,40), breaks = seq(1, 40, 2))+
  scale_y_continuous(labels = scales::unit_format(unit = "M"),
                     sec.axis = sec_axis(~., name = "Viewer ranking"))+
  labs(title = "Survivor TV Show data",
       subtitle = stringr::str_wrap(text, 70),
       x = "Season number",
       y = "# of viewers",
       caption = "#TidyTuesday | @CPXOPZ")+
  theme_minimal()+
  theme(panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank())


# final plot --------------------------------------------------------------
# 20210601-W23-Survivor_TV_Show.png

ggsave(here::here("2021/20210601-W23-Survivor TV Show", "20210601-W23-Survivor_TV_Show.png"),
       width = 15, height = 10, units = "cm",
       dpi = 250, type = "cairo-png")
 
