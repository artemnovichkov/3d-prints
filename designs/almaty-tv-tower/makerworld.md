# MakerWorld listing

Draft saved 2026-11-03, not published: https://makerworld.com/en/my/models/drafts/10326286/edit (draft id 10326286). Filled via Claude in Chrome: name, category, 44 tags, CC BY-NC-SA, description, 4:3 cover + 3 gallery renders, one print profile from the 3MF, BOM (Ivory White + Charcoal, user-approved). Still to do before publishing: real-life photos (see Pictures), then the user publishes.

Uploaded only `models/almaty-tv-tower.3mf`. The `.scad` was **not** kept on MakerWorld: `almaty-tv-tower.scad` `include`s `terrain.scad`, and MakerWorld's raw-file slicer marks `terrain.scad` (a heightmap data file, no geometry) as Failed, so a working MW customizer isn't possible. Source stays on GitHub (linked in the description).

## Competitor research (2026-11-03)

- **No Almaty, Kok-Tobe or Almaty TV tower model on MakerWorld.** Searches: "Almaty" (Tank Almaz, Viktor Tsoi bust, Kairat coaster, name keychains), "Kazakhstan" (flag, yurt, country-outline topography flag, Borat), "city relief map", "topographic". The niche is empty — this is the only Almaty city landmark.
- **Proven format = "miniature city on a base + optional printable frame + optional label".** Top comparable: [New York City Lower Manhattan 3D Mini](https://makerworld.com/en/models/1182902) (Jarvizar, 4.2k downloads, 423 reviews). Three print files: city (multi-color), printable frame (optional), "New York City" label (optional) — matches our terrain / frame / tower split. Others: "Custom 3D Map | Stratamap", "Topographic Tray", "Inception City", "mini CITIES". Our model maps cleanly onto this genre.
- **Specific real TV towers exist** (Žižkov Prague, Pécs, Chengdu 339, Soviet Lattice 1:300) but none sit on a real-terrain city relief. Our hook = the tower **plus** its actual hill, roads and buildings from open data.
- **Differentiators to lead with:** a real place nobody has; real elevation (Copernicus DEM) + real roads/paths/buildings (OpenStreetMap); the measured 372 m tower; two-colour white-on-black-frame look; and it is parametric — the customizer can regenerate any place on Earth, free and open (vs the paid "City Model" generators trending on MakerWorld).
- Tag ideas borrowed from the NYC listing: city, miniature, cityscape, map, terrain, architecture, landmark, keepsake, gift, decor, skyline, wall art, display.

## Listing

- **Name (≤50):** `Almaty TV Tower & Kok-Tobe Hill — 3D City Relief` — keeps the searchable landmark + city name up front.
- **Category:** Miniatures → Architecture (where the NYC / Eiffel / Colosseum city minis sit). Alt: Education → Geography (real place, real elevation).
- **Tags (~45):** almaty, kazakhstan, kok-tobe, koktobe, tv tower, almaty tower, central asia, city, cityscape, miniature, mini city, 3d map, city map, relief, relief map, topographic, topography, terrain, elevation, contour, landmark, souvenir, travel, gift, keepsake, decor, desk decor, wall art, display, skyline, architecture, buildings, openstreetmap, dem, geography, model, scale model, parametric, openscad, customizable, two color, sand, frame, no ams, hill
- **BOM (filaments, in draft):** Bambu PLA Matte Ivory White (11100) for terrain + tower (closest official match to the real sand #CBC6B8, which has no exact Bambu SKU) + PLA Matte Charcoal (11101) for the frame. 2-colour, no AMS (separate plates).
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no).
- **Upload:** `models/almaty-tv-tower.3mf` only. No `.scad` on MakerWorld (include → terrain.scad fails MW slicing); source + regeneration via GitHub, linked in the description.

### Print profiles (P2S, 0.20 mm Standard, Bambu PLA Basic)

One profile per plate, added after publishing via ⋮ → Add Print Profile:

1. **Kok-Tobe terrain** — plate 1, sand, 2 h 7 min, 59.2 g.
2. **Frame** — plate 2, black, 53 min, 46.1 g.
3. **Tower** — plate 3, sand, 19 min, 1.1 g (run `part = "tower-top"` / `fit-test` first to dial in the antenna and peg).

## Pictures

**Temporary: sand OpenSCAD renders until real photos are shot.** MakerWorld eventually wants ≥3 real-life photos + a 4:3 cover; the renders get the draft published now. Strip EXIF/GPS on the real photos later.

- **Cover 4:3:** `images/hero.png` — sand terrain + tower in the black frame, three-quarter view.
- **Gallery (renders):**
  1. `images/hero.png` (cover).
  2. `images/listing-angle.png` — low three-quarter, shows the tower profile and terraces.
  3. `images/listing-top.png` — straight-down, the roads, paths and buildings.
- **Replace later with photos:** finished print in the frame; tower close-up (pods + antenna); tower lifted off the peg (removable); model in hand for scale. Old `images/photos/01-03` are the Oct 27 print (white, no frame, integrated tower) — do not use.

## Description (draft)

A desk model of Kok-Tobe, the hill above Almaty, with its 372 m TV tower.

The hill, its terraces, the roads, footpaths and buildings all come from open map and elevation data, so the shape is the real one, not a stylised skyline. The tower is measured from the original drawings — the stepped shaft, both pods and the antenna at their real heights — and prints as a separate piece that drops over a peg on the hill, so if the thin antenna fails you reprint the tower alone, not the whole terrain.

It sits in a black frame that prints on its own plate. Sand hill and tower, black frame — no AMS, the parts print on separate plates and go together after.

Printing: three plates — terrain (about 2 h, 59 g), frame (under 1 h), tower (about 20 min). 0.2 mm layers, sand and black PLA, no supports needed. The relief is stepped into 0.4 mm contour terraces, so each step lands on a layer line.

It is parametric. The OpenSCAD source and the script that pulls the map data are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/almaty-tv-tower) — change the size, the height exaggeration of the hill or the tower, turn the frame or the buildings off, or point it at any coordinates to print another place.

If you print one, post a make — I'd like to see it.
