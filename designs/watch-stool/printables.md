# Printables listing

Not published yet.

- **Name:** Plastic Stool Apple Watch Charger Stand
- **Summary (120 max):** A tiny street-food stool for the Apple Watch charger: the puck sits in the seat, the watch on top.
- **Category:** Gadgets → pick the phone/watch accessories subcategory in the form
- **Tags** (lower-case letters and digits only, one word each): applewatch, watch, charger, stand, dock, stool, miniature, desk, cable, openscad, parametric, gift
- **Model origin:** Original model – I made it
- **AI:** Yes — AI-assisted creation
- **Licence:** CC BY-NC-SA 4.0

## Files

| Source | Upload as |
|---|---|
| `models/parts/stool-red.stl` | `watch-stool.stl` |
| `models/watch-stool.3mf` | `watch-stool-bambu.3mf` |
| `watch-stool.scad` | `watch-stool.scad` |

File notes: STL "The stool, already upside down for printing", 3MF "Bambu Studio project with settings ready", .scad "OpenSCAD source: set your puck and cable size, or export part = "fit_test" to print the seat alone first."

## Pictures

Real-life photos from the first full print (cover first), then `images/render-hero.png`, `images/render-seat.png`, `images/render-cable.png`.

## Description

A tiny plastic street-food stool for your Apple Watch charger. 🪑 The puck sits in the seat, the watch lies on top with its band over the edges or tucked through a window so it doesn't dangle, and the cable runs straight out of the side of the seat.

⌚ **Fits**
- The Apple Watch magnetic charging puck (Ø 28 mm, 6.7 mm thick) with the braided USB-C cable.
- Other pucks or cables: open `watch-stool.scad` in OpenSCAD (2021.01 or newer) and set `puck_d`, `puck_h` and `cable_d`. Prefer a web customizer? The same model is customizable on MakerWorld.
- Any Apple Watch charges flat on top, 41–49 mm cases and Ultra. Flat charging only: nightstand mode needs the watch on its side.

🔌 **Cable**
- The seat shows only a round pocket. The cable leaves the puck under the seat and runs straight out of the middle of the right side, between the bands.
- It hangs down to the table in a loose arc, so the stiff braided cable can't lift a foot, and a clip keeps it straight under the seat, so it can't lift the puck either.
- Nothing to thread: the USB-C plug goes down through the 21 mm hole in the pocket.

🪜 **Stacks like the real thing**
The legs splay to 64 mm and the walls are thin, so a second or third stool slides down over the first and sits just 15 mm higher. Stops under the seat keep them from wedging together.

🖨️ **Printing**
- PLA, 0.4 mm nozzle, 0.2 mm layers, 25% infill, 3 perimeters, no supports.
- The STL is already upside down: seat on the bed. The puck rests on a 45° ledge, so the pocket needs no bridge.
- Bambu Lab P2S: 49 min, 22 g.

🔧 **Assembly**
1. Push the USB-C plug down through the hole in the middle of the pocket.
2. Slide the cable along the slit to the right edge of the pocket, push it under the edge and press it up into the clip, out through the slot in the side.
3. Tilt the puck, cable side first under the edge, and press it down flush.
4. Let the cable hang down to the table in a loose arc.

📐 **Fit**
- Six crush ribs hold the puck: change `grip` in the .scad if it's too tight or too loose.
- Cable falls out of the clip? Raise `clip_squeeze`.
- Export `part = "fit_test"` to print just the seat (about 30 minutes) and check the puck first.

Printed one? Post a make, I'd like to see your colours.
Source, Fusion render scene and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/watch-stool).
