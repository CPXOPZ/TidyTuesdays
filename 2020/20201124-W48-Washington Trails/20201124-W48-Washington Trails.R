library(dplyr)
library(ggplot2)
library(ggsci)
library(patchwork)

# import data -------------------------------------------------------------

hike_data <- readr::read_rds(url('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-24/hike_data.rds'))

hike <- hike_data

skimr::skim(hike)

# length, gain, highpoint, rating  number
# name, location, feature, description characters

# feature may be interesting.

# clean data --------------------------------------------------------------

# to numbers
hike <- hike %>%
  mutate(length = readr::parse_number(length),
         gain = as.numeric(gain),
         highpoint = as.numeric(highpoint),
         rating = as.numeric(rating))

# character ---------------------------------------------------------------

hike <- hike %>% 
  mutate(location = gsub( "\\-.*","", location),
         location = gsub( "\\s+$","", location))

# plot --------------------------------------------------------------------

d1 <- ggplot(hike)+
  geom_density(aes(length), alpha = 0.7, fill = pal_d3("category10")(10)[1])+
  theme_bw()+
  labs(y= "",
       x= "Length",
       title = "Density Plot")

d2 <- ggplot(hike)+
  geom_density(aes(gain), alpha = 0.7, fill = pal_d3("category10")(10)[2])+
  theme_bw()+
  labs(y= "",
       x= "Gain")

d3 <- ggplot(hike)+
  geom_density(aes(highpoint), alpha = 0.7, fill = pal_d3("category10")(10)[3])+
  theme_bw()+
  labs(y= "",
       x= "Highpoing")

d4 <- ggplot(hike)+
  geom_density(aes(rating), alpha = 0.7, fill = pal_d3("category10")(10)[4])+
  theme_bw()+
  labs(y= "",
       x= "Rating")

lp <-hike %>% 
  group_by(location) %>% 
  mutate(count=n()) %>% 
  ggplot()+
  geom_bar(aes(forcats::fct_reorder(location, count), fill = location), show.legend = F)+
  coord_flip()+
  theme_bw()+
  scale_fill_d3(palette = "category20")+
  labs(x = "",
       y = "",
       title = "Location of Trail",
       caption = "@CPXOPZ")+
  theme(axis.title.x = element_blank())

patch <- d1/d2/d3/d4|lp

patch + plot_annotation(title = "Basic distribtution of Washington Hiking",
                        theme = theme(plot.title = element_text( hjust = "0.5",
                                                                 face = "bold",
                                                                 size = 20)))
ggsave(here::here("2020/20201124-W48-Washington Trails","20201124-W48-Washington Trails.png"),
       width = 25,
       height = 15,
       units = "cm",
       dpi = 300,
       type = "cairo-png")
