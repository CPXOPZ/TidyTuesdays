library(dplyr)
library(ggplot2)
library(hrbrthemes)

women <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-12-08/women.csv')

skimr::skim(women)

# 包含头像，可是试用ggimage
# 5 category，country可用地图——国家、数量【注意worldwide】

library("sf")
library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

ggplot(data = world) +
  geom_sf()

##
library(stringr)
map <- women %>% 
  filter(country != "Worldwide") %>% 
  count(country, sort =T) %>% 
  mutate(country = case_when(
    country == "UAE" ~ "United Arab Emirates",
    country == "UK" ~ "United Kingdom",
    country == "US" ~ "United States",
    country == "South Korea" ~ "Korea",
    country == "Republic of Ireland" ~ "Ireland",
    country == "Northern Ireland" ~ "United Kingdom",
    country == "DR Congo" ~ "Congo",
    country == "Wales, UK" ~ "United Kingdom",
    country == "Iraq/UK" ~ "United Kingdom",
    str_detect(country, "Exiled") ~ "China",
    TRUE ~ country)) %>% 
  left_join(world, ., by = c("name"="country"), keep = T) %>% 
  filter(!is.na(country))

library(viridis)
ggplot() +
  geom_sf(data = world)+
  geom_sf(data = map, aes(fill = n))+
  scale_fill_viridis_c()+
  theme_void()+
  labs(title = "Women of 2020",
       fill = "Num")
  
women %>% 
  filter(country != "Worldwide") %>% 
  count(category, sort = T) %>% 
  ggplot(aes(forcats::fct_reorder(category, n), n))+
  geom_bar(aes(fill = category, color = category), stat="identity", show.legend = F)+
  coord_flip()+
  labs(x = "Category",
       y = "Number",
       title = "Category distribution")+
  ggsci::scale_fill_jama()+
  ggsci::scale_color_jama()+
  theme_ipsum()

ggdraw

ggsave(here::here("2020/20201208-W50-Women of 2020", "20201208-W50-Women_of_2020.png"),
       width = ,
       height = ,
       units = ,
       dpi = "retina",
       type = ragg::agg_png())

