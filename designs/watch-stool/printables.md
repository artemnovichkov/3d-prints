# Printables listing

Not published yet.

- **Name:** Plastic Stool Apple Watch Charger Stand
- **Summary (120 max):** A tiny street-food stool for the Apple Watch charger: the puck sits in the seat, the cable hides in a leg.
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

A tiny plastic street-food stool for your Apple Watch charger. 🪑 The puck sits in the seat, the watch lies on top with its band over the edges, and the cable hides inside a leg and comes out of its foot.

⌚ **Fits**
- The Apple Watch magnetic charging puck (Ø 28 mm, 6.7 mm thick) with the braided USB-C cable.
- Other pucks or cables: open `watch-stool.scad` in OpenSCAD (2021.01 or newer) and set `puck_d`, `puck_h`, `cable_d` and `cable_exit`. Prefer a web customizer? The same model is customizable on MakerWorld.
- Any Apple Watch charges flat on top, 41–49 mm cases and Ultra. Flat charging only: nightstand mode needs the watch on its side.

🔌 **Hidden cable**
- The seat shows only a round pocket. The cable leaves the puck under the seat, runs in a clip to the back-right corner and goes down a channel inside the leg.
- Three clips in the leg keep it in, and it leaves through a cut in the foot at table level.
- Nothing to thread: the USB-C plug goes down through the 21 mm hole in the pocket.

🖨️ **Printing**
- PLA, 0.4 mm nozzle, 0.2 mm layers, 25% infill, 3 perimeters, no supports.
- The STL is already upside down: seat on the bed. The puck rests on a 45° ledge, so the pocket needs no bridge.
- Bambu Lab P2S: 1 h 10 min, 29 g.

🔧 **Assembly**
1. Push the USB-C plug down through the hole in the middle of the pocket.
2. Slide the cable along the slit to the back-right edge of the pocket, push it under the edge and press it up into the clip.
3. Tilt the puck, cable side first under the edge, and press it down flush.
4. Press the cable into the channel in the back-right leg and out of the cut in the foot.

📐 **Fit**
- Six crush ribs hold the puck: change `grip` in the .scad if it's too tight or too loose.
- Cable falls out of the clips? Raise `clip_squeeze`.
- Export `part = "fit_test"` to print just the seat (about 30 minutes) and check the puck first.

Printed one? Post a make, I'd like to see your colours.
Source, Fusion render scene and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/watch-stool).
