library(dplyr)

women <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-12-08/women.csv')

skimr::skim(women)

# 包含头像，可是试用ggimage
# 5 category，country可用地图——国家、数量【注意worldwide】

