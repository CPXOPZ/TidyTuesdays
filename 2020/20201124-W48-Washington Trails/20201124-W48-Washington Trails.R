library(dplyr)

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
# stringr character
hike %>% 
  mutate(location = str_extract(location, "[a-z]+"))
