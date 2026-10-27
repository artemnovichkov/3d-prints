#!/usr/bin/env python3
"""Write an OpenSCAD include with a terrain heightmap, roads, paths and buildings around a point.

Usage: python3 scripts/terrain-data.py --center 43.2323,76.9757 --size 800 -o designs/<project>/terrain.scad
       [--step 5] [--smooth 1.0] [--poi 43.2323,76.9757] [--lone-building 150]

Heights come from the Copernicus GLO-30 DEM (30 m, a surface model: trees and buildings included), read
from the public AWS bucket; features come from the OpenStreetMap API. Downloads are cached in
~/.cache/terrain-data. Coordinates in the output are metres, x east and y north from the centre of the
square, heights in metres above its lowest point, so the .scad picks scale and vertical exaggeration:
  terrain_size, terrain_step, terrain_n   square side, grid step (m) and grid points per side
  terrain_z[i][j]                         height at x = -size/2 + j*step, y = -size/2 + i*step
  roads, paths                            polylines [[x, y], ...], clipped to the square
  buildings                               [[z_min, z_max, height, [[x, y], ...]], ...], z under the footprint
  poi                                     [x, y, z] of --poi (default: the centre)
Map data © OpenStreetMap contributors (ODbL); DEM © DLR e.V. / Airbus, Copernicus programme.
"""

import argparse
import math
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
import tifffile
from scipy.ndimage import gaussian_filter, map_coordinates
from shapely.geometry import LineString, Polygon, box

CACHE = Path.home() / ".cache/terrain-data"
DEM_URL = "https://copernicus-dem-30m.s3.amazonaws.com/{0}/{0}.tif"
OSM_URL = "https://api.openstreetmap.org/api/0.6/map?bbox={},{},{},{}"
ROADS = {"primary", "secondary", "tertiary", "residential", "service", "unclassified", "living_street", "track"}
PATHS = {"footway", "path", "steps", "pedestrian", "cycleway", "bridleway"}
LEVEL_M = 3.5
DEFAULT_BUILDING_M = 6.0
LONE_M = 20.0


def fetch(url, name):
    CACHE.mkdir(parents=True, exist_ok=True)
    path = CACHE / name
    if not path.exists():
        req = urllib.request.Request(url, headers={"User-Agent": "3d-prints terrain-data"})
        with urllib.request.urlopen(req, timeout=300) as r:
            path.write_bytes(r.read())
    return path


