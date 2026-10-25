# MakerWorld listing

Not published yet.

- **Name:** Plastic Stool Apple Watch Charger Stand (50 chars max)
- **Category:** Gadgets → pick the phone/watch accessories subcategory in the form
- **Tags:** apple watch, apple watch stand, apple watch charger, watch charger, watch stand, charging stand, charging dock, watch dock, nightstand, plastic stool, mini stool, stool, tiny furniture, miniature, street food, vietnam, hong kong, asian stool, cable management, hidden cable, desk accessories, desk organizer, gift, gift idea, funny, cute, customizable, parametric, openscad, no supports
- **BOM (filaments):** fill in from the AMS slot used for the first full print (red PLA, 29.3 g)
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no)
- **Upload:** `models/watch-stool.3mf` + `watch-stool.scad` (Parametric Model Maker: puck size, cable, grip, stool size; `part = "fit_test"` gives the seat alone). The `.scad` has top-level geometry, so PMM can offer STL download. `watch-stool.f3d` is a render scene only: kept in the repo, not uploaded.
- **Print profile** (P2S, 0.20 mm Standard, 1 plate): "Watch Stool · 0.2 mm, no AMS": `models/watch-stool.3mf`, 1 h 10 min, 29.3 g.

## Pictures

- Cover 4:3 and at least 3 real-life photos: take them after the first full print (watch charging on the stool, cable leaving the foot, puck in the seat, hand holding it). Strip EXIF, save to `images/photos/`.
- Model pictures: `images/render-hero.png`, `images/render-seat.png`, `images/render-cable.png`.

## Description

A tiny plastic street-food stool for your Apple Watch charger. 🪑 The puck sits in the seat, the watch lies on top with its band over the edges, and the cable hides inside a leg and comes out of its foot.

⌚ **Fits**
- The Apple Watch magnetic charging puck (Ø 28 mm, 6.7 mm thick) with the braided USB-C cable. Older and other pucks: set the diameter, thickness and cable size in the customizer.
- Any Apple Watch charges flat on top. The seat is 50 mm wide, so 41–49 mm cases and Ultra all fit, and the band drapes over the edges.
- Flat charging only: nightstand mode needs the watch on its side.

🔌 **Hidden cable**
- The seat shows only a round pocket. The cable leaves the puck under the seat, runs in a clip to the back-right corner and goes down a channel inside the leg.
- Three clips in the leg keep it in, and it leaves through a cut in the foot at table level, so pulling the cable doesn't tip the stool.
- Nothing to thread: the USB-C plug goes down through the 21 mm hole in the pocket.

🖨️ **Printing**
- One plate, 1 h 10 min, 29 g. PLA, 0.4 mm nozzle, 0.2 mm layers, no supports.
- The stool prints upside down, seat on the plate. The puck rests on a 45° ledge, so the pocket needs no bridge.
- 3 walls, 25% infill, Arachne walls and back seam are set in the 3MF.

🔧 **Assembly**
1. Push the USB-C plug down through the hole in the middle of the pocket.
2. Slide the cable along the slit to the back-right edge of the pocket, push it under the edge and press it up into the clip.
3. Tilt the puck, cable side first under the edge, and press it down flush.
4. Press the cable into the channel in the back-right leg and out of the cut in the foot.

📐 **Fit**
- Six crush ribs hold the puck. Too tight? Lower `grip`. Lifts off with the watch? Raise it.
- Cable falls out of the clips? Raise `clip_squeeze`.
- Print `part = fit_test` first: just the seat, about 30 minutes, to check the puck and the cable clip.

Printed one? Post a make, I'd like to see your colours.
OpenSCAD source, Fusion render scene and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/watch-stool).
