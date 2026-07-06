# Compile MFSR water Sr data: site lookup + sample log + ICP-MS results.
# Cross-checks the compiled sample counts against the manually maintained
# data/water_sample_summary.xlsx tally and writes results/compiled_sr_data.csv.

library(tidyverse)
library(here)
library(janitor)

# ---- Reference tables ------------------------------------------------------

sites <- read_csv(
  here("data/master_site_lookup.csv"),
  col_types = cols(stream_position = col_character())
)

sample_log <- read_csv(
  here("data/sample_log_water.csv"),
  col_types = cols(collection_date = col_date(format = "%m/%d/%Y"))
)

# ---- Sr (ICP-MS) results ----------------------------------------------------
# Reads every workbook in data/icpms/, so adding next year's batch is just
# dropping a new file in that folder -- no code change needed here.
# Each workbook has a blank row 1, a header row, then data; the header
# location is detected rather than hardcoded since row offsets have differed
# between batches. "87/86" (not "87Sr/86Sr_Corr") is the fully
# interference-corrected ratio and is what we want as sr_87.

read_sr_batch <- function(path) {
  raw <- readxl::read_xlsx(path, sheet = "Samples", col_names = FALSE)
  header_row <- which(raw[[1]] == "Sample ID")
  stopifnot(length(header_row) == 1)

  df <- raw[(header_row + 1):nrow(raw), ]
  names(df) <- as.character(unlist(raw[header_row, ]))

  df |>
    clean_names() |>
    filter(!is.na(sample_id)) |>
    transmute(
      sample_id,
      sr_87 = as.numeric(x87_86),
      sr_87_se = as.numeric(x2se),
      icpms_batch = tools::file_path_sans_ext(basename(path))
    )
}

sr_dat_raw <- list.files(here("data/icpms"), pattern = "\\.xlsx$", full.names = TRUE) |>
  map_dfr(read_sr_batch)

# Some samples were run twice for analytical QC (re-runs, not separate field
# samples) and share a sample_id -- average these down to one row per sample
# so joins downstream don't fan out.
sr_dat <- sr_dat_raw |>
  summarise(
    sr_87 = mean(sr_87),
    sr_87_se = sqrt(sum(sr_87_se^2)) / n(),
    n_analytical_runs = n(),
    icpms_batch = first(icpms_batch),
    .by = sample_id
  )

# ---- Compile -----------------------------------------------------------

dat <- sample_log |>
  left_join(
    sites |> select(site_id, site_name, waterbody_name, stream_code, lat_dd, long_dd),
    by = "site_id"
  ) |>
  left_join(sr_dat, by = "sample_id")

missing_site <- dat |> filter(is.na(waterbody_name))
missing_sr <- dat |> filter(is.na(sr_87))
if (nrow(missing_site) > 0) {
  warning(nrow(missing_site), " sample(s) have a site_id not found in master_site_lookup.csv: ",
          paste(missing_site$sample_id, collapse = ", "))
}
if (nrow(missing_sr) > 0) {
  message(nrow(missing_sr), " sample(s) have no matching ICP-MS result yet: ",
          paste(missing_sr$sample_id, collapse = ", "))
}

# ---- QA: cross-check against the manual water_sample_summary.xlsx tally ----
# Streams appearing only in the summary tally (e.g. this year's new
# tributaries) and not yet in dat are expected -- they just haven't been
# sampled yet. Mismatches on streams present in BOTH tables are the real flag.

stream_name_recode <- c(
  "Salmon River Mainstem" = "Salmon River",
  "MFSR Mainstem" = "Middle Fork Salmon River",
  "Cape Horn Creek" = "Cape Horn",
  "WF Camus Creek" = "WF Camas Creek"
)

summary_tally <- readxl::read_xlsx(here("data/water_sample_summary.xlsx")) |>
  clean_names() |>
  filter(stream_name != "TOTALS") |>
  mutate(stream_name = recode(stream_name, !!!stream_name_recode))

compiled_tally <- dat |>
  mutate(year = format(collection_date, "%Y")) |>
  count(waterbody_name, year, name = "n_compiled") |>
  pivot_wider(names_from = year, values_from = n_compiled, names_prefix = "n_compiled_", values_fill = 0)

qa_compare <- summary_tally |>
  select(stream_name, matches("^n_20")) |>
  rename_with(~ paste0(.x, "_summary"), matches("^n_20")) |>
  left_join(compiled_tally, by = c("stream_name" = "waterbody_name")) |>
  mutate(across(matches("^n_compiled_20"), ~ replace_na(.x, 0)))

# Note: "Beaver Creek" is ambiguous in both tables (Marsh Ck's BVR vs Big Ck's
# BVB -- see data/site_id_convention.md); this QA check will double-count or
# misattribute Beaver Creek rows until BVB sites exist in master_site_lookup.csv.
print(qa_compare, n = Inf)

# ---- Write compiled dataset ---------------------------------------------

dir.create(here("results"), showWarnings = FALSE)
write_csv(dat, here("results/compiled_sr_data.csv"))
