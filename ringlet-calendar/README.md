# Ringlet — Customizable Perpetual Ring Calendar

A reusable desk calendar: slip one ring over the weekday, one over the date and one over the month. No batteries, no pages to tear off, works every year.

![Ringlet calendar](images/hero.png)

The whole model is parametric. Change the language, the first day of the week, peg size, ring clearance or font, and the layout rebuilds itself.

| English, week starts on Monday | English, week starts on Sunday | Russian, week starts on Monday |
|---|---|---|
| ![English, Monday](images/top-en.png) | ![English, Sunday](images/top-en-sun.png) | ![Russian, Monday](images/top-ru.png) |

## Files

| File | What it is |
|---|---|
| [`models/ringlet-calendar.stl`](models/ringlet-calendar.stl) | Base with engraved labels and rings, opens in GitHub's 3D viewer |
| [`models/ringlet-calendar.3mf`](models/ringlet-calendar.3mf) | Ready-to-print Bambu Studio project: plate 1 is the two-colour calendar, plate 2 the rings |
| `ringlet-calendar.scad` | OpenSCAD source. Upload it to the MakerWorld Parametric Model Maker or open it in OpenSCAD 2021.01+ |
| `ringlet-calendar.f3d` | Original Autodesk Fusion design with user parameters |
| `build.json` | Parts and filaments used to build the 3MF |
| `images/` | Renders used in this README |

## Parameters

| Group | Parameter | Default | Notes |
|---|---|---|---|
| Output | `part` | `all` | `all`, `base`, `labels`, `rings` |
| | `ring_count` | `3` | Weekday, date and month |
| Labels | `language` | `en` | `en`, `ru` or `custom` |
| | `week_start` | `mon` | `mon` or `sun` |
| | `custom_days`, `custom_months` | — | Comma-separated lists, used when `language = custom` |
| | `font` | `Nunito:style=Bold` | Any Google Fonts name works on MakerWorld |
| | `text_size` | `3.5` mm | Long labels shrink automatically |
| | `label_style` | `inlay` | `inlay` (flush, two colours) or `raised` |
| | `text_depth` | `0.4` mm | Inlay depth or raised height |
| Pegs | `peg_d` / `peg_h` | `12` / `4` mm | |
| | `peg_chamfer` | `0.4` mm | Helps the ring slide on |
| | `peg_spacing` | `1.7` mm | Free space between a worn ring and the next peg |
| Plate | `plate_t`, `margin`, `group_gap`, `corner_r` | `3`, `10`, `5`, `5` mm | |
| Rings | `gap` | `0.3` mm | Ring-to-peg clearance. Tune this for your printer |
| | `ring_wall` / `ring_h` / `ring_chamfer` | `1.5` / `2` / `0.3` mm | |

The grid pitch and plate size are derived from the values above. With the defaults the plate is 134 × 161 mm and fits any Bambu Lab printer, including the A1 mini.

## Printing

- **Two colours, default settings.** Open `models/ringlet-calendar.3mf`, pick your printer and filaments, print.
- **Two colours, custom settings.** Export `base` and `labels` separately, import both into Bambu Studio, and when asked choose to load them as a single object with multiple parts. Assign a filament to each part.
- **One colour.** Set `label_style = raised` and add a filament change at the first layer of the text.
- **Rings.** Print one ring and a small test first. If it is too tight, increase `gap` by 0.05 mm; if it falls off, decrease it.
- Suggested settings: 0.2 mm layers, 0.4 mm nozzle, 15 % infill, no supports.

## Licence

[CC BY-NC-SA 4.0](../LICENSE). Share and remix for non-commercial use with attribution.
