# 3D Prints

Source files for things I design and print: parametric OpenSCAD scripts, Autodesk Fusion designs, and print notes.

Printed on a Bambu Lab printer. Finished models are also published on [MakerWorld](https://makerworld.com/).

## Projects

| | Project | Description |
|---|---|---|
| <img src="ringlet-calendar/images/hero.png" width="200"> | [Ringlet](ringlet-calendar) | Customizable perpetual ring calendar |

## Repository layout

Each project lives in its own folder:

```
project-name/
├── README.md          description, parameters, print settings
├── project-name.scad  OpenSCAD source (if parametric)
├── project-name.f3d   Autodesk Fusion source
├── build.json         printer, parts and filaments for the 3MF
├── models/
│   ├── project-name.stl   single mesh, previews in 3D on GitHub
│   └── project-name.3mf   Bambu Studio project, parts and colours assigned
└── images/
```

`models/` is generated from the `.scad` source (needs [OpenSCAD](https://openscad.org), `brew install --cask openscad@snapshot`):

```sh
python3 scripts/build-models.py project-name
```

The 3MF uses Bambu Studio settings from `scripts/templates/<printer>/` (P2S by default).

## Claude Code setup

The repo ships with config for [Claude Code](https://claude.com/claude-code):

- `.mcp.json` — Autodesk Fusion MCP server (`http://127.0.0.1:27182/mcp`, Fusion must be running)
- `skills-lock.json` — [bambu-studio-ai](https://github.com/heyixuan2/bambu-studio-ai) skill

After cloning:

```sh
npx skills experimental_install
python3 -m pip install --user --break-system-packages -r .claude/skills/bambu-studio-ai/requirements.txt
python3 .claude/skills/bambu-studio-ai/scripts/doctor.py
```

## Licence

Unless a project says otherwise, everything here is licensed under [CC BY-NC-SA 4.0](LICENSE).

Made by [Artem Novichkov](https://artemnovichkov.com).
