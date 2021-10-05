
# packages ----------------------------------------------------------------
library(dplyr)
library(tidyr)
library(glue)
library(gt)
library(gtExtras)

# data --------------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load('2021-09-28')
tuesdata <- tidytuesdayR::tt_load(2021, week = 40)

papers <- tuesdata$papers

# Or read in the data manually

papers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-28/papers.csv')
authors <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-28/authors.csv')
programs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-28/programs.csv')
paper_authors <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-28/paper_authors.csv')
paper_programs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-28/paper_programs.csv')

# data clean --------------------------------------------------------------

data <- left_join(papers, paper_programs) %>% 
  left_join(programs) %>%
  group_by(program, program_desc, year) %>% 
  summarise(n=n_distinct(paper)) %>%
  arrange(year) %>% 
  mutate(decade=paste0(floor(year/10)*10,"s"),
         program=glue::glue("{program_desc} ({program})")) %>% 
  group_by(program) %>% mutate(total=sum(n)) %>% 
  mutate(spark=list(n)) %>% 
  drop_na(program_desc)

data_year <- data %>%
  group_by(program, decade) %>% tally(n, name = "all") %>%
  ungroup() %>%
  pivot_wider(names_from = decade, values_from=all) %>%
  mutate_if(is.numeric, list(~replace_na(., 0)))


# plot --------------------------------------------------------------------
# 20210928-W40-NBER Papers

table <- inner_join(data, data_year, by="program") %>%
  select(Program=program, Total=total, "1980s","1990s","2000s","2010s",Trend=spark) %>%
  distinct() %>% arrange(desc(Total)) %>% ungroup() %>% 
  gt() %>%
  gt_theme_espn() %>%
  cols_align(Program, align="left") %>%
  gtExtras::gt_sparkline(Trend) %>%
  tab_options(table.font.size = 12.5,
              heading.subtitle.font.size = 14) %>%
  gt_color_box(`1980s`, domain=0:786) %>%
  gt_color_box(`1990s`, domain=0:797) %>%
  gt_color_box(`2000s`, domain=0:1647) %>%
  gt_color_box(`2010s`, domain=200:2424) %>%
  tab_header(title="NBER Economic Papers", subtitle="Papers by program and decade") %>%
  tab_source_note(source_note="#TidyTuesday|@CPXOPZ") 

gtsave(table, here::here("2021/20210928-W40-NBER Papers", "20210928-W40-NBER_Papers.png"))
