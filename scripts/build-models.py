#!/usr/bin/env python3
"""Build models/<name>.stl (GitHub preview) and models/<name>.3mf (Bambu Studio project).

Usage: python3 scripts/build-models.py <project-folder>

Reads <project>/build.json:
{
  "printer": "P2S",
  "filaments": ["#3f7a46", "#f2f2f2"],
  "objects": [
    {"name": "Ringlet", "parts": {"base": 1, "labels": 2}},
    {"name": "Rings", "parts": {"rings": 2}}
  ]
}
"preview_skip" lists parts left out of the STL preview (default: none).
Each part is exported from <project>/<project>.scad with -D part="<part>" and assigned
to a 1-based filament. Parts of one object print as a single multi-part object.
"printer" picks scripts/templates/<printer>/ (default P2S): Bambu Studio settings for one
filament plus per_filament_keys.json, the keys holding a block of N values per filament.
Needs OpenSCAD.
"""

import io
import json
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

import trimesh

ROOT = Path(__file__).resolve().parent.parent
TEMPLATES = ROOT / "scripts/templates"
OPENSCAD_CANDIDATES = ["openscad", "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"]
OBJECT_PATH = "3D/Objects/object_1.model"
PROJECT_VERSION = "02.08.02.60"
SPACING = 5.0
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


def bed_centre(settings: dict) -> tuple[float, float]:
    points = [[float(v) for v in p.split("x")] for p in settings["printable_area"]]
    xs, ys = zip(*points)
    return (min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2


def openscad() -> str:
    for candidate in OPENSCAD_CANDIDATES:
        if found := shutil.which(candidate):
            return found
    sys.exit("OpenSCAD not found: brew install --cask openscad@snapshot")


def export(scad: Path, part: str, out: Path) -> trimesh.Trimesh:
    cmd = [openscad(), "--backend=manifold", "--export-format", "binstl",
           "-D", f'part="{part}"', "-o", str(out), str(scad)]
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


def build_3mf(objects: list[dict], printer: str, filaments: list[str], name: str) -> bytes:
    """objects: [{"name", "parts": [(part_name, filament, mesh)]}], meshes in scad coordinates."""
    settings = project_settings(printer, filaments)
    bed_x, bed_y = bed_centre(settings)

    # Lay objects out left to right, centred on the bed.
    boxes = [trimesh.util.concatenate([m for _, _, m in o["parts"]]).bounds for o in objects]
    widths = [b[1][0] - b[0][0] for b in boxes]
    x = bed_x - (sum(widths) + SPACING * (len(objects) - 1)) / 2

    mesh_lines, root_objects, items, config_objects, instances = [], [], [], [], []
    next_id = 1
    for index, (obj, (low, high), width) in enumerate(zip(objects, boxes, widths)):
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
        tx, ty, tz = x + width / 2, bed_y, (high[2] - low[2]) / 2
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
        instances.append(
            "    <model_instance>\n"
            f'      <metadata key="object_id" value="{object_id}"/>\n'
            '      <metadata key="instance_id" value="0"/>\n'
            f'      <metadata key="identify_id" value="{index + 1}"/>\n'
            "    </model_instance>"
        )
        x += width + SPACING

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
        "  <plate>",
        '    <metadata key="plater_id" value="1"/>',
        '    <metadata key="plater_name" value=""/>',
        '    <metadata key="locked" value="false"/>',
        *instances, "  </plate>", "</config>", "",
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
    return buffer.getvalue()


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    project = (ROOT / sys.argv[1]).resolve()
    name = project.name
    scad = project / f"{name}.scad"
    config = json.loads((project / "build.json").read_text())
    models = project / "models"
    models.mkdir(exist_ok=True)

    with tempfile.TemporaryDirectory() as tmp:
        objects = []
        for obj in config["objects"]:
            parts = []
            for part, filament in obj["parts"].items():
                print(f"→ part {part} (filament {filament})")
                parts.append((part, filament, export(scad, part, Path(tmp) / f"{part}.stl")))
            objects.append({"name": obj["name"], "parts": parts})
        print(f"→ {name}.stl")
        preview(objects, config.get("preview_skip", [])).export(models / f"{name}.stl")
        print(f"→ {name}.3mf")
        (models / f"{name}.3mf").write_bytes(build_3mf(objects, config.get("printer", "P2S"), config["filaments"], name))


if __name__ == "__main__":
    main()
