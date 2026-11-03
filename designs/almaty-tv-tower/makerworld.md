# MakerWorld listing

**Published 2026-11-03:** https://makerworld.com/en/models/3541684-almaty-tv-tower-kok-tobe-hill-3d-city-relief (model 3541684; was draft 10326286). Filled via Claude in Chrome: name, category Architecture, 44 tags (sand → bone white), CC BY-NC-SA, formatted description, 4:3 + 3:4 covers, 5 real-life photos, one print profile from the 3MF with 2 real photos, BOM = Bambu PLA Matte Bone White (11103) + Charcoal (11101). The model was printed in **Bambu PLA Matte Bone White (11103, #CBC6B8)** — exactly the hex already in build.json, so the colour everywhere is named "bone white", not "sand".

Uploaded only `models/almaty-tv-tower.3mf`. The `.scad` was **not** kept on MakerWorld: `almaty-tv-tower.scad` `include`s `terrain.scad`, and MakerWorld's raw-file slicer marks `terrain.scad` (a heightmap data file, no geometry) as Failed, so a working MW customizer isn't possible. Source stays on GitHub (linked in the description).

## Ready-to-publish check (2026-11-03)

All required fields pass. Step 1: model file `almaty-tv-tower.3mf` (726 KB). Step 2: type Original, cover 4:3 (real photo) + optional 3:4 app cover (portrait crop of the hero, tower-forward — the app prioritises 3:4 and shows it larger), 5 real-life photos, name, category Architecture, 44 tags, CC BY-NC-SA, Public, formatted description, BOM (Bone White + Charcoal). Step 3: print profile "0.2mm layer, 2 walls, 15% infill" with **2 real photos** — the print-profile picture had been a render (MW warns a render can get the profile taken down), replaced with real photos. The only step left is the user's: tick "I've read Print Profile Guidelines" on step 3, then Publish.

## Competitor research (2026-11-03)

