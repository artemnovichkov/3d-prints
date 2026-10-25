# Watch Stool — Apple Watch Charger Stand

A tiny plastic street-food stool for the Apple Watch charger. The puck sits in the seat, the watch lies on top with its bands over the edges, and the cable runs hidden inside a leg and comes out of its foot.

![Apple Watch charging on the red stool, band hanging to the desk](images/render-hero.png)

| Seat with the puck | Cable leaves through the foot |
|---|---|
| ![Puck in the round pocket, nothing else on the seat](images/render-seat.png) | ![Cable coming out of the back leg's foot](images/render-cable.png) |

## How it works

- **The puck sits flush with the seat.** The dome on the watch back sticks out 2.44 mm ([Apple's dimensional drawing](https://developer.apple.com/accessories/dimensional-drawings/)), so the watch rests on the puck, not on the seat, and the magnet lines it up.
- **Crush ribs hold the puck.** Six thin ribs squeeze it, so the puck stays in when you lift the watch off, and the fit forgives a few tenths of a millimetre.
- **The seat shows only a round pocket.** The braided cable leaves the side of the puck under about 1 mm of seat, runs to the back-right corner and drops into a channel inside the leg.
- **Clips hold the cable in the leg.** The channel is open towards the inside of the stool, and three short clips, 0.4 mm narrower than the cable, keep it in. Press the cable in through a window with a finger.
- **The cable comes out of the foot** through a rounded cut at table level, so it pulls on the stool at the floor and doesn't tip it.
- **The cable can't lift the puck.** The braided cable is stiff, and bending it right at the puck tips the far side of the puck up. So the first 6 mm after the pocket is a clip: the cable presses up past a narrow opening into a round channel and stays straight there. It bends down to the leg after the clip, with about 9 mm of room, and a funnel rounds the edge where it goes in.
- **The puck rests on a 45° ledge, not a flat floor.** The seat prints face down, so a flat floor would have to bridge over the pocket. The ledge prints without bridges, and the puck's rounded bottom edge centres itself on it.
- **The USB-C plug goes through the pocket.** The hole inside the ledge is 21 mm across, wide enough for the plug and a finger, and a slit in the ledge leads from it to the cable run, so nothing has to be threaded under the seat.
- **To take the puck out**, push it up with a finger through the same hole from below: the side opposite the cable comes up first.
- **The windows are handles.** Hold the stool through a window with two fingers and tilt the watch off with the other hand. One pair of sides has a single tall window, the other a split one, like the real thing.
- **The seat is just wider than the watch** (50 mm, the legs 48 mm), so the bands bend down right away, and the chamfered edge doesn't crease them. The feet spread to 58 mm.
- **Solid posts in the legs** add weight low down, so the stool stays put when you lift the watch off.

Flat charging only: nightstand mode needs the watch on its side.

## Files

| File | What it is |
|---|---|
| [`models/watch-stool.stl`](models/watch-stool.stl) | The stool, opens in GitHub's 3D viewer |
| [`models/watch-stool.3mf`](models/watch-stool.3mf) | Ready-to-print Bambu Studio project |
| `models/parts/stool-red.stl` | The stool for other slicers |
| `watch-stool.scad` | OpenSCAD source. Upload it to the MakerWorld Parametric Model Maker or open it in OpenSCAD 2021.01+ |
| `watch-stool.f3d` | Autodesk Fusion render scene for `images/render-*.png`: meshes from the `.scad`, a watch, band, puck and cable, oak desk. Not a parametric design |
| `build.json` | Parts, filament and print settings used to build the 3MF |
| `images/` | Renders used in this README. `render-props.scad` builds the props for the Fusion scene: Apple Watch Series 11 46 mm after Apple's dimensional drawing, sport band, puck and cable |

## Parameters

| Group | Parameter | Default | Notes |
|---|---|---|---|
| Charger | `puck_d` | `28` mm | Puck diameter, from the [iFixit Apple Watch teardown](https://www.ifixit.com/Teardown/Apple+Watch+Teardown/40655). Apple doesn't publish it, and people measure 27.5–28 mm: check yours with calipers |
| | `puck_h` | `6.7` mm | Puck thickness, also from iFixit |
| | `puck_proud` | `0` mm | How far the puck sticks out above the seat. Raising it thins the seat over the cable |
| | `cable_d` | `4` mm | Diameter of the braided cable, measured from a photo: check yours. Sets the run under the seat, the leg channel and the clips |
| | `plug_w` | `14` mm | Diagonal of the USB-C plug's housing. The hole inside the ledge is at least 2 mm wider, and 21 mm by default |
| | `cable_exit` | `3.35` mm | Height of the cable centre above the bottom of the puck. OpenSCAD warns if less than 0.8 mm of seat is left over the cable |
| Fit | `grip` | `0.5` mm | How much the crush ribs squeeze the puck. Raise it if the puck lifts off with the watch, lower it if the puck doesn't go in |
| | `clip_squeeze` | `0.4` mm | How much narrower than the cable the clips are. Raise it if the cable falls out of the leg |
| Stool | `height` | `64` mm | Total height |
| | `top_w` | `48` mm | Width at the top of the legs. The seat is 2.4 mm wider |
| | `bottom_w` | `58` mm | Width at the feet: wider is steadier |
| | `wall` | `2.4` mm | Wall thickness |
| Output | `part` | `stool` | `stool` and `fit_test` (the seat only) come upside down, ready to print. `all` shows the stool with a puck, cable and watch |

Print `fit_test` first to check the puck fit and the run under the seat: it takes a fraction of the filament.

## Printing

<!-- print-info -->
| Plate | Contents | Filament | Time | Weight |
|---|---|---|---|---|
| 1 | Watch Stool | red 29.3 g | 1 h 10 min | 29.3 g |

Sliced for Bambu Lab P2S 0.4 nozzle, 0.20mm Standard, Bambu PLA Basic. Times differ on other printers.
<!-- /print-info -->

PLA, 0.4 mm nozzle, 0.2 mm layers, no supports. The stool prints upside down, seat on the plate, so the seat comes out flat and nothing needs supports: only the window edges bridge, the puck rests on a 45° ledge, and the skin over the cable run is the first layers on the plate. The 3MF has 3 walls, 25% infill, Arachne walls and the seam at the back, so the stool is heavy enough to stay put when you lift the watch off.

## Assembly

1. Push the USB-C plug down through the hole in the middle of the pocket and pull it out of the bottom of the stool.
2. Slide the cable along the slit in the ledge to the back-right edge of the pocket, push it under the edge, and press it up into the clip under the seat from below.
3. Tilt the puck, slide its cable side under the edge of the pocket, then press the other side down until the puck sits on the ledge, flush with the seat.
4. Press the cable into the channel inside the back-right leg, past the three clips, and out of the cut in the foot. Pull out the slack under the seat.

## Licence

[CC BY-NC-SA 4.0](../../LICENSE). Made by [Artem Novichkov](https://artemnovichkov.com).
