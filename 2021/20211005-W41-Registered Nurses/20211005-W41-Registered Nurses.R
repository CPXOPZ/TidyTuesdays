
# packages ----------------------------------------------------------------

library(dplyr)
library(ggplot2)
library(ggrepel)

# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-10-05')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 41)

# nurses <- tuesdata$nurses

# Or read in the data manually

nurses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-05/nurses.csv')


# data prepare ------------------------------------------------------------

skimr::skim(nurses)

plotdata <- nurses %>% 
  janitor::clean_names() %>% 
  group_by(state) %>% 
  arrange(year) %>% 
  mutate(label = ifelse(year == max(year), state, "")) %>% 
  ungroup()

# plot --------------------------------------------------------------------

plot <- plotdata %>% 
  ggplot(aes(total_employed_rn, annual_salary_median, group = state))+
  geom_path(aes(color=year, size=year), alpha=0.6, show.legend = F)+
  geom_point(data=filter(plotdata, label != ""), alpha = 0.6)+
  geom_text_repel(aes(label = label), size = 3, max.overlaps = 10)+
  scale_size_continuous(range = c(0.3,0.9))+
  scale_x_continuous(labels = scales::comma_format())+
  scale_y_continuous(labels = scales::label_dollar())+
  labs(title = "Annual wages and number of employed\nregistered nurses by state from 1998 to 2020",
       x = "number of employed registered nurses",
       y = "Annual wages",
       caption = "#TidyTuesday | @CPXOPZ")+
  theme_light()+
  theme(plot.title = element_text(size = 20, face = "bold"))


ggsave(here::here("2021/20211005-W41-Registered Nurses","20211005-W41-Registered_Nurses.png"),
       width = 18, height = 18,units = "cm" , dpi = 320)

