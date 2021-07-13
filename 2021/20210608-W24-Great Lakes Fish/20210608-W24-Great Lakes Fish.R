
# packages ----------------------------------------------------------------
library(dplyr)
library(stringr)
library(ggplot2)

# data import -------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-06-08')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 24)
# 
# fishing <- tuesdata$fishing

# Or read in the data manually

fishing <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv')
stocked <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/stocked.csv')

# data pre ----------------------------------------------------------------
skimr::skim(fishing)
skimr::skim(stocked)

# data clean
cleaned <- fishing %>% 
  tidyr::drop_na(values) %>% 
  filter(values > 0) %>% 
  mutate(species = tolower(species), 
         species = case_when(
           str_detect(species, "catfish|bullheads") ~ "channel catfish and bullheads", 
           str_detect(species, "cisco|chub") ~ "cisco and chubs", 
           str_detect(species, "rock bass|crappie") ~ "rock bass and crappie", 
           TRUE ~ species), 
         species = str_replace(species, "amerci", "americ")) %>% 
  mutate(species = str_to_title(species))

# top 10 species by total produciton

top_10 <- cleaned %>% 
  group_by(species) %>% 
  summarise(total = sum(values)) %>% 
  arrange(-total) %>% 
  slice_head(n = 10)

plot_data <- cleaned %>% 
  filter(species %in% top_10$species) %>% 
  group_by(species, year) %>% 
  summarise(total = sum(values)) %>% 
  group_by(species) %>% 
  arrange(species, year) %>% 
  mutate(tol = cumsum(total),
         species = factor(species, levels = top_10$species))

# plot --------------------------------------------------------------------

plot_data %>% 
  ggplot()+
  geom_line(aes(x = year, y = tol, colour = species),
            size = 1, alpha = 0.7)+
  ggsci::scale_color_npg()+
  scale_y_continuous(labels = scales::comma_format(),
                     sec.axis = dup_axis(name = NULL,
                                         breaks = top_10$total[-which(top_10$species=="Blue Pike")],
                                         labels = top_10$species[-which(top_10$species=="Blue Pike")]))+
  scale_x_continuous(expand = c(0.01, 0.01), breaks = seq(1880, 2015, 15))+
  labs(title = "10 fish species with the largest cumulated fish catches",
       caption = "#Tidytuesday|@CPXOPZ",
       x = NULL,
       y = "Overall Production(pounds)")+
  theme_minimal()+
  theme(legend.position = "none",
        plot.caption.position = "plot",
        panel.grid.minor = element_blank(),
        plot.title = element_text(margin = margin(7,5,5,5)))
  

# final -------------------------------------------------------------------

# 20210608-W24-Great Lakes Fish
ggsave(here::here("2021/20210608-W24-Great Lakes Fish", "20210608-W24-Great_Lakes_Fish.png"),
       width = 15, height = 22, units = "cm",
       dpi = 200 )
