#load libraries
library(tidyverse)

#load data
game_sales <- CodeClanData::game_sales

#convert user scores to critic score scale, combine critic and user scores
game_sales_longer <- game_sales %>% 
  mutate(user_score = user_score*10) %>% 
  pivot_longer(cols = ends_with("_score"),
               names_to = "scored_by",
               values_to = "score"
               ) %>% 
  mutate(scored_by = str_remove(scored_by, "_score"))



# Plot examples -----------------------------------------------------------


# critic_user_scores_density_plot -----------------------------------------

game_sales_longer %>% 
  filter(genre == "Sports") %>% 
  #filter(developer == "Nintendo") %>% 
  #filter(platform == "Wii") %>% 
  #filter(rating == "E") %>% 
ggplot() +
  aes(x = score, fill = scored_by) +
  geom_density(alpha = 0.6) +
  theme_minimal()


# sales_year_genre_plot ---------------------------------------------------------

game_sales_longer %>% 
  filter(genre == "Sports") %>% 
  #filter(developer == "Nintendo") %>% 
  #filter(platform == "Wii") %>% 
  #filter(rating == "E") %>% 
  ggplot() +
  aes(x = year_of_release, y = sales) +
  geom_col() +
  theme_minimal()


# game_genre_developer_plot ---------------------------------------------------------

game_sales_longer %>% 
  filter(genre == "Sports") %>% 
  #filter(developer == "Nintendo") %>% 
  #filter(platform == "Wii") %>% 
  #filter(rating == "E") %>% 
  ggplot() +
  aes(x = genre, fill = developer) +
  geom_bar() +
  theme_minimal()

# name_table --------------------------------------------------------------

game_sales %>% 
  filter(genre == "Sports") %>% 
  filter(developer == "Nintendo") %>% 
  filter(platform == "Wii") %>% 
  filter(rating == "E") %>% 
  select(name, year_of_release, publisher, developer)
