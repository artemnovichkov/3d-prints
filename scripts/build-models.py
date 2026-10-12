#!/usr/bin/env python3
"""Build models/<name>.stl (GitHub preview) and models/<name>.3mf (Bambu Studio project).

Usage: python3 scripts/build-models.py <project-folder>

Reads <project>/build.json:
{
  "printer": "P2S",
  "filaments": [{"colour": "#3f7a46", "name": "green"}, {"colour": "#f2f2f2", "name": "white"}],
  "objects": [
    {"name": "Ringlet", "parts": {"base": 1, "labels": 2}},
    {"name": "Rings", "parts": {"rings": 2}, "plate": 2}
  ],
  "preview_skip": ["labels"]
}
"preview_skip" lists parts left out of the STL preview (default: none).
Each part is exported from <project>/<project>.scad with -D part="<part>" and assigned
to a 1-based filament. Without a .scad (e.g. a Fusion-only project), parts are read from
<project>/parts/<part>.stl instead, exported from the Fusion design one STL per body. Parts of one object print as a single multi-part object.
"plate" puts an object on that build plate (default 1).
"variants" (optional) builds extra 3MFs, models/<name>-<variant>.3mf, e.g. for printers without AMS:
  "variants": {"no-ams": {"defines": {"label_style": "raised"}, "parts": {"labels": 1},
                          "change_above": "base", "change_to": 2}}
  "defines" are passed to OpenSCAD as -D, "parts" overrides part filaments, and "change_above" adds
  a filament change to "change_to" at the first layer above the top of that part. Bambu Studio
  previews the layers above it in that filament; without AMS the printer stops for a manual swap.
  A README section between <!-- print-info:<variant> --> and <!-- /print-info:<variant> --> gets its print info.
  "sources" swaps part meshes in STL projects, e.g. {"base": "base-nfc"} loads parts/base-nfc.stl as "base".
  "pause_above" pauses each plate at the first layer above that height (mm from the plate), e.g. to drop
  an NFC sticker into a pocket whose top is at that height.
"printer" picks scripts/templates/<printer>/ (default P2S): Bambu Studio settings for one
filament plus per_filament_keys.json, the keys holding a block of N values per filament.
A filament is a {"colour", "name"} object or just a "#RRGGBB" colour.
"settings" (optional) overrides Bambu Studio print (process) settings, e.g. {"enable_prime_tower": "0"}.

When Bambu Studio is installed, the 3MF is sliced and the table between
<!-- print-info --> and <!-- /print-info --> in <project>/README.md is rewritten with
time, weight and filaments per plate.
Needs OpenSCAD for .scad projects.
"""

import io
import json
import math
import re
import xml.etree.ElementTree as ET
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

import trimesh

ROOT = Path(__file__).resolve().parent.parent
TEMPLATES = ROOT / "scripts/templates"
BAMBU_CLI = "/Applications/BambuStudio.app/Contents/MacOS/BambuStudio"
OPENSCAD_CANDIDATES = ["openscad", "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"]
OBJECT_PATH = "3D/Objects/object_1.model"
PROJECT_VERSION = "02.08.02.60"
SPACING = 5.0
PLATE_STRIDE = 1.2
FLUSH_MM3 = "280"
NAMESPACES = (
    'xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02" '
    'xmlns:BambuStudio="http://schemas.bambulab.com/package/2021" '
    'xmlns:p="http://schemas.microsoft.com/3dmanufacturing/production/2015/06" '
    'requiredextensions="p"'
)
CONTENT_TYPES = """<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
 <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
 <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>
 <Default Extension="png" ContentType="image/png"/>
</Types>
"""


def rels(target: str) -> str:
    return (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        f' <Relationship Target="{target}" Id="rel-1" '
        'Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n</Relationships>\n'
    )


def escape(text: str) -> str:
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace('"', "&quot;")