def dem_tile(lat, lon):
    la, lo = math.floor(lat), math.floor(lon)
    name = f"Copernicus_DSM_COG_10_{'N' if la >= 0 else 'S'}{abs(la):02d}_00_{'E' if lo >= 0 else 'W'}{abs(lo):03d}_00_DEM"
    return la, lo, tifffile.imread(fetch(DEM_URL.format(name), name + ".tif")).astype(float)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--center", required=True, help="lat,lon")
    ap.add_argument("--size", type=float, default=800, help="square side, m")
    ap.add_argument("--step", type=float, default=5, help="grid step, m")
    ap.add_argument("--smooth", type=float, default=1.0, help="Gaussian sigma in DEM pixels (hides trees)")
    ap.add_argument("--poi", help="lat,lon of the landmark (default: centre)")
    ap.add_argument("--lone-building", type=float, default=150,
                    help="skip footprints under this area (m²) more than LONE_M from any other: gazebos, sheds")
    ap.add_argument("-o", "--output", required=True)
    args = ap.parse_args()

    lat0, lon0 = map(float, args.center.split(","))
    kx, ky = math.cos(math.radians(lat0)) * 111320, 110574
    half = args.size / 2
    to_xy = lambda lat, lon: ((lon - lon0) * kx, (lat - lat0) * ky)

    # Heightmap: smooth the 1" DEM, then sample it bicubically on the grid.
    la, lo, dem = dem_tile(lat0, lon0)
    rows, cols = dem.shape
    dem = gaussian_filter(dem, args.smooth) if args.smooth > 0 else dem
    def height(x, y):
        lat, lon = lat0 + np.atleast_1d(y) / ky, lon0 + np.atleast_1d(x) / kx
        return map_coordinates(dem, [(la + 1 - lat) * rows, (lon - lo) * cols], order=3)
    n = int(round(args.size / args.step)) + 1
    g = np.linspace(-half, half, n)
    X, Y = np.meshgrid(g, g)
    Z = height(X, Y)
    z0 = Z.min()
    Z -= z0

    # OSM features in the square.
    dlat, dlon = half / ky * 1.05, half / kx * 1.05
    bbox = (lon0 - dlon, lat0 - dlat, lon0 + dlon, lat0 + dlat)
    osm = fetch(OSM_URL.format(*bbox), "osm_{:.5f}_{:.5f}_{:.5f}_{:.5f}.xml".format(*bbox))
    root = ET.parse(osm).getroot()
    nodes = {nd.get("id"): to_xy(float(nd.get("lat")), float(nd.get("lon"))) for nd in root.iter("node")}
    square = box(-half, -half, half, half)
    roads, paths, buildings = [], [], []
    for way in root.iter("way"):
        tags = {t.get("k"): t.get("v") for t in way.iter("tag")}
        pts = [nodes[nd.get("ref")] for nd in way.iter("nd") if nd.get("ref") in nodes]
        if len(pts) < 2 or tags.get("area") == "yes":
            continue
        kind = tags.get("highway")
        if kind in ROADS or kind in PATHS:
            clipped = LineString(pts).simplify(1.0).intersection(square)
            for line in getattr(clipped, "geoms", [clipped]):
                if line.geom_type == "LineString" and line.length > 0:
                    (roads if kind in ROADS else paths).append(list(line.coords))
        elif "building" in tags and len(pts) > 3:
            poly = Polygon(pts).simplify(0.5)
            if not poly.is_valid or not square.contains(poly):
                continue
            if "height" in tags:
                h = float(tags["height"].split()[0])
            elif "building:levels" in tags:
                h = float(tags["building:levels"]) * LEVEL_M
            else:
                h = DEFAULT_BUILDING_M
            xs, ys = zip(*poly.exterior.coords[:-1])
            zs = height(xs, ys) - z0
            buildings.append((zs.min(), zs.max(), h, list(zip(xs, ys))))
    polys = [Polygon(b[3]) for b in buildings]
    buildings = [b for b, p in zip(buildings, polys)
                 if p.area >= args.lone_building or any(p.distance(q) <= LONE_M for q in polys if q is not p)]

    poi = to_xy(*map(float, args.poi.split(","))) if args.poi else (0.0, 0.0)
    poi_z = height(poi[0], poi[1])[0] - z0

    fmt = lambda pts: "[" + ",".join(f"[{x:.1f},{y:.1f}]" for x, y in pts) + "]"
    out = [
        f"// Generated by scripts/terrain-data.py --center {args.center} --size {args.size:g} --step {args.step:g}"
        f" --smooth {args.smooth:g}" + (f" --poi {args.poi}" if args.poi else "") + f" --lone-building {args.lone_building:g}",
        "// Map data © OpenStreetMap contributors (ODbL); DEM © DLR e.V. / Airbus, Copernicus programme.",
        f"terrain_size = {args.size:g};",
        f"terrain_step = {args.step:g};",
        f"terrain_n = {n};",
        f"terrain_z0 = {z0:.1f}; // m above sea level",
        f"poi = [{poi[0]:.1f}, {poi[1]:.1f}, {poi_z:.1f}];",
        "terrain_z = [",
        ",\n".join("[" + ",".join(f"{z:.1f}" for z in row) + "]" for row in Z),
        "];",
        "roads = [", ",\n".join(fmt(r) for r in roads), "];",
        "paths = [", ",\n".join(fmt(p) for p in paths), "];",
        "buildings = [",
        ",\n".join(f"[{a:.1f},{b:.1f},{h:.1f},{fmt(p)}]" for a, b, h, p in buildings),
        "];",
    ]
    Path(args.output).write_text("\n".join(out) + "\n")
    print(f"{args.output}: {n}x{n} grid, relief {Z.max():.0f} m, {len(roads)} roads, {len(paths)} paths, {len(buildings)} buildings")


if __name__ == "__main__":
    main()
