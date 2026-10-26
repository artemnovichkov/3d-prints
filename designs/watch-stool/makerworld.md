# MakerWorld listing

Not published yet. Draft (2026-10-26): https://makerworld.com/en/my/models/drafts/10196116/edit has everything filled in: 3MF, `.scad` with the 6 Customizer parameters, name, category, tags, licence, description and the print profile. Covers (4:3 and 3:4) and the 5 real-life photos are the photos in `images/photos/` (EXIF stripped); the 3 model pictures are the 64 mm-feet renders (`render-hero`, `-seat`, `-cable`); the print profile pictures are photos 01, 04 and 02. Ready to publish: tick the Print Profile Guidelines box on step 3 and press Publish. Research of similar models: `plans/watch-stool/makerworld-research.md` (local, gitignored).

- **Name:** Plastic Stool Apple Watch Charging Stand (40 of 50 chars: keeps the exact search phrase "Apple Watch Charging Stand", which almost every popular stand has in its title)
- **Category:** Household → Office (as the two most downloaded Apple Watch stands; alternative: Tools → Gadgets)
- **Tags (50):** apple watch, apple watch charging stand, apple watch charger, apple watch stand, apple watch dock, apple watch charger stand, apple watch holder, apple watch accessories, apple watch ultra, apple watch 11, apple watch 10, watch stand, watch charger, watch charger stand, watch dock, charging stand, charging dock, charging station, smartwatch stand, usb-c, cable management, hidden cable, desk accessories, desk decor, desk gadget, home office, nightstand, nightstand charger, bedside, plastic stool, stool, mini stool, miniature, miniature furniture, street food, street food stool, vietnamese stool, red stool, stackable, funny, cute, gift, gift idea, customizable, parametric, openscad, no supports, no ams, easy print, quick print
- **BOM (filaments, in draft):** PLA Matte Scarlet Red (11200) / Refill / 1kg, 21.6 g
- **Licence:** CC BY-NC-SA 4.0 (adaptations: share alike; commercial: no)
- **Upload:** `models/watch-stool.3mf` + `watch-stool.scad` (Parametric Model Maker: puck diameter and thickness, cable, grip, clip; `part = "fit_test"` gives the seat alone). The `.scad` has top-level geometry, so PMM can offer STL download. `watch-stool.f3d` is a render scene only: kept in the repo, not uploaded.
- **Print profile** (P2S, 0.20 mm Standard): "Watch Stool · 0.2 mm, no AMS": `models/watch-stool.3mf`, 1 plate, 49 min, 21.6 g. Only one: no fit-test or USB-A profiles (decided 2026-10-26). Replace the 3MF with the latest version after the test print.

## Pictures

Every top stand's cover shows the watch on the stand, charging (green ring on the screen), in warm desk or nightstand light. Galleries have 5–11 pictures; the staff-picked Retro Radio draws yellow arrows on photos to show what moves.

Two red stools are printed, so the gallery has a stack photo; no colour variants.

- **Cover 4:3:** photo of the watch charging on the red stool on a desk or nightstand. Until the photos: `images/render-hero.png`. App cover 3:4: crop of the same photo.
- **Gallery, in order:**
  1. Cover.
  2. Seat with the puck flush, watch lifted off (photo; render: `images/render-seat.png`).
  3. Cable leaving the side of the seat and hanging to the table (photo; render: `images/render-cable.png`).
  4. Assembly: plug through the hole, cable pressed into the clip, with arrows.
  5. In hand, two fingers through a window, for scale.
- At least 3 real-life photos, EXIF stripped, in `images/photos/`. `render-stack.png` (three colours) and `render-stack-compare.png` (internal before/after) are not uploaded.

## Description

A tiny plastic street-food stool for your Apple Watch charger. 🪑 The puck sits flush in the seat, the watch charges on top with its band draped over the edges or tucked through a window so it doesn't dangle, and the cable leaves through the side of the seat.

⌚ **Fits**
- The Apple Watch magnetic charger with the braided USB-C cable (puck Ø 28 mm, 6.7 mm thick). Older USB-A charger or another puck: set its size in the customizer.
- Every Apple Watch, 38–49 mm, Ultra included. Flat charging only: nightstand mode needs the watch on its side.

🔌 **Clean cable**
- Only a round pocket shows on the seat. Under the seat a clip holds the cable straight out to the side, so it can't lift the puck, and it hangs down clear of the feet.
- Nothing to thread: the USB-C plug drops through the 21 mm hole in the pocket.

🪜 **Stacks like the real thing**
Print a few: they slide into each other 15 mm apart, and stops under the seat keep them from wedging.

🖨️ **Printing**
- One plate, 49 min, 22 g. PLA, 0.4 mm nozzle, 0.2 mm layers, no supports, no AMS.
- The stool prints upside down, seat on the plate. The puck rests on a 45° ledge, so nothing bridges over the pocket.

🔧 **Assembly**
1. Push the USB-C plug down through the hole in the pocket.
2. Slide the cable along the slit to the edge of the pocket and press it up into the clip, out through the side.
3. Tilt the puck in, cable side first, and press it down flush.

📐 **Fit**
Six crush ribs hold the puck. Too tight, or lifts off with the watch? Change `grip` in the customizer. Cable falls out of the clip? Raise `clip_squeeze`. Not sure? Print `part = fit_test` first: the seat alone, about 30 minutes.

Printed one? Post a make, I'd like to see your colours.
OpenSCAD source, Fusion render scene and build scripts are on [GitHub](https://github.com/artemnovichkov/3d-prints/tree/main/designs/watch-stool).
