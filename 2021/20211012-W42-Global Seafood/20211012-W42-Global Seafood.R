
# packages ----------------------------------------------------------------
library(dplyr)

# data --------------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-10-12')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 42)
# 
# seafood_consumption <- tuesdata$seafood_consumption

# Or read in the data manually

farmed <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/aquaculture-farmed-fish-production.csv')
captured_vs_farmed <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/capture-fisheries-vs-aquaculture.csv')
captured <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/capture-fishery-production.csv')
consumption <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/fish-and-seafood-consumption-per-capita.csv')
stock <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/fish-stocks-within-sustainable-levels.csv')
fishery <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/global-fishery-catch-by-sector.csv')
production <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-10-12/seafood-and-fish-production-thousand-tonnes.csv')


# data prepare ------------------------------------------------------------

production %>% 
  filter(!is.na(Code), Entity!="World") %>% 
  tidyr::pivot_longer(-c("Entity","Code","Year"),names_to = "cat") %>% 
  group_by(Entity, Code) %>% 
  summarise(total=sum(value, na.rm = T)) %>% 
  ungroup() %>% 
  slice_max(total, n=4)


folder_name <- "20211012-W42-Global Seafood"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}

