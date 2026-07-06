# MFSR Isoscape

Strontium (⁸⁷Sr/⁸⁶Sr) isoscape for the Middle Fork Salmon River (MFSR), Idaho, built to
reconstruct Chinook salmon natal origins and migratory pathways from otolith
microchemistry. USDA Forest Service, Rocky Mountain Research Station (Bryan Maitland),
with Russ Thurow (Emeritus).

## Repo map

```
data/       Raw input data — see data/README.md for the full data dictionary
R/          Data-wrangling scripts
docs/       Quarto reports: literature review, site-selection plans, project notes
field/      Field protocols and partner-facing documents
img/        Reference images (regional geology, index reaches)
results/    Generated outputs (compiled tables, figures) — not raw data, safe to regenerate
```

## Key documents

- [`data/site_id_convention.md`](data/site_id_convention.md) — site ID naming rules and
  the full stream-code crosswalk. Read before adding any new sampling site.
- [`docs/review_biogeochem_tracers.qmd`](docs/review_biogeochem_tracers.qmd) — background
  on Sr isotopes, otolith microchemistry, and how MFSR geology drives Sr variation.
- [`docs/site_selection_2026.qmd`](docs/site_selection_2026.qmd) — 2026 tributary
  sampling plan: proposed new sites per drainage, geology/logistics rationale.
- [`docs/eda_water_sr.qmd`](docs/eda_water_sr.qmd) — exploratory summary of compiled
  water Sr results collected to date.
- [`field/sop_water_samples.docx`](field/sop_water_samples.docx) — water sample
  collection SOP (acid-washing, syringe filtering).
- [`field/partner_sample_collection_guide.qmd`](field/partner_sample_collection_guide.qmd) —
  instructions for external collaborators collecting samples on Bryan's behalf.

## Reproducing the compiled dataset

```r
# from the project root, or open mfsr_isoscape.Rproj in RStudio
source("R/01_compile_sr_data.R")
```

This reads `data/master_site_lookup.csv`, `data/sample_log_water.csv`, and every
workbook in `data/icpms/`, joins them, cross-checks the result against
`data/water_sample_summary.xlsx`, and writes `results/compiled_sr_data.csv`.

Render any `.qmd` in `docs/` or `field/` with `quarto render <file>.qmd`.
