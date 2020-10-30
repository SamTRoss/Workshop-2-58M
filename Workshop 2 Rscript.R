read.csv("Human-development-index.csv", header = T)
data <- read.csv("Human-development-index.csv", header = T)
data

install.packages("janitor")
library("janitor")



data <- read.csv("Human-development-index.csv", header = T) %>%
  janitor :: clean_names()



library(tidyverse)

data <- data %>%
  pivot_longer(names_to = "year",
               values_to = "index",
               cols = -c(hdi_rank_2018, country))
data

data <- data %>%
  mutate(year =  str_replace(year, "x", "") %>% as.numeric())
data

data_no_na <- data %>% 
  filter(!is.na(index))
data_no_na

data_summary <- data_no_na %>% 
  group_by(country) %>%
  summarise(mean_index = mean(index))
data_summary

## Add summary columns 
data_summary <- data_no_na %>% 
  group_by(country) %>%
  summarise(mean_index = mean(index),
            n = length(index))
data_summary

## Add columns for standard deviation and standard error
data_summary <- data_no_na %>% 
  group_by(country) %>%
  summarise(mean_index = mean(index),
            n = length(index),
            sd_index = sd(index),
            se_index = sd_index/sqrt(n))
data_summary

##Filter the summary to get just the ten lowest mean countries
data_summary_low <- data_summary %>%
  filter(rank(mean_index) < 11)
data_summary_low

## Plotting these low ones
data_summary_low %>%
  ggplot()+
  geom_point(aes(x = country,
                 y = mean_index))+
  geom_errorbar(aes(x = country,
                    ymin = mean_index - se_index,
                    ymax = mean_index + se_index))+
  scale_y_continuous(limits = c(0, 0.5),
                     expand = c(0,0),
                     name = "HDI") +
  scale_x_discrete(expand = c(0,0),
                   name = "") +
  theme_classic() +
  coord_flip()

## Building a pipeline that takes the dataframe through
## to the plot above without creating any intermediate
data %>%
  filter(!is.na(index)) %>%
  group_by(country) %>%
  summarise(mean_index = mean(index),
            se_index = sd(index)/sqrt(length(index))) %>%
  ggplot()+
  geom_point(aes(x = country,
                 y = mean_index)) +
  geom_errorbar(aes(x = country,
                    ymin = mean_index - se_index,
                    ymax = mean_index + se_index)) +
  scale_y_continuous(limits = c(0, 0.5),
                     expand = c(0, 0),
                     name = "HDI") +
  scale_x_discrete(expand = c(0, 0),
                   name = "") +
  theme_classic() +
  coord_flip()

