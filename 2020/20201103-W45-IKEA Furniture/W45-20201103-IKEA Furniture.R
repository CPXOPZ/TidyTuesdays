library(ggplot2)
library(dplyr)
library(forcats)
library(here)
# data --------------------------------------------------------------------

ikea <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-03/ikea.csv')

skimr::skim(ikea)
ikea_raw <- ikea
# glimpse(ikea)

ikea_raw %>%
  ggplot(aes(fct_reorder(category,price), price))+
  geom_jitter(aes(color = category), alpha = 0.4)+
  geom_boxplot(aes(color = category), alpha = 0.7, outlier.alpha = 0)+
  geom_hline(yintercept = mean(ikea$price), alpha = 0.4)+
  coord_flip()+
  labs(title = "Price by category",
       sbutitle = "",
       x = "",
       y = "Price")+
  theme(panel.grid.major.x = element_blank(),
        # panel.grid.major.y,
        panel.grid.minor.x = element_blank(),
        # panel.grid.minor.y
        legend.position = "none")


ggsave(here("2020/W45-20201103-IKEA Furniture","W45-20201103-IKEA Furniture.tiff"),
       width = 16, height = 12, units = "cm", dpi = 300, compression="lzw")

# 打折情况？计划展现百分比（数量不多）

ikea_discount <- ikea_raw %>% 
  filter(!old_price == "No old price") %>% 
  mutate(discount = price/as.numeric(old_price))

table(ikea_discount$category)
ggplot(ikea_discount)+
  geom_bar(aes(category, ))