
# packages ----------------------------------------------------------------
library(dplyr)
library(gt)
library(gtExtras)

# data import -------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-06-22')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 26)
# 
# parks <- tuesdata$parks
# 
# # Or read in the data manually

parks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-22/parks.csv')


# data prepare ------------------------------------------------------------
skimr::skim(parks)

plot_data <- parks %>% 
  filter(year == 2020) %>% 
  select(rank, city, ends_with("points"), total_pct)
  

name <- c("Size", "Density", "Access", "Prices", "Basketball", "Dogs", "Playgrounds", "Recreation", "Restrooms", "Swimming", "Amenities", "Total")
names(name) <- colnames(parks) %>% 
  stringr::str_subset("_points")
  

# plot --------------------------------------------------------------------

final_table <- plot_data %>% 
  gt() %>% 
  fmt_number(ends_with("points"), decimals = 1) %>% 
  fmt_percent(total_pct, decimals = 1, scale_values = FALSE) %>% 
  data_color(ends_with("points"), 
             colors = scales::col_numeric(palette = paletteer::paletteer_d(palette = "ggsci::teal_material") %>% as.character(), domain = c(0, 100)),
             alpha = 0.7) %>% 
  data_color(total_points, 
             colors = scales::col_numeric(palette = "viridis", domain = c(90, 350),reverse = T),
             alpha = 0.7) %>% 
  cols_align("center", columns = ends_with("_points")) %>%
  cols_label(total_pct = "Total percent of max",
             city = "City",
             rank = "Rank") %>% 
  cols_label(.list = purrr::map(name, html)) %>% 
  tab_header(title = "Park Access in U.S. Cities") %>% 
  tab_spanner(label = "Each evaluation standard and Total points", columns = ends_with("_points")) %>% 
  tab_source_note(source_note="#TidyTuesday | @CPXOPZ") %>% 
  gt_theme_nytimes()

gtsave(final_table, here::here("2021/20210622-W26-Public Park Access","20210622-W26-Public_Park_Access.png"))
  
