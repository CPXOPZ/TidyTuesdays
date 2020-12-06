library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(ggsci)
library(patchwork)
library(ggridges)

# data --------------------------------------------------------------------

shelters <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-12-01/shelters.csv')

skimr::skim(shelters)
# 好多字符型数据
# occupancy capacity 为整数
# 1 province  4 city 5 sector  33 organization_name  65 shelter_name & address
# 114 shelter_name  155program_name

## 大失误，日期数据未重视，本数据是随时期变化的纵向数据，教训教训！！！

# city with only one shelter sector

tron <- shelters %>% 
  filter(shelter_city %in% c("Toronto"))

only_youth <- shelters %>% 
  filter(shelter_city %in% c("Etobicoke", "North York")) %>% 
  # group_by(shelter_city) %>% 
  mutate(status = case_when(occupancy < capacity ~ "Surplus",
                   TRUE ~ "Full"))

  summarise(occupancy_sum = sum(occupancy),
            capacity_sum = sum(capacity, na.rm = T))


shelters %>% 
  filter(!(shelter_city %in% c("Etobicoke", "North York"))) %>% 
  group_by(shelter_city, sector) %>% 
  summarise(occupancy_sum = sum(occupancy),
            capacity_sum = sum(capacity, na.rm = T))

# plot --------------------------------------------------------------------

theme_set(theme_ft_rc())

p1 <- only_youth %>% 
  ggplot()+
  geom_bar(aes(shelter_city, fill = status))+
  scale_fill_jama()+
  theme_ft_rc()+
  labs(title = "City Only Youth")+
  theme(legend.position = c(0.45, -0.175),
        legend.direction = "horizontal",
        legend.title = element_text(face = "bold"),
        axis.title.x = element_blank())


# others two city 
p2 <- shelters %>% 
  filter(!(shelter_city %in% c("Etobicoke", "North York"))) %>% 
  group_by(shelter_city) %>% 
  ggplot()+
  geom_bar(aes(shelter_city, fill = sector))+
  scale_fill_npg()+
  labs(title = "Coty Mixed")+
  theme_ft_rc()+
  theme(legend.position = c(0.05, -0.175),
        legend.direction = "horizontal",
        legend.title = element_text(face = "bold"),
        axis.title.x = element_blank())

p3 <- tron %>% 
  mutate(status = case_when(occupancy < capacity ~ "Surplus",
                            TRUE ~ "Full")) %>% 
  ggplot()+
  geom_bar(aes(sector, color = sector, fill = status), position = "dodge")+
  scale_fill_jama()+
  scale_color_npg()+
  labs(title = "Toronto")+
  theme(legend.position = "none",
        plot.margin=unit(c(0.5, 0, 0, 0), 'cm'))

p4 <- tron %>% 
  ggplot(aes(capacity))+
  geom_density()+
  theme(plot.margin=unit(c(0, 0, 0, 0), 'cm'))

(p1+p2)/p3/p4+
  plot_annotation(title = "Toronto Shelters",
                  caption = "@CPXOPZ",
                  theme = theme(plot.title = element_text( hjust = "0.5",
                                                           face = "bold",
                                                           size = 25)))
  
ggsave(here::here("2020/20201201-W49-Toronto Shelters","20201201-W49-Toronto_Shelters.png"),
       width = 25,
       height = 30,
       units = "cm",
       dpi = "retina",
       type = ragg::agg_png())
