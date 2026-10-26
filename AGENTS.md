# AGENTS.md

3D-printable models designed by Artem Novichkov, printed on a Bambu Lab P2S and published on MakerWorld. Each model lives in its own folder under `designs/`, and `scripts/` holds the shared build tooling. Below, `<project>` means `designs/<project>/`.

## Setup

```sh
npx skills experimental_install          # restores the bambu-studio-ai skill from skills-lock.json
python3 -m pip install --user --break-system-packages -r .claude/skills/bambu-studio-ai/requirements.txt
brew install --cask openscad@snapshot    # the stable `openscad` cask is disabled
brew install --cask font-nunito font-jost  # without them OpenSCAD silently falls back to another font
```

- `.mcp.json` sets up the Autodesk Fusion MCP server (`http://127.0.0.1:27182/mcp`). It only works while Fusion is running.
- Bambu Studio has to be installed at `/Applications/BambuStudio.app`: its CLI slices the 3MF and produces the print-info table.

## Build

```sh
python3 scripts/build-models.py designs/<project>
```

The script reads `<project>/build.json` and `<project>/<project>.scad`, then:

1. Exports every part listed in `build.json` with `openscad --backend=manifold -D part="<part>"`. Without a `.scad` (Fusion-only projects such as `designs/xcode-keychain/`), it reads `<project>/parts/<part>.stl` instead: export one STL per Fusion body there. `parts/` is gitignored. A variant's `sources` swaps a part's STL (e.g. `base` → `base-nfc`), and `pause_above` adds a pause for inserts such as NFC stickers.
2. Writes `models/<project>.stl`. It is one mesh, placed objects side by side, without the parts in `preview_skip`, and GitHub shows it in its 3D viewer.
3. Writes `models/<project>.3mf`, a Bambu Studio project. Each object becomes a multi-part object with a filament assigned to each part, and `"plate": N` puts objects on separate plates.
4. Writes `models/parts/<part>[-<variant>]-<filament>.stl`, one STL per part for slicers that can't read the Bambu 3MF's filaments (PrusaSlicer, Printables). Parts keep their positions within the object, so loading them together as one multi-part object lines them up. Variants only add parts that differ from the main build.
5. Slices the 3MF with the Bambu Studio CLI and rewrites the table between `<!-- print-info -->` and `<!-- /print-info -->` in the project README.

The format of `build.json` is documented in the docstring of `scripts/build-models.py`. Commit `models/` whenever the `.scad` source changes.

### Printer settings templates

`scripts/templates/<printer>/` holds the Bambu Studio settings per printer. `scripts/templates/P2S/end-gcode-melody.txt` is the author's personal end G-code with a finish melody: keep it out of `project_settings.config` when building models to publish. Format and adding a printer: `docs/printer-templates.md`.

## Model conventions

Use `designs/ringlet-calendar/` as the reference project.

```
designs/<project>/
├── README.md        description, parameters, printing, <!-- print-info --> markers
├── <project>.scad   parametric source; the source of truth for models/
├── <project>.f3d    Autodesk Fusion source (optional)
├── build.json       printer, filaments, objects/parts/plates, preview_skip
├── models/          generated .stl, .3mf and parts/*.stl (committed)
└── images/          README renders (committed)
```

- The `.scad` file must stay compatible with OpenSCAD 2021.01 so that it works in the MakerWorld Parametric Model Maker. Use Customizer comments (`/* [Group] */`, `// [a:A, b:B]` ranges), and Google Fonts names for fonts.
- The `.scad` file has a `part` parameter (`all` plus one value per printable body). `build.json` refers to those part names.
- For multi-plate output in MakerWorld Parametric Model Maker, define `mw_plate_1()`, `mw_plate_2()`, … and optionally `mw_assembly_view()`, and never call them yourself. PMM adds any top-level geometry to every plate and to the assembly view, so put `part` under `/* [Hidden] */` with a default that renders nothing (e.g. `"plates"`), and pass `-D part="all"` for local renders. Such scripts can't offer STL download in PMM.
- Two-colour text is an inlay: a `labels` body fills pockets cut into `base`, flush with its top. A colourless STL of `base` and `labels` merged hides the text, so add `labels` to `preview_skip` and the preview shows the text engraved.
- Keep parts that print in different colours at different heights on separate plates. For example, white rings beside a green base force a filament change on every layer the two have in common.
- Generated G-code (`*.gcode`, `*.gcode.3mf`) is gitignored. Licence: CC BY-NC-SA 4.0 unless a project says otherwise.

## More docs

Read these only when the task needs them:

- `docs/publishing.md`: MakerWorld and Printables listings and uploads.
- `docs/rendering.md`: OpenSCAD README images, MakerWorld covers, shadow pendant simulation.
- `docs/printer-templates.md`: printer settings templates, adding a printer.
