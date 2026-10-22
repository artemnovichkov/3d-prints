# Printables listing

Draft saved 2026-10-22: https://www.printables.com/model/1886726/edit (not published).

- **Name:** Typewriter Kindle & E-Reader Stand
- **Summary (120 max):** Your Kindle stands in a tiny typewriter like a sheet of paper. Kindle Paperwhite 3–6 or any e-reader via OpenSCAD.
- **Category:** Household → Office
- **Tags** (lower-case letters and digits only, one word each): kindle, paperwhite, ereader, stand, typewriter, retro, desk, office, openscad, parametric, gift, books
- **Model origin:** Original model – I made it
- **AI:** Yes — AI-assisted creation
- **Licence:** CC BY-NC-SA 4.0

## Files

The part STLs are renamed on upload so the device is in the file name (source → upload name):

| Source | Upload as |
|---|---|
| `models/parts/body-coral.stl` | `kindle-typewriter-pw6-body.stl` |
| `models/parts/roller-black.stl` | `kindle-typewriter-pw6-roller.stl` |
| `models/parts/body-pw5-coral.stl` | `kindle-typewriter-pw5-body.stl` |
| `models/parts/roller-pw5-black.stl` | `kindle-typewriter-pw5-roller.stl` |
| `models/parts/body-pw4-coral.stl` | `kindle-typewriter-pw4-body.stl` |
| `models/parts/roller-pw4-black.stl` | `kindle-typewriter-pw4-roller.stl` |
| `models/parts/body-pw3-coral.stl` | `kindle-typewriter-pw3-body.stl` |
| `models/parts/roller-pw3-black.stl` | `kindle-typewriter-pw3-roller.stl` |
| `models/kindle-typewriter.3mf` | `kindle-typewriter-pw6-bambu.3mf` |
| `kindle-typewriter.scad` | `kindle-typewriter.scad` |

Only the PW6 3MF goes up: the PW5/PW4/PW3 Bambu projects stay on MakerWorld, linked in the description.

## Pictures

`images/photos/01-cover-4x3.jpg` (cover), `02-letter`, `03-keys`, `04-profile`, `05-roller-on`, `06-roller-click`, then `images/render-assembly.png`, `images/render-exploded.png`.

## Description

Your Kindle stands in a tiny typewriter like a sheet of paper. ⌨️ The roller hides the bottom bezel, so you see only the page, and the keys carry debossed QWERTY letters.

📖 **Fits**
- Kindle Paperwhite 3 (2015), 4 (2018), 5 (2021) and 6 (2024): ready-made STLs for each.
- Any other e-reader, or a Kindle in a case: open `kindle-typewriter.scad` in OpenSCAD and set `device = "custom"` with its width and thickness, `case_extra` for a cover, and `tilt` (5–18°, 10° by default). Prefer a web customizer? The same model is customizable on [MakerWorld](https://makerworld.com/en/models/3472879-typewriter-kindle-e-reader-stand-customizable).

📁 **Files**
- `kindle-typewriter-pwN-body.stl` and `kindle-typewriter-pwN-roller.stl`: the two parts for Kindle Paperwhite N, already in print orientation.
- `kindle-typewriter-pw6-bambu.3mf`: Bambu Studio project for the PW6, both plates and settings ready. Projects for the other Paperwhites are on MakerWorld.
- `kindle-typewriter.scad`: the parametric source (OpenSCAD 2021.01 or newer; export with `part = "body"` or `"roller"`).

🖨️ **Printing**
- PLA, 0.4 mm nozzle, 0.2 mm layers, 15% infill, no supports.
- Body flat on the bed, roller on its flat side. One colour per part, no MMU needed.
- Arachne perimeters and a rear seam give the cleanest result.
- Prusa MK4S, 0.20mm SPEED: body ~2 h 40 min / 101 g, roller ~22 min / 10 g. Bambu Lab P2S: 2 h 15 min and 24 min.

🔧 **Assembly**
The roller slides onto a dovetail like a carriage return: put it on from the left and push it right with the lever until it clicks. No glue, and it can't lift off.

📐 **Fit**
- 0.5 mm gap on each side of the device and 0.4 mm front and back.
- Roller too tight? Raise `dt_gap` by 0.05 mm in the .scad. Too loose? Lower it.
- Printed slots come out a bit narrower than modelled: if the Kindle doesn't drop in, raise `side_clearance`. Export `part = "fit_test"` to print a thin strip around the slot and check the fit first.

Without the Kindle it still reads as a typewriter: a curled sheet of paper stands in the slot.

Printed one? Post a make, I'd like to see your colours.
Source and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/kindle-typewriter).
