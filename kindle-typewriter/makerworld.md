# MakerWorld listing

Draft: https://makerworld.com/en/my/models/drafts/10122517/edit

- **Name:** Typewriter Kindle & E-Reader Stand | Customizable (50 chars max)
- **Category:** Household → Office
- **Tags:** kindle, kindle stand, kindle dock, kindle paperwhite, paperwhite, e-reader, ereader stand, book stand, typewriter, retro, vintage, mini typewriter, desk accessories, office, reading, book lover, gift, customizable, parametric, openscad, no supports, multicolor, ereader, kindle holder, kindle accessory, ereader holder, e-reader stand, paperwhite stand, kobo, reading nook, bookish, bookish accessories, desk accessory, home decor, nightstand, gift idea, typewriter decor, qwerty
- **BOM (filaments, in draft):** PLA Matte Scarlet Red (11200) / Refill / 1kg (body, 100.5 g), PLA Basic Black (10101) / Refill / 1kg (roller, 10 g). Printed with PLA Lite black for the roller, which the BOM does not list.
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no)
- **Upload:** `models/kindle-typewriter.3mf` + `kindle-typewriter.scad` (Parametric Model Maker: device, case, tilt, fit).
- **Print profiles** (P2S, 0.20 mm Standard, 2 plates). The first goes in with the model, add the others after publishing (⋮ → Add Print Profile), each with the PW6 photo as cover plus its own render (PW6 profile has `01-cover-4x3` + `03-keys`):
  - "Kindle Paperwhite 6 (2024) · 0.2 mm, no AMS": `models/kindle-typewriter.3mf`, 2 h 39 min
  - "Kindle Paperwhite 5 (2021) · 0.2 mm, no AMS": `models/kindle-typewriter-pw5.3mf`, 2 h 37 min
  - "Kindle Paperwhite 4 (2018) · 0.2 mm, no AMS": `models/kindle-typewriter-pw4.3mf`, 2 h 31 min
  - "Kindle Paperwhite 3 (2015) · 0.2 mm, no AMS": `models/kindle-typewriter-pw3.3mf`, 2 h 33 min

## Pictures

- Cover 4:3: `images/photos/01-cover-4x3.jpg`; app cover 3:4: `images/photos/cover-3x4.jpg`.
- Real life photos (EXIF stripped, `images/photos/`): `01-cover-4x3`, `02-letter`, `03-keys`, `04-profile`, `05-roller-on`, `06-roller-click`. They replace the 3 temporary renders in the draft. Print profile photo: `01-cover-4x3`.
- Kindle screen: `Typewriter Pages` EPUB (Special Elite font) opened in KOReader.
- Model pictures: `render-desk.png`, `render-assembly.png`, `render-exploded.png`, `render-keys.png`, `render-top.png`.

## Description

Your Kindle stands in a tiny typewriter like a sheet of paper. ⌨️ The roller hides the bottom bezel, so you see only the page, and the keys carry debossed QWERTY letters.

📖 **Fits**
- Kindle Paperwhite 3 (2015), 4 (2018), 5 (2021) and 6 (2024), picked from a list.
- Any other e-reader: choose Custom size and enter its width and thickness.
- With a cover: set the extra thickness of the case.
- The device sits 10° back by default; tilt goes from 5° to 18°.

🖨️ **Printing**
- Two plates: body (2 h 15 min, 100 g) and roller (24 min, 10 g). One colour per plate, no AMS needed.
- PLA, 0.4 mm nozzle, 0.2 mm layers, no supports. The body prints flat, the roller on its flat side.
- Arachne walls and back seam are set in the 3MF.

🔧 **Assembly**
The roller slides onto a dovetail like a carriage return: put it on from the left and push it right with the lever until it clicks. No glue, and it can't lift off.

📐 **Fit**
- 0.5 mm gap on each side of the device and 0.4 mm front and back.
- Roller too tight? Raise `dt_gap` by 0.05 mm. Too loose? Lower it.
- Printed slots come out a bit narrower than modelled: if the Kindle doesn't drop in, raise `side_clearance`.

Without the Kindle it still reads as a typewriter: a curled sheet of paper stands in the slot.

Printed one? Post a make, I'd like to see your colours.
OpenSCAD source and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/kindle-typewriter).
