library(tidyverse)
library(here)

log <- read_csv(
  here("data/Sr_water_sample_log.csv"), 
  col_types = cols(
    date = col_date(format = "%m/%d/%Y"),
  )) 

sr_data <- readxl::read_xlsx(
  here("data/Sr_Waters_RachelJohnson_May_2025.xlsx"), 
  sheet = "Samples", 
  range = "A3:AE35"
  ) |> 
  janitor::clean_names() |> 
  select(location = sample_id, sr_87 = x87_86)

sr_data

# Join the log with the Sr data
sr_data <- log |> 
  left_join(sr_data, by = "location") 

sr_data |> 
  filter(sr_87 < 0.715) |>
  ggplot(aes(x = stream, y = sr_87)) + 
  # geom_boxplot() + 
  geom_point() + 
  coord_flip()
