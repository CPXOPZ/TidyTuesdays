
# packages ----------------------------------------------------------------
library(dplyr)
library(ggplot2)

# import ------------------------------------------------------------------
# tuesdata <- tidytuesdayR::tt_load('2021-05-25')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 22)
# 
# records <- tuesdata$records

# Or read in the data manually

records <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/records.csv')
drivers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-25/drivers.csv')

# data pre ----------------------------------------------------------------
records |> count(track)
records |> count(type)
records |> count(shortcut)

plot_Data <- records %>% 
  mutate(cut_type = case_when(
    type == "Single Lap" & shortcut == "Yes" ~ "Single Lap with shortcut",
    type == "Single Lap" & shortcut == "No" ~ "Single Lap without shortcut",
    type == "Three Lap" & shortcut == "Yes" ~ "Three Lap with shortcut",
    type == "Three Lap" & shortcut == "No" ~ "Three Lap without shortcut",
  ))

plot_Data |> count(cut_type)

# plot --------------------------------------------------------------------
ggplot(plot_Data, aes(date, time, color = cut_type))+
  geom_line(alpha = 0.5, size = 1.1)+
  geom_point(size = 0.5, alpha = 0.5)+
  scale_color_brewer(palette = "Set1", guide = guide_legend(
    override.aes = list(alpha = 1,
                        size = 1.5)))+
  facet_wrap(~track, scales = "free_y")+
  labs(title = "Mario Kart 64 World Records",
       caption = "#TidyTuesday|@CPXOPZ",
       x = "Year",
       y = "Time / S",
       color = NULL)+
  theme_minimal()+
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(10,5,10,5)))

# final plot --------------------------------------------------------------
# 20210525-W22-Mario Kart World Records

dev.copy(png,here::here("2021/20210525-W22-Mario Kart World Records", "20210525-W22-Mario_Kart_World_Records.png"),
         width = 25, height = 15, res = 200,units = "cm",
         type = "cairo-png")
dev.off()

