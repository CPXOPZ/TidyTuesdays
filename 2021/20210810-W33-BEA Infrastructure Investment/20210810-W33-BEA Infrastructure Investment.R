
# import ------------------------------------------------------------------

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2021-08-10')
tuesdata <- tidytuesdayR::tt_load(2021, week = 33)

investment <- tuesdata$investment

# Or read in the data manually

investment <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-10/investment.csv')
chain_investment <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-10/chain_investment.csv')
ipd <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-08-10/ipd.csv')


# out ---------------------------------------------------------------------

folder_name <- "20210810-W33-BEA Infrastructure Investment"
data_name <- names(tuesdata)

for (i in seq_along(data_name)) {
  write.csv(tuesdata[[i]],here::here(paste0("2021/", folder_name),paste0(data_name[i],".csv")), row.names = F, na = "")
}


