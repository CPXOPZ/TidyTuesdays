
# packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# data import -------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-07-13')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 29)
# 
# scoobydoo <- tuesdata$scoobydoo

# Or read in the data manually

scoobydoo <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-13/scoobydoo.csv')


# data pre ----------------------------------------------------------------
caughted <- scoobydoo %>% 
  select(index, caught_fred:caught_scooby) %>% 
  tidyr::pivot_longer(-index, names_to = "caught", names_prefix = "caught_", values_to = "y") %>% 
  filter(y=="TRUE") %>% 
  mutate(caught = stringr::str_to_sentence(caught)) %>% 
  group_by(caught) %>% 
  summarise(n = n()) %>% 
  mutate(caught = as.factor(caught),
         caught = forcats::fct_reorder(caught, n)) %>% 
  mutate(per = n/603,
         per_label = scales::percent(per))
  

# plot --------------------------------------------------------------------
pal <- c(
  "gray85",
  rep("gray70", length(caughted$caught) - 4), 
  "coral2", "mediumpurple1", "goldenrod1"
)

caughted %>% 
  ggplot(aes(n, caught, fill = caught))+
  geom_col()+
  scale_fill_manual(values = pal, guide = "none") +
  geom_label(aes(label = per_label), hjust = 1, nudge_x = -.95, color = "grey50",
            size = 4, fontface = "bold", alpha = .8, 
            fill = "white", label.size = 0)+
  scale_x_continuous(expand = c(.01, .01)) +
  theme_void()+
  labs(title = "Scooby Doo Monster Capture Rank & proportion",
       caption = "#Tidytueday | @CPXOPZ",
       x = NULL,
       y = NULL)+
  theme(plot.title = element_text(size = 15, face = "bold", margin = margin(rep(10,5)), hjust = 0.5),
        plot.title.position = "plot",
        axis.text.y = element_text(size = 14, hjust = 1),
        plot.margin = margin(rep(15, 4)))

ggsave(here::here("2021/20210713-W29-Scooby Doo", "20210713-W29-Scooby_Doo.png"),
       width = 15, height = 8, units = "cm",
       dpi = 250, bg = "white")
