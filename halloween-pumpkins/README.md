# Shadow Pumpkins — Two Words in One Shadow

Flat pumpkin pendants that hide two words each. Light one from the left and its shadow on the wall says BOO; move the light to the right and it says EEK.

[![Print on MakerWorld](https://img.shields.io/badge/Print%20on-MakerWorld-00AE42?logo=bambulab&logoColor=white)](https://makerworld.com/en/models/3455788-halloween-shadow-pumpkins-two-word-illusion)

![BOO with light from the left, EEK with light from the right](images/boo-eek.jpg)

Each pumpkin is a grid of thin vertical slats split lengthwise. Light from the left is blocked by the right half of the slat to the left of each gap, so raising the right halves inside a word turns that word solid in the shadow. The left halves do the same for light from the right.

| Pair | Light from the left · from the right |
|---|---|
| BOO / EEK | ![BOO / EEK](images/boo-eek.jpg) |
| BAT / CAT | ![BAT / CAT](images/bat-cat.jpg) |
| RIP / BYE | ![RIP / BYE](images/rip-bye.jpg) |
| OMG / RUN | ![OMG / RUN](images/omg-run.jpg) |

## Files

| File | What it is |
|---|---|
| [`models/halloween-pumpkins.stl`](models/halloween-pumpkins.stl) | All four pumpkins, opens in GitHub's 3D viewer |
| [`models/halloween-pumpkins.3mf`](models/halloween-pumpkins.3mf) | Ready-to-print Bambu Studio project: four pumpkins on one plate |
| `halloween-pumpkins.scad` | OpenSCAD source: words, font, slats, pumpkin size. Opens on your own words, ready for the MakerWorld Parametric Model Maker |
| `halloween-pumpkins.f3d` | Autodesk Fusion design: the four pumpkins as bodies |
| `build.json` | Objects and filament used to build the 3MF |
| `images/` | Simulated shadows used in this README |

The pumpkin follows the one in [ShadowSays](https://shadowsays.vercel.app), a web app for shadow illusion pendants. The images come from `scripts/shadow-sim.py`, which traces the shadow of an STL lit by a lamp 40 cm away at 30°:

```sh
openscad --backend=manifold -D 'part="boo-eek"' -o boo-eek.stl halloween-pumpkins.scad
python3 ../scripts/shadow-sim.py boo-eek.stl boo.png --angle 30 --lamp 400
```

## Parameters

| Group | Parameter | Default | Notes |
|---|---|---|---|
| Your words | `part` | `custom` | `custom` (the two words below), one preset pumpkin (`boo-eek`, `bat-cat`, `rip-bye`, `omg-run`) or `all` |
| | `left_text` / `right_text` | `BOO` / `EEK` | Shown with light from the left / right. Three or four capitals read best |
| Text | `font` | `Nunito:style=Black` | A heavy font reads best |
| | `text_size`, `bold`, `text_offset` | `18`, `0.6`, `0` mm | |
| | `text_max_w` | `60` mm | Longer words shrink to this width, both words to the same size. Widths are measured for Nunito Black |
| Slats | `slat_w` / `gap_w` | `1.2` / `0.8` mm | |
| | `low_h` / `high_h` | `0.6` / `1.6` mm | The words show between about 27° and 34° |
| | `spine_w` | `0` mm | Slat width away from the words, e.g. `0.5` for a brighter shadow around them. `0` = full slats, sturdier |
| Pumpkin | `width` | `76` mm | |
| | `frame_w`, `frame_h`, `ribs`, `rib_w`, `hole_d` | `1.2`, `1.2`, on, `1.2`, `4` mm | |
| Hanging | `hang` | `garland` | `garland`: two small stem holes for a string; `single`: one `hole_d` hole for a hook or nail |
| | `garland_hole_d` | `2.4` mm | Garland hole size, also the distance between them |

## Printing

76 × 62 mm with the stem, 1.6 mm thick. One colour, PLA, 0.4 mm nozzle, 0.2 mm layers, no supports. The 3MF turns on the Arachne wall generator for the thin slat halves.

<!-- print-info -->
| Plate | Contents | Filament | Time | Weight |
|---|---|---|---|---|
| 1 | BOO / EEK, BAT / CAT, RIP / BYE, OMG / RUN | orange 9.6 g | 44 min | 9.6 g |

Sliced for Bambu Lab P2S 0.4 nozzle, 0.20mm Standard, Bambu PLA Basic. Times differ on other printers.
<!-- /print-info -->

## Hanging

Thread a thin string in through one stem hole and out through the other: the pumpkin hangs flat along the string instead of turning edge-on to the wall, and sways a little, so the word flickers. For a hook or nail, print with `hang = "single"`. Hang it 5–10 cm from a wall. In a dark room, light it from the side with a phone flashlight or a candle at least 40 cm away, about 30° off the line straight at the wall. Move the light to the other side to flip the word. The closer the lamp, the more the angle changes across the pumpkin, and the edges of the word blur.

Make your own words at [shadowsays.vercel.app](https://shadowsays.vercel.app). Printed one? Post it with #shadowsays.
