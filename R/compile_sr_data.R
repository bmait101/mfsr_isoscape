library(tidyverse)
library(here)


sites <- read_csv(
  here("data/master_site_lookup.csv"), 
  col_types = cols(
    Position = col_character()
    )
  )

sample_log <- read_csv(
  here("data/sample-log-water.csv"), 
  col_types = cols(
    collection_date = col_date(format = "%m/%d/%Y"),
  )) 

sr_dat_24 <- readxl::read_xlsx(
  here("data/ICPMS/Sr_Waters_RachelJohnson_May_2025.xlsx"), 
  sheet = "Samples", 
  range = "A3:AE35"
  ) |> 
  janitor::clean_names() |> 
  select(sample_id, sr_87 = x87_86)

sr_dat_25 <- readxl::read_xlsx(
  here("data/ICPMS/Sr_87_86_Bryan_Maitland_USForrestServ_2026_June_30.xlsx"), 
  sheet = "Samples", 
  range = "A3:AE22"
) |> 
  janitor::clean_names() |> 
  select(sample_id, sr_87 = x87_86)

sr_dat <- bind_rows(sr_dat_24, sr_dat_25)

# Join the log with the Sr data

dat <- sample_log |> 
  left_join(sites |> select(site_id, site_name, waterbody_name, lat_dd, long_dd), by = "site_id") |> 
  left_join(sr_dat, by = "sample_id")






dat |> 
  # filter(sr_87 < 0.715) |>
  ggplot(aes(x = reorder(waterbody_name, sr_87), y = sr_87)) + 
  geom_point(size = 3) + 
  coord_flip() + 
  theme_bw(base_size = 20) + 
  labs(y = expression(''^87*'Sr/'^86*'Sr'), x = "")
