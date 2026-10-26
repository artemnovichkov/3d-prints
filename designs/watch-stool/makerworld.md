# MakerWorld listing

Not published yet. Research of similar models: `plans/watch-stool/makerworld-research.md` (local, gitignored).

- **Name:** Plastic Stool Apple Watch Charging Stand (40 of 50 chars: keeps the exact search phrase "Apple Watch Charging Stand", which almost every popular stand has in its title)
- **Category:** Household → Office (as the two most downloaded Apple Watch stands; alternative: Tools → Gadgets)
- **Tags:** apple watch, apple watch charging stand, apple watch charger, apple watch stand, apple watch dock, apple watch charger stand, apple watch accessories, apple watch ultra, apple watch 11, apple watch 10, watch stand, watch charger, watch charger stand, charging stand, charging dock, charging station, smartwatch stand, cable management, desk accessories, home office, nightstand, bedside, plastic stool, stool, mini stool, miniature furniture, street food, vietnamese stool, red stool, funny, cute, gift, customizable, parametric, no supports
- **BOM (filaments):** fill in from the AMS slot used for the first full print (red PLA, 29.3 g)
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no)
- **Upload:** `models/watch-stool.3mf` + `watch-stool.scad` (Parametric Model Maker: puck size, cable, grip, stool size; `part = "fit_test"` gives the seat alone). The `.scad` has top-level geometry, so PMM can offer STL download. `watch-stool.f3d` is a render scene only: kept in the repo, not uploaded.
- **Print profile** (P2S, 0.20 mm Standard, 1 plate): "Watch Stool · 0.2 mm, no AMS": `models/watch-stool.3mf`, 1 h 10 min, 29.3 g.

## Pictures

- Cover 4:3 and at least 3 real-life photos: take them after the first full print (watch charging on the stool, cable leaving the side, puck in the seat, hand holding it). Strip EXIF, save to `images/photos/`.
- Model pictures: `images/render-hero.png`, `images/render-seat.png`, `images/render-cable.png`.

## Description

A tiny plastic street-food stool for your Apple Watch charger. 🪑 The puck sits in the seat, the watch lies on top with its band over the edges, and the cable runs straight out of the side of the seat.

⌚ **Fits**
- The Apple Watch magnetic charging puck (Ø 28 mm, 6.7 mm thick) with the braided USB-C cable. Older USB-A chargers and other pucks: set the diameter, thickness and cable size in the customizer.
- Every Apple Watch size, 38–49 mm, Ultra included, charges flat on top. The seat is 48 mm wide, about the size of the watch, so the band drapes over the edges.
- Flat charging only: nightstand mode needs the watch on its side.

🔌 **Cable**
- The seat shows only a round pocket. The cable leaves the puck under the seat and runs straight out of the middle of the right side, between the bands.
- It hangs down to the table in a loose arc, so the stiff braided cable can't lift a foot, and a clip keeps it straight under the seat, so it can't lift the puck either.
- Nothing to thread: the USB-C plug goes down through the 21 mm hole in the pocket.

🪜 **Stacks like the real thing**
The legs splay to 64 mm and the walls are thin, so a second or third stool slides down over the first and sits just 15 mm higher. Stops under the seat keep them from wedging together. Print a few in different colours.

🖨️ **Printing**
- One plate, 49 min, 22 g. PLA, 0.4 mm nozzle, 0.2 mm layers, no supports.
- The stool prints upside down, seat on the plate. The puck rests on a 45° ledge, so the pocket needs no bridge.
- 3 walls, 25% infill, Arachne walls and back seam are set in the 3MF.

🔧 **Assembly**
1. Push the USB-C plug down through the hole in the middle of the pocket.
2. Slide the cable along the slit to the right edge of the pocket, push it under the edge and press it up into the clip, out through the slot in the side.
3. Tilt the puck, cable side first under the edge, and press it down flush.
4. Let the cable hang down to the table in a loose arc.

📐 **Fit**
- Six crush ribs hold the puck. Too tight? Lower `grip`. Lifts off with the watch? Raise it.
- Cable falls out of the clip? Raise `clip_squeeze`.
- Print `part = fit_test` first: just the seat, about 30 minutes, to check the puck and the cable clip.

Printed one? Post a make, I'd like to see your colours.
OpenSCAD source, Fusion render scene and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/watch-stool).
