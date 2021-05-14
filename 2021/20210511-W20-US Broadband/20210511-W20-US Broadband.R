
# packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(ggridges)

# data import -------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-05-11')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 20)
# 
# broadband <- tuesdata$broadband

# Or read in the data manually

broadband <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-11/broadband.csv')
broadband_zip <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-11/broadband_zip.csv')

# data prepare ------------------------------------------------------------

plot_data <- broadband %>% 
  filter(!`BROADBAND AVAILABILITY PER FCC` == "-",
         !`BROADBAND USAGE` == "-",
         !ST == "DC") %>% 
  mutate(avail = readr::parse_number(`BROADBAND AVAILABILITY PER FCC`),
         usage = readr::parse_number(`BROADBAND USAGE`))

# plot --------------------------------------------------------------------

plot_data %>% 
  ggplot(aes(usage, reorder(ST, usage), fill = ..x..))+
  geom_density_ridges_gradient(scale = 1.5, rel_min_height = 0.05,
                               jittered_points = TRUE, point_color="white",
                               point_size = 0.01, point_alpha = 0.3)+
  scale_fill_viridis_c(option = "D") +
  scale_y_discrete(expand = expansion(mult = c(0.01, 0.02))) +
  scale_x_continuous(labels = scales::percent_format(),
                     sec.axis = dup_axis(name = NULL))+
  labs(title = "Internet Broadband Usage in US",
       x = "Broadband usage",
       y = NULL,
       caption = "#TidyTuesday | @CPXOPZ")+
  theme_minimal()+
  theme(legend.position = "none",
        plot.title = element_text(size = 15, hjust = 0.5, margin = margin(8,0,10,0)))


# final plot --------------------------------------------------------------
## 20210511-W20-US Broadband
## https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-05-11

ggsave(here::here("2021/20210511-W20-US Broadband", "2021-05-11_US_Broadband.png"),
       height = 24,
       width = 12,
       units = "cm",
       dpi = 300,
       type = "cairo")