def project_settings(printer: str, colours: list[str]) -> dict:
    """The printer's one-filament settings resized to len(colours) filaments."""
    folder = TEMPLATES / printer
    if not folder.is_dir():
        sys.exit(f"No settings template for {printer} in {TEMPLATES}")
    settings = json.loads((folder / "project_settings.config").read_text())
    blocks = json.loads((folder / "per_filament_keys.json").read_text())
    count = len(colours)
    for key, size in blocks.items():
        settings[key] = settings[key][:size] * count
    if "filament_self_index" in blocks:
        size = blocks["filament_self_index"]
        settings["filament_self_index"] = [str(i + 1) for i in range(count) for _ in range(size)]
    settings.update({
        "filament_colour": [c.upper() for c in colours],
        "filament_map": ["1"] * count,
        "filament_nozzle_map": ["1"] * count,
        "filament_volume_map": ["0"] * count,
        "flush_volumes_matrix": ["0" if r == c else FLUSH_MM3 for r in range(count) for c in range(count)],
        "flush_volumes_vector": ["140"] * (2 * count),
        # print, filament 1..N, printer: empty = "same as the system profile".
        "different_settings_to_system": [""] * (count + 2),
        "inherits_group": [""] * (count + 2),
    })
    return settings


def bed_size(settings: dict) -> tuple[float, float]:
    points = [[float(v) for v in p.split("x")] for p in settings["printable_area"]]
    xs, ys = zip(*points)
    return max(xs) - min(xs), max(ys) - min(ys)