- **No Almaty, Kok-Tobe or Almaty TV tower model on MakerWorld.** Searches: "Almaty" (Tank Almaz, Viktor Tsoi bust, Kairat coaster, name keychains), "Kazakhstan" (flag, yurt, country-outline topography flag, Borat), "city relief map", "topographic". The niche is empty — this is the only Almaty city landmark.
- **Proven format = "miniature city on a base + optional printable frame + optional label".** Top comparable: [New York City Lower Manhattan 3D Mini](https://makerworld.com/en/models/1182902) (Jarvizar, 4.2k downloads, 423 reviews). Three print files: city (multi-color), printable frame (optional), "New York City" label (optional) — matches our terrain / frame / tower split. Others: "Custom 3D Map | Stratamap", "Topographic Tray", "Inception City", "mini CITIES". Our model maps cleanly onto this genre.
- **Specific real TV towers exist** (Žižkov Prague, Pécs, Chengdu 339, Soviet Lattice 1:300) but none sit on a real-terrain city relief. Our hook = the tower **plus** its actual hill, roads and buildings from open data.
- **Differentiators to lead with:** a real place nobody has; real elevation (Copernicus DEM) + real roads/paths/buildings (OpenStreetMap); the measured 372 m tower; two-colour white-on-black-frame look; and it is parametric — the customizer can regenerate any place on Earth, free and open (vs the paid "City Model" generators trending on MakerWorld).
- Tag ideas borrowed from the NYC listing: city, miniature, cityscape, map, terrain, architecture, landmark, keepsake, gift, decor, skyline, wall art, display.

## Listing

- **Name (≤50):** `Almaty TV Tower & Kok-Tobe Hill — 3D City Relief` — keeps the searchable landmark + city name up front.
- **Category:** Miniatures → Architecture (where the NYC / Eiffel / Colosseum city minis sit). Alt: Education → Geography (real place, real elevation).
- **Tags (~45):** almaty, kazakhstan, kok-tobe, koktobe, tv tower, almaty tower, central asia, city, cityscape, miniature, mini city, 3d map, city map, relief, relief map, topographic, topography, terrain, elevation, contour, landmark, souvenir, travel, gift, keepsake, decor, desk decor, wall art, display, skyline, architecture, buildings, openstreetmap, dem, geography, model, scale model, parametric, openscad, customizable, two color, bone white, frame, no ams, hill
- **BOM (filaments, in draft):** Bambu PLA Matte Bone White (11103, #CBC6B8) for terrain + tower — the actual filament printed, exact match — + PLA Matte Charcoal (11101) for the frame. 2-colour, no AMS (separate plates).
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no).
- **Upload:** `models/almaty-tv-tower.3mf` only. No `.scad` on MakerWorld (include → terrain.scad fails MW slicing); source + regeneration via GitHub, linked in the description.

### Print profiles (P2S, 0.20 mm Standard, Bambu PLA Basic)

One profile per plate, added after publishing via ⋮ → Add Print Profile:

1. **Kok-Tobe terrain** — plate 1, bone white, 2 h 7 min, 59.2 g.
2. **Frame** — plate 2, black, 53 min, 46.1 g.
3. **Tower** — plate 3, bone white, 19 min, 1.1 g (run `part = "tower-top"` / `fit-test` first to dial in the antenna and peg).

## Pictures

**Real photos of the Bone White print in its frame (2026-11-03).** 6 images, EXIF/GPS stripped, 4032×3024 (4:3). Source HEIC in `~/Downloads` (IMG_5540–5551); cleaned JPEGs built in the session scratchpad (`mw-photos/`), not committed to the repo. These replace the earlier OpenSCAD renders in the draft.

- **Cover 4:3:** `01-cover` (IMG_5547) — three-quarter on a plain grey backdrop, tower clear of the wall. The cover is NOT also in the gallery: MakerWorld renders the 4:3 cover as gallery slot 1/N, so putting the same shot in "real life photos" shows it twice (the dup was removed 2026-11-03).
- **Gallery (real life photos, 5):**
  1. `02-angle` (IMG_5546) — three-quarter, alternate.
  2. `03-terraces` (IMG_5543) — low macro, contour terraces + roads.
  3. `04-detail` (IMG_5544) — corner macro, buildings + paths.
  4. `05-top` (IMG_5550) — straight down, the whole map.
  5. `06-tower-in-hand` (IMG_5551) — tower lifted off the peg, shows it is removable.

All photos are full 4:3 (4032×3024) as shot, so no reframing was needed beyond the 4:3 cover crop.

**EXIF-strip rotation bug (fixed 2026-11-03):** `04-detail` (IMG_5544) uploaded upside-down. Its HEIC stored an orientation flag (180°) that `sips` did NOT bake into the pixels on JPEG conversion, and `strip_jpeg.py` then removed the flag → it displayed rotated. Fixed by `sips -r 180` and re-upload (it moved to the end of the gallery). The other four baked fine. Lesson: when stripping EXIF, bake orientation first (or `sips -r`/verify each), because any photo that relies on an orientation flag will display rotated once the flag is gone. Gallery order is now angle / terraces / top / tower-in-hand / detail.

Photos not used: IMG_5532–5539 (first batch, glittery wall + clutter); IMG_5540–5542, 5545, 5548, 5549 (weaker angle/lighting).

## Description (draft)

Formatted 2026-11-03 with rich markdown (headings + bold-lead bullets + a table), styled after the Maker Watch listing (makerworld.com/en/models/3538797). Set in the MW CKEditor via setData with `<h2>`, `<ul>`, `<strong>` and a `<figure class="table">`; all survive. Source of truth below.

A desk model of Kok-Tobe — the hill above Almaty — with its 372 m TV tower. The hill, its terraces, the roads, footpaths and buildings all come from open map and elevation data, so the shape is the real place, not a stylised skyline.

### Highlights

- **A real place, from real data:** elevation from the Copernicus DEM, with roads, paths and buildings from OpenStreetMap — at their true positions and heights.
- **The measured tower:** the 372 m TV tower is traced from the original drawings — the stepped shaft, both pods and the antenna at their real heights.
- **Removable tower:** it prints on its own and drops over a peg on the hill, so you can dial in the thin antenna on the tower alone (about 20 min) instead of reprinting the whole 2-hour terrain — and if it ever breaks, you just reprint the tower.
- **Two colours, no AMS:** bone-white hill and tower, black frame — each part prints on its own plate and goes together after, with no filament changes.
- **Fully parametric:** change the size, the height of the hill or the tower, turn the frame or the buildings off — or point it at any coordinates to print another place.

### Printing

Three plates, 0.2 mm layers, no supports needed. The relief is stepped into 0.4 mm contour terraces, so every step lands on a layer line.

| Plate | Part | Filament | Time & weight |
|---|---|---|---|
| 1 | Kok-Tobe terrain | Bone White PLA | ~2 h · 59 g |
| 2 | Frame | Charcoal PLA | ~1 h · 46 g |
| 3 | Tower | Bone White PLA | ~20 min · 1 g |

Add a drop of glue on the peg so the tower sits tight and doesn't wobble.

### Make it your own

The model is parametric. The OpenSCAD source and the script that pulls the map data are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/almaty-tv-tower) — regenerate it at any size, tweak the exaggeration of the hill or the tower, or point it at any coordinates to print your own city.

If you print one, post a make — I'd like to see it.
