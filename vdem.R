library(tidyverse)

vdem <- as_tibble(vdem)
vdem

vdem %>%
  filter(country_text_id == "HUN") %>%
  ggplot(
       mapping = aes(x = year, y = v2x_polyarchy)) +
       geom_point() +
       geom_line()