def bed_centre(settings: dict) -> tuple[float, float]:
    points = [[float(v) for v in p.split("x")] for p in settings["printable_area"]]
    xs, ys = zip(*points)
    return (min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2


def openscad() -> str:
    for candidate in OPENSCAD_CANDIDATES:
        if found := shutil.which(candidate):
            return found
    sys.exit("OpenSCAD not found: brew install --cask openscad@snapshot")


def export(scad: Path, part: str, out: Path, defines: dict | None = None) -> trimesh.Trimesh:
    cmd = [openscad(), "--backend=manifold", "--export-format", "binstl", "-D", f'part="{part}"']
    for key, value in (defines or {}).items():
        cmd += ["-D", f"{key}={json.dumps(value)}"]
    cmd += ["-o", str(out), str(scad)]
    subprocess.run(cmd, check=True, capture_output=True)
    return trimesh.load(out, force="mesh")


def preview(objects: list[dict], skip: list[str]) -> trimesh.Trimesh:
    """Objects side by side as one mesh, without the skipped parts (e.g. flush inlays,
    which would fill their pockets and hide the text in a colourless STL)."""
    meshes, x = [], 0.0
    for obj in objects:
        mesh = trimesh.util.concatenate([m for p, _, m in obj["parts"] if p not in skip])
        low = mesh.bounds[0]
        mesh.apply_translation([x - low[0], 0, -low[2]])
        meshes.append(mesh)
        x = mesh.bounds[1][0] + SPACING
    return trimesh.util.concatenate(meshes)


def mesh_xml(object_id: int, mesh: trimesh.Trimesh) -> list[str]:
    lines = [f'  <object id="{object_id}" type="model">', "   <mesh>", "    <vertices>"]
    lines += [f'     <vertex x="{x:.5f}" y="{y:.5f}" z="{z:.5f}"/>' for x, y, z in mesh.vertices]
    lines += ["    </vertices>", "    <triangles>"]
    lines += [f'     <triangle v1="{a}" v2="{b}" v3="{c}"/>' for a, b, c in mesh.faces]
    lines += ["    </triangles>", "   </mesh>", "  </object>"]
    return lines


def change_z(settings: dict, top: float) -> float:
    """top_z of the first layer printed above height `top`."""
    first, layer = float(settings["initial_layer_print_height"]), float(settings["layer_height"])
    below = first + max(0, math.ceil((top - first) / layer - 1e-6)) * layer
    return round(below + layer, 4)


def changes_xml(changes: dict[int, list[str]], plates: list[int]) -> str:
    """Metadata/custom_gcode_per_layer.xml: <layer> lines per plate, as Bambu Studio saves the layer
    slider's "Change Filament" (type 2 = ToolChange) and "Add Pause" (type 1), mode MultiAsSingle."""
    lines = ['<?xml version="1.0" encoding="utf-8"?>', "<custom_gcodes_per_layer>"]
    for plate_index, plate in enumerate(plates):
        if plate not in changes:
            continue
        lines += ["<plate>", f'<plate_info id="{plate_index + 1}"/>', *changes[plate], '<mode value="MultiAsSingle"/>', "</plate>"]
    return "\n".join(lines + ["</custom_gcodes_per_layer>", ""])


def build_3mf(objects: list[dict], printer: str, filaments: list[str], name: str,
              change_above: str | None = None, change_to: int = 2, overrides: dict | None = None,
              pause_above: float | None = None) -> bytes:
    """objects: [{"name", "parts": [(part_name, filament, mesh)]}], meshes in scad coordinates.
    change_above: part name; switches to filament change_to at the first layer above its top on its plate.
    pause_above: height in mm; pauses every plate at the first layer above it."""
    settings = project_settings(printer, filaments)
    settings.update(overrides or {})
    if overrides:
        # Bambu Studio's GUI reloads every key not listed here from the system profile.
        # Slot 0 is the print (process) profile, where these overrides live.
        settings["different_settings_to_system"][0] = ";".join(sorted(overrides))
    bed_x, bed_y = bed_centre(settings)
    bed_w, bed_h = bed_size(settings)
    plates = sorted({o["plate"] for o in objects})
    columns = math.ceil(math.sqrt(len(plates)))

    mesh_lines, root_objects, items, config_objects = [], [], [], []
    plate_instances: dict[int, list[str]] = {p: [] for p in plates}
    next_id, index = 1, 0
    for plate_index, plate in enumerate(plates):
        # Bambu Studio lays plates out in a grid, one bed plus a fifth apart.
        plate_x = (plate_index % columns) * bed_w * PLATE_STRIDE
        plate_y = -(plate_index // columns) * bed_h * PLATE_STRIDE
        on_plate = [o for o in objects if o["plate"] == plate]
        # Lay objects out left to right, centred on the bed.
        boxes = [trimesh.util.concatenate([m for _, _, m in o["parts"]]).bounds for o in on_plate]
        widths = [b[1][0] - b[0][0] for b in boxes]
        x = plate_x + bed_x - (sum(widths) + SPACING * (len(on_plate) - 1)) / 2
        for obj, (low, high), width in zip(on_plate, boxes, widths):
            centre = (low + high) / 2
            component_ids = []
            config_parts = []
            for part_name, filament, mesh in obj["parts"]:
                moved = mesh.copy()
                moved.apply_translation(-centre)
                mesh_lines += mesh_xml(next_id, moved)
                component_ids.append(next_id)
                config_parts.append(
                    f'    <part id="{next_id}" subtype="normal_part">\n'
                    f'      <metadata key="name" value="{escape(part_name)}"/>\n'
                    '      <metadata key="matrix" value="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"/>\n'
                    f'      <metadata key="extruder" value="{filament}"/>\n'
                    "    </part>"
                )
                next_id += 1
            object_id = 1000 + index
            components = "\n".join(
                f'    <component p:path="/{OBJECT_PATH}" objectid="{cid}" transform="1 0 0 0 1 0 0 0 1 0 0 0"/>'
                for cid in component_ids
            )
            root_objects.append(
                f'  <object id="{object_id}" type="model">\n   <components>\n{components}\n   </components>\n  </object>'
            )
            tx, ty, tz = x + width / 2, plate_y + bed_y, (high[2] - low[2]) / 2
            items.append(
                f'  <item objectid="{object_id}" transform="1 0 0 0 1 0 0 0 1 {tx:.4f} {ty:.4f} {tz:.4f}" printable="1"/>'
            )
            first_filament = obj["parts"][0][1]
            config_objects.append(
                f'  <object id="{object_id}">\n'
                f'    <metadata key="name" value="{escape(obj["name"])}"/>\n'
                f'    <metadata key="extruder" value="{first_filament}"/>\n'
                + "\n".join(config_parts)
                + "\n  </object>"
            )
            plate_instances[plate].append(
                "    <model_instance>\n"
                f'      <metadata key="object_id" value="{object_id}"/>\n'
                '      <metadata key="instance_id" value="0"/>\n'
                f'      <metadata key="identify_id" value="{index + 1}"/>\n'
                "    </model_instance>"
            )
            x += width + SPACING
            index += 1

    object_model = "\n".join([
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<model unit="millimeter" xml:lang="en-US" {NAMESPACES}>',
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>',
        " <resources>", *mesh_lines, " </resources>", " <build/>", "</model>", "",
    ])
    root_model = "\n".join([
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<model unit="millimeter" xml:lang="en-US" {NAMESPACES}>',
        f' <metadata name="Application">BambuStudio-{PROJECT_VERSION}</metadata>',
        ' <metadata name="BambuStudio:3mfVersion">1</metadata>',
        f' <metadata name="Title">{escape(name)}</metadata>',
        " <resources>", *root_objects, " </resources>",
        " <build>", *items, " </build>", "</model>", "",
    ])
    model_settings = "\n".join([
        '<?xml version="1.0" encoding="UTF-8"?>', "<config>", *config_objects,
        *[
            "\n".join([
                "  <plate>",
                f'    <metadata key="plater_id" value="{plate_index + 1}"/>',
                '    <metadata key="plater_name" value=""/>',
                '    <metadata key="locked" value="false"/>',
                *plate_instances[plate], "  </plate>",
            ])
            for plate_index, plate in enumerate(plates)
        ],
        "</config>", "",
    ])

    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as archive:
        archive.writestr("[Content_Types].xml", CONTENT_TYPES)
        archive.writestr("_rels/.rels", rels("/3D/3dmodel.model"))
        archive.writestr("3D/3dmodel.model", root_model)
        archive.writestr("3D/_rels/3dmodel.model.rels", rels("/" + OBJECT_PATH))
        archive.writestr(OBJECT_PATH, object_model)
        archive.writestr("Metadata/model_settings.config", model_settings)
        archive.writestr("Metadata/project_settings.config", json.dumps(settings, indent=4))
        changes: dict[int, list[str]] = {}
        if change_above:
            colour = filaments[change_to - 1].upper()
            for o in objects:
                for part, _, mesh in o["parts"]:
                    if part == change_above:
                        z = change_z(settings, mesh.bounds[1][2] - min(m.bounds[0][2] for _, _, m in o["parts"]))
                        changes.setdefault(o["plate"], []).append(
                            f'<layer top_z="{z}" type="2" extruder="{change_to}" color="{colour}" extra="" gcode="tool_change"/>')
        if pause_above is not None:
            z = change_z(settings, pause_above)
            for plate in plates:
                changes.setdefault(plate, []).append(
                    f'<layer top_z="{z}" type="1" extruder="1" color="" extra="" gcode="M400 U1"/>')
        if changes:
            archive.writestr("Metadata/custom_gcode_per_layer.xml", changes_xml(changes, plates))
    return buffer.getvalue()


def duration(seconds: int) -> str:
    hours, minutes = divmod(round(seconds / 60), 60)
    return f"{hours} h {minutes} min" if hours else f"{minutes} min"


def print_info(model: Path, names: list[str]) -> str | None:
    """Slice the 3MF with Bambu Studio and return a Markdown table per plate."""
    if not Path(BAMBU_CLI).exists():
        return None
    with tempfile.TemporaryDirectory() as tmp:
        cmd = [BAMBU_CLI, "--slice", "0", "--outputdir", tmp, "--export-3mf", "sliced.3mf", str(model)]
        subprocess.run(cmd, check=True, capture_output=True)
        with zipfile.ZipFile(Path(tmp) / "sliced.3mf") as archive:
            info = ET.fromstring(archive.read("Metadata/slice_info.config"))
            settings = json.loads(archive.read("Metadata/project_settings.config"))
    rows = ["| Plate | Contents | Filament | Time | Weight |", "|---|---|---|---|---|"]
    for plate in info.iter("plate"):
        meta = {m.get("key"): m.get("value") for m in plate.findall("metadata")}
        contents = ", ".join(o.get("name") for o in plate.findall("object"))
        used = ", ".join(
            f'{names[int(f.get("id")) - 1]} {float(f.get("used_g")):.1f} g' for f in plate.findall("filament")
        )
        rows.append(
            f'| {meta["index"]} | {contents} | {used} | {duration(int(meta["prediction"]))} | {float(meta["weight"]):.1f} g |'
        )
    filament = settings["filament_settings_id"][0].split(" @")[0]
    process = settings["print_settings_id"].split(" @")[0]
    rows += ["", f'Sliced for {settings["printer_settings_id"]}, {process}, {filament}. Times differ on other printers.']
    return "\n".join(rows) + "\n"


def update_readme(readme: Path, table: str, variant: str = "") -> bool:
    tag = f"print-info:{variant}" if variant else "print-info"
    pattern = re.compile(rf"(<!-- {re.escape(tag)} -->\n).*?(<!-- /{re.escape(tag)} -->)", re.S)
    text = readme.read_text() if readme.exists() else ""
    if not pattern.search(text):
        return False
    readme.write_text(pattern.sub(lambda m: m.group(1) + table + m.group(2), text))
    return True


def report(project: Path, model: Path, names: list[str], variant: str = "") -> None:
    print(f"→ slicing {model.name} for print info")
    table = print_info(model, names)
    tag = f"print-info:{variant}" if variant else "print-info"
    if table is None:
        print("  Bambu Studio not found, README print info not updated")
    elif not update_readme(project / "README.md", table, variant):
        print(f"  no <!-- {tag} --> markers in README.md, table:\n" + table)
    else:
        print(table)


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    project = (ROOT / sys.argv[1]).resolve()
    name = project.name
    scad = project / f"{name}.scad"
    config = json.loads((project / "build.json").read_text())
    models = project / "models"
    models.mkdir(exist_ok=True)

    printer = config.get("printer", "P2S")
    filaments = [f if isinstance(f, dict) else {"colour": f, "name": f} for f in config["filaments"]]
    colours, names = [f["colour"] for f in filaments], [f["name"] for f in filaments]

    def export_objects(tmp: str, defines: dict | None = None, overrides: dict | None = None,
                       sources: dict | None = None) -> list[dict]:
        objects = []
        for obj in config["objects"]:
            parts = []
            for part, filament in obj["parts"].items():
                filament = (overrides or {}).get(part, filament)
                print(f"→ part {part} (filament {filament})")
                if scad.exists():
                    mesh = export(scad, part, Path(tmp) / f"{part}.stl", defines)
                else:
                    source = (sources or {}).get(part, part)
                    mesh = trimesh.load(project / "parts" / f"{source}.stl", force="mesh")
                parts.append((part, filament, mesh))
            objects.append({"name": obj["name"], "plate": obj.get("plate", 1), "parts": parts})
        return objects

    with tempfile.TemporaryDirectory() as tmp:
        objects = export_objects(tmp)
        print(f"→ {name}.stl")
        preview(objects, config.get("preview_skip", [])).export(models / f"{name}.stl")
        print(f"→ {name}.3mf")
        model = models / f"{name}.3mf"
        model.write_bytes(build_3mf(objects, printer, colours, name, overrides=config.get("settings")))
    report(project, model, names)

    for variant, spec in config.get("variants", {}).items():
        print(f"== variant {variant}")
        with tempfile.TemporaryDirectory() as tmp:
            objects = export_objects(tmp, spec.get("defines"), spec.get("parts"), spec.get("sources"))
            model = models / f"{name}-{variant}.3mf"
            print(f"→ {model.name}")
            model.write_bytes(build_3mf(objects, printer, colours, f"{name} ({variant})", spec.get("change_above"),
                                         spec.get("change_to", 2), config.get("settings"), spec.get("pause_above")))
        report(project, model, names, variant)


if __name__ == "__main__":
    main()
