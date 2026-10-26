# Rendering README images

Use a full render: in preview mode, flush inlays z-fight and show up as black patches.

```sh
OS=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
# hero, perspective
$OS --backend=manifold --render --colorscheme=Tomorrow --imgsize=1600,1100 --projection=p \
    --camera=2.85,-8.5,0,52,0,28,462 -D 'part="all"' -o images/hero.png <project>.scad
# top view, orthographic, auto-framed
$OS --backend=manifold --render --colorscheme=Tomorrow --imgsize=1000,1150 --projection=o \
    --camera=0,0,0,0,0,0,0 --viewall --autocenter -D 'part="all"' -D 'language="ru"' -o images/top-ru.png <project>.scad
```

The hero camera (translation and distance) is tuned for a plate of roughly 147 × 176 mm with the layout centred on the origin, so adjust it for other sizes.

`<project>/images/scenes.scad` (if present) includes the model and shows it in use, e.g. rings set to a date. It renders the MakerWorld covers and pictures, takes the same `-D` overrides, and centres the plate on the origin:

```sh
# 4:3 cover / picture, 3:4 app cover, close-up
$OS --backend=manifold --render --colorscheme=Tomorrow --projection=p --imgsize=1600,1200 \
    --camera=0,-8,0,52,0,28,462 -o images/cover-4x3.png images/scenes.scad
$OS ... --imgsize=1200,1600 --camera=-6,-4,0,38,0,12,594 -o images/cover-3x4.png images/scenes.scad
$OS ... --imgsize=1600,1200 --camera=31,24,4,50,0,20,165 -o images/closeup.png images/scenes.scad
```

In zsh, don't keep the shared flags in a `$VAR`: zsh does not split it into separate arguments.

## Shadow pendants

`scripts/shadow-sim.py <stl> <png> --angle 30 --lamp 400` traces the wall shadow of a flat slat pendant (e.g. `designs/halloween-pumpkins/`) lit by a point lamp, to tune slats and render README images without printing.
