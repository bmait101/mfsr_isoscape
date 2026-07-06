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

sr_data2 <- readxl::read_xlsx(
  here("data/Sr_87_86_Bryan_Maitland_USForrestServ_2026_June_30.xlsx"), 
  sheet = "Samples", 
  range = "A4:AE23"
) |> 
  janitor::clean_names() |> 
  select(location = sample_id, sr_87 = x87_86)

sr_data
sr_data2

dat <- bind_rows(sr_data, sr_data2)

# Join the log with the Sr data
sr_data <- log |> 
  left_join(sr_data, by = "location") 

sr_data |> 
  mutate(stream = if_else(stream == "Middle Fork Salmon River", "Middle Fork Mainstem", stream)) |> 
  filter(sr_87 < 0.715) |>
  ggplot(aes(x = reorder(stream, sr_87), y = sr_87)) + 
  geom_point(size = 3) + 
  coord_flip() + 
  theme_bw(base_size = 20) + 
  labs(y = expression(''^87*'Sr/'^86*'Sr'), x = "")


dat |> 
  filter(sr_87 < 0.72) |>
  ggplot(aes(x = reorder(location, sr_87), y = sr_87)) +
  # ggplot(aes(x = location, y = sr_87)) + 
  geom_point(size = 3) + 
  coord_flip() + 
  theme_bw(base_size = 20) + 
  labs(y = expression(''^87*'Sr/'^86*'Sr'), x = "")

