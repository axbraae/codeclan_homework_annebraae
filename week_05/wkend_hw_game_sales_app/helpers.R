#load libraries
library(tidyverse)
library(shiny)
library(shinythemes)

#load data
#convert user scores to critic score scale, combine critic and user scores
game_sales <- CodeClanData::game_sales %>% 
  mutate(user_score = user_score*10) %>% 
  pivot_longer(cols = ends_with("_score"),
               names_to = "scored_by",
               values_to = "score"
               ) %>% 
  mutate(scored_by = str_remove(scored_by, "_score"))