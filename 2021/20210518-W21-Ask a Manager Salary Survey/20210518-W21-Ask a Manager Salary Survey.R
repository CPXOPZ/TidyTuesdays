
# packages ----------------------------------------------------------------
library(dplyr)
library(stringr)
library(forcats)
library(readr)
library(ggplot2)
library(ggridges)
library(patchwork)

# import ------------------------------------------------------------------

# tuesdata <- tidytuesdayR::tt_load('2021-05-18')
# tuesdata <- tidytuesdayR::tt_load(2021, week = 21)
# 
# survey <- tuesdata$survey

# Or read in the data manually

survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-18/survey.csv')

# data prepare ------------------------------------------------------------
plotdata <- survey %>% 
  filter(currency == "USD") %>% 
  mutate(professional_experience = str_replace(overall_years_of_professional_experience, " - ", "-"),
         experience_in_field = str_replace(years_of_experience_in_field, " - ", "-"),
         professional_experience = fct_reorder(professional_experience, parse_number(professional_experience)),
         experience_in_field = fct_reorder(experience_in_field, parse_number(experience_in_field)),
         education_level = fct_relevel(highest_level_of_education_completed,
                                       c("High School", "Some college", "College degree", "Professional degree (MD, JD, etc.)", "Master's degree", "PhD")),
         education_level = fct_recode(education_level, "Professional degree" = "Professional degree (MD, JD, etc.)"))
  
  

  

# Highest level of education completed
# Overall years of professional experience (bracketed)
# Years of experience in field (bracketed)

# plot --------------------------------------------------------------------
theme_set(theme_ridges())

whole <- plotdata %>% 
  ggplot(aes(annual_salary, 10))+
  geom_density_ridges()+
  scale_x_continuous(limits = c(0, 400000), labels = scales::dollar_format())+
  labs(y = NULL,x = NULL,
       title = "Overall condition")+
  theme(axis.text.y = element_blank())
  

professional_experience <- plotdata %>% 
  ggplot(aes(annual_salary, professional_experience))+
  geom_density_ridges()+
  scale_x_continuous(limits = c(0, 400000), labels = scales::dollar_format())+
  labs(x = NULL, y = NULL,
       title = "Overall years of professional experience")

experience_in_field <- plotdata %>% 
  ggplot(aes(annual_salary, experience_in_field))+
  geom_density_ridges()+
  scale_x_continuous(limits = c(0, 400000), labels = scales::dollar_format())+
  labs(x = NULL, y = NULL,
       title = "Years of experience in field")

education <- plotdata %>% 
  ggplot(aes(annual_salary, education_level))+
  geom_density_ridges()+
  scale_x_continuous(limits = c(0, 400000), labels = scales::dollar_format())+
  labs(x = NULL, y = NULL,
       title = "Highest level of education completed")


# final plot --------------------------------------------------------------

# 20210518-W21-Ask a Manager Salary Survey
# https://github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-05-18


whole / professional_experience / experience_in_field / education +
  plot_layout(heights = c(0.3, 1,1,1))+
  plot_annotation(title = "Salary overview by experience and education",
                  caption = "#TidyTuesday | @CPXOPZ",
                  theme = theme(plot.title = element_text(size = 23, hjust = 0.5,
                                                          margin = margin(15,5,10,15))))

ggsave(here::here("2021/20210518-W21-Ask a Manager Salary Survey", "20210518-W21-Ask_a_Manager_Salary_Survey.png"),
       height = 18, width = 8,
       units = "in", dpi = 300,
       type = "cairo")

