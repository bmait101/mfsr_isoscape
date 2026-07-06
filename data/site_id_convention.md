# Sample Site ID Convention — MFSR Sr Study

## Format
`[STREAM CODE]-[POSITION]`

- **Stream code**: 3-4 letter abbreviation, unique per named stream.
- **Position**: 3-digit number, increasing **upstream**. Sites are spaced in
  increments of 10 (010, 020, 030...) so new sites can be inserted anywhere
  along a stream (e.g., 015, 025) without renumbering existing IDs.
- Keep the descriptive name as a separate `Site_Name` field for reports —
  the ID is a stable key, not a replacement for readable labels.

## Stream codes

| Code | Stream |
|---|---|
| BVC | Bear Valley Creek |
| BSK | Bearskin Creek |
| BVR | Beaver Creek (Marsh Creek drainage — see disambiguation note below) |
| BVB | Beaver Creek (Big Creek drainage — see disambiguation note below) |
| BIG | Big Creek |
| CAM | Camas Creek |
| CPH | Cape Horn Creek |
| ELK | Elk Creek |
| IND | Indian Creek |
| KNP | Knapp Creek |
| LOO | Loon Creek |
| MAY | Mayfield Creek (Loon Creek trib) |
| MON | Monumental Creek (Big Creek trib) |
| MRB | Marble Creek |
| MRS | Marsh Creek |
| MFSR | Middle Fork Salmon River (mainstem) |
| PIS | Pistol Creek |
| RAP | Rapid River |
| RSH | Rush Creek (Big Creek trib) |
| SHP | Sheep Creek |
| SR | Salmon River (mainstem) |
| SUL | Sulphur Creek |
| WFC | West Fork Camas Creek |
| WIL | Wilson Creek |
| WSC | Warm Spring Creek (Loon Creek trib) |
| YJC | Yellowjacket Creek (Camas Creek trib) |

### Disambiguation: two unrelated "Beaver Creek" streams

The MFSR watershed has two distinct, unconnected streams both named "Beaver Creek":
one a Marsh Creek tributary (near Cape Horn Creek, already sampled as `BVR-010`), the
other a Big Creek tributary (in the Rush/Monumental Creek area, targeted for 2026
sampling). These are **not the same stream** and must not share a code. `BVR` is
reserved for the Marsh Creek drainage's Beaver Creek (established first); the Big
Creek drainage's Beaver Creek uses `BVB`. Always check `waterbody_name` +
`stream_code` together when working with "Beaver Creek" records, since the plain
name alone is ambiguous.

## Crosswalk: current names → new IDs

| Site ID | Current name | Order basis |
|---|---|---|
| BVC-010 | Bear Valley Creek @ Bruce Meadows camp | your stated order |
| BVC-020 | Bear Valley Creek (lower) below Pole Creek | your stated order |
| BVC-030 | Bear Valley Creek (upper) below Cashe Creek | your stated order |
| BSK-010 | Bearskin Creek lower | only existing site |
| BVR-010 | Beaver Creek | only existing site |
| BIG-010 | Big Creek @ MFSR confluence | only existing site |
| CAM-010 | Camus Creek @ MFSR confluence | only existing site |
| CPH-010 | Cape Horn Creek | only existing site |
| ELK-010 | Elk Creek lower | self-describing |
| ELK-020 | Elk Creek upper | self-describing |
| IND-010 | Indian Creek @ MFSR confluence | only existing site |
| KNP-010 | Knapp Creek | only existing site |
| LOO-010 | Loon Creek @ MFSR confluence | only existing site |
| MRB-010 | Marble Creek @ MFSR confluence | only existing site |
| MRS-010 | Marsh Creek below Beaver Creek | confirmed: Beaver Ck joins Marsh well downstream of Cape Horn Ck |
| MRS-020 | Marsh Creek below Cape Horn Creek | confirmed: Cape Horn Ck confluence is upstream of Beaver Ck |
| MRS-030 | Marsh Creek (upper) | headwaters reach |
| MFSR-010 | MFSR @ Clamshell Rock | confirmed via your sample log's float-trip sequence + lat/long |
| MFSR-020 | MFSR @ Ship Island camp | confirmed via sample log sequence + lat/long |
| MFSR-030 | MFSR @ Cold Springs | confirmed via sample log sequence + lat/long |
| MFSR-040 | MFSR @ Upper Grouse camp | confirmed via sample log sequence + lat/long |
| MFSR-050 | MFSR @ Mahoney camp | confirmed via sample log sequence + lat/long |
| MFSR-060 | MFSR @ Sheepeater Camp | confirmed via sample log sequence + lat/long |
| MFSR-070 | MFSR @ Boundary Creek | confirmed via sample log sequence + lat/long |
| PIS-010 | Pistol Creek @ MFSR confluence | only existing site |
| RAP-010 | Rapid River @ MFSR confluence | only existing site |
| SHP-010 | Sheep Creek @ MFSR confluence | only existing site |
| SR-010 | SR above Cashe Bar | sampled downstream of the confluence, closer to the takeout |
| SR-020 | SR @ MFSR confluence (Stoddard) | sampled just downstream of confluence |
| SUL-010 | Sulphur Creek @ MFSR confluence | only existing site |
| WIL-010 | Wilson Creek @ MFSR confluence | only existing site |

## For 2026 new tributary sites (Sulphur, Indian, Pistol, etc.)

Each existing confluence site keeps its `-010`. As you establish 2-5 new
sites moving upstream on each tributary this season, assign them `-020`,
`-030`, `-040`, `-050` in the order you establish them (upstream = higher
number). If you later need to slot one in between, use the intermediate
values (e.g., SUL-025) instead of renumbering.

Example for Sulphur Creek after this year's work:
- SUL-010 — existing, @ MFSR confluence
- SUL-020, SUL-030, SUL-040... — new sites, increasing upstream

### 2026 target tributaries and their new codes

None of these sub-tributaries had a code before this season:

| Code | Stream | Parent drainage |
|---|---|---|
| WSC | Warm Spring Creek | Loon Creek |
| MAY | Mayfield Creek | Loon Creek |
| WFC | West Fork Camas Creek | Camas Creek |
| YJC | Yellowjacket Creek | Camas Creek |
| RSH | Rush Creek | Big Creek |
| BVB | Beaver Creek | Big Creek (see disambiguation note above) |
| MON | Monumental Creek | Big Creek |

Big Creek, upper Monumental Creek, and possibly Marble Creek are being sampled by
partners (Colden Baxter/U Idaho on Big Creek; Payette NF biologists on upper
Monumental and possibly Marble) rather than by Bryan directly — see
`field/partner_sample_collection_guide.qmd` for their site assignments.
