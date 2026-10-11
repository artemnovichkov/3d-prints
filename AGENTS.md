# AGENTS.md

3D-printable models designed by Artem Novichkov, printed on a Bambu Lab P2S and published on MakerWorld. Each model lives in its own folder, and `scripts/` holds the shared build tooling.

## Setup

```sh
npx skills experimental_install          # restores the bambu-studio-ai skill from skills-lock.json
python3 -m pip install --user --break-system-packages -r .claude/skills/bambu-studio-ai/requirements.txt
brew install --cask openscad@snapshot    # the stable `openscad` cask is disabled
brew install --cask font-nunito          # without it OpenSCAD silently falls back to another font
```

- `.mcp.json` sets up the Autodesk Fusion MCP server (`http://127.0.0.1:27182/mcp`). It only works while Fusion is running.
- Bambu Studio has to be installed at `/Applications/BambuStudio.app`: its CLI slices the 3MF and produces the print-info table.

## Build

```sh
python3 scripts/build-models.py <project-folder>
```

The script reads `<project>/build.json` and `<project>/<project>.scad`, then:

1. Exports every part listed in `build.json` with `openscad --backend=manifold -D part="<part>"`.
2. Writes `models/<project>.stl`. It is one mesh, placed objects side by side, without the parts in `preview_skip`, and GitHub shows it in its 3D viewer.
3. Writes `models/<project>.3mf`, a Bambu Studio project. Each object becomes a multi-part object with a filament assigned to each part, and `"plate": N` puts objects on separate plates.
4. Slices the 3MF with the Bambu Studio CLI and rewrites the table between `<!-- print-info -->` and `<!-- /print-info -->` in the project README.

The format of `build.json` is documented in the docstring of `scripts/build-models.py`. Commit `models/` whenever the `.scad` source changes.

### Printer settings templates

`scripts/templates/<printer>/` holds `project_settings.config`, the Bambu Studio settings for one filament, plus `per_filament_keys.json`, which maps each per-filament key to its block size. On the P2S, per-filament keys hold 3 values (one per extruder variant), not 1.

To add a printer, slice the same model twice with the bambu-studio-ai skill's `slice.py --printer <model>`: once with one filament and once with `--load-filaments` patched to load two. Store the one-filament config, then diff the two configs: the keys whose length doubled are the per-filament keys. Don't assume a block size of 1 per filament.

## Model conventions

Use `ringlet-calendar/` as the reference project.

```
<project>/
├── README.md        description, parameters, printing, <!-- print-info --> markers
├── <project>.scad   parametric source; the source of truth for models/
├── <project>.f3d    Autodesk Fusion source (optional)
├── build.json       printer, filaments, objects/parts/plates, preview_skip
├── models/          generated .stl and .3mf (committed)
└── images/          README renders (committed)
```

- The `.scad` file must stay compatible with OpenSCAD 2021.01 so that it works in the MakerWorld Parametric Model Maker. Use Customizer comments (`/* [Group] */`, `// [a:A, b:B]` ranges), and Google Fonts names for fonts.
- The `.scad` file exposes a `part` parameter (`all` plus one value per printable body). `build.json` refers to those part names.
- Two-colour text is an inlay: a `labels` body fills pockets cut into `base`, flush with its top. A colourless STL of `base` and `labels` merged hides the text, so add `labels` to `preview_skip` and the preview shows the text engraved.
- Keep parts that print in different colours at different heights on separate plates. For example, white rings beside a green base force a filament change on every layer the two have in common.
- Generated G-code (`*.gcode`, `*.gcode.3mf`) is gitignored. Licence: CC BY-NC-SA 4.0 unless a project says otherwise.

## Rendering README images

Use a full render: in preview mode, flush inlays z-fight and show up as black patches.

```sh
OS=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
# hero, perspective
$OS --backend=manifold --render --colorscheme=Tomorrow --imgsize=1600,1100 --projection=p \
    --camera=2.85,-8.5,0,52,0,28,420 -o images/hero.png <project>.scad
# top view, orthographic, auto-framed
$OS --backend=manifold --render --colorscheme=Tomorrow --imgsize=1000,1150 --projection=o \
    --camera=0,0,0,0,0,0,0 --viewall --autocenter -D 'language="ru"' -o images/top-ru.png <project>.scad
```

The hero camera (translation and distance) is tuned for a plate of roughly 134 × 161 mm with the layout centred on the origin, so adjust it for other sizes.

`<project>/images/scenes.scad` (if present) includes the model and shows it in use, e.g. rings set to a date. It renders the MakerWorld covers and pictures, takes the same `-D` overrides, and centres the plate on the origin:

```sh
# 4:3 cover / picture, 3:4 app cover, close-up
$OS --backend=manifold --render --colorscheme=Tomorrow --projection=p --imgsize=1600,1200 \
    --camera=0,-8,0,52,0,28,420 -o images/cover-4x3.png images/scenes.scad
$OS ... --imgsize=1200,1600 --camera=-6,-4,0,38,0,12,540 -o images/cover-3x4.png images/scenes.scad
$OS ... --imgsize=1600,1200 --camera=28,22,4,50,0,20,150 -o images/closeup.png images/scenes.scad
```

In zsh, don't keep the shared flags in a `$VAR`: zsh does not split it into separate arguments.
