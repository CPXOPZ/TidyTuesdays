library(tidyverse)
library(ggsci)
library(cowplot)
library(here)
# import data -------------------------------------------------------------

mobile <-
  readr::read_csv(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-10/mobile.csv'
  )
landline <-
  readr::read_csv(
    'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-11-10/landline.csv'
  )

skimr::skim(mobile)
skimr::skim(landline)

# 两数据集格式相同，只是对象差异
# year 时间，纵向展示
# GDP-$，订阅数（使用人数？）主要分析对象

# plot --------------------------------------------------------------------

p1 <- mobile %>%
  group_by(continent, year) %>%
  summarise(subs = sum(mobile_subs, na.rm = T)) %>%
  ggplot(aes(year, subs, color = continent)) +
  geom_line(size = 1.1)+
  scale_color_manual(values = pal_jama("default")(5))+
  scale_x_continuous(limits = c(1990, 2017),breaks = c(seq(1990, 2017,5), 2017))+
  labs(y = "subscriptions (per 100 people)",
       x = "",
       title = "Mobile subscriptions by year per continent")+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-5,-5,-5,-5))

p2 <- landline %>%
  group_by(continent, year) %>%
  summarise(subs = sum(landline_subs, na.rm = T)) %>%
  ggplot(aes(year, subs, color = continent)) +
  scale_color_manual(values = pal_jama("default")(5))+
  scale_x_continuous(limits = c(1990, 2017),breaks = c(seq(1990, 2017,5), 2017))+
  geom_line(size = 1.1) +
  labs(y = "subscriptions (per 100 people)",
       x = "",
       title = "Landline subscriptions by year per continent",
       caption = "@ CPXOPZ")+
  theme_bw()+
  theme(axis.title.x = element_blank(),
        legend.position = "none")


plot_grid(p1, p2, ncol = 1)

ggsave(here("2020/20201110-W46-Historical Phones","20201110-W46-Historical Phones.tiff"),
       width = 16, height = 16, units = "cm", dpi = 300, compression="lzw")
