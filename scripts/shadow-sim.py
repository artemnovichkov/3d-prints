#!/usr/bin/env python3
"""Render the wall shadow of a flat slat pendant lit by a point lamp, as ShadowSays shows it.

Usage: python3 scripts/shadow-sim.py <pendant.stl> <out.png> [--angle 36] [--elevation 8]
                                     [--lamp 170] [--gap 90] [--res 0.1] [--size 1000]

The STL lies flat (z up, back at z = 0). Its top faces give a height map; each wall point
(at z = -gap) is in shadow when the ray to the lamp passes under that height map.
Positive angle = lamp on the left. The lamp is `lamp` mm from the pendant centre, the angle
measured from the wall normal and the elevation from the horizontal (lamp below for negative).
"""

import argparse
import math

import numpy as np
import trimesh
from PIL import Image, ImageDraw, ImageFilter


def height_map(mesh: trimesh.Trimesh, res: float):
    lo, hi = mesh.bounds
    x0, y1 = lo[0] - 1, hi[1] + 1
    w, h = int((hi[0] - lo[0] + 2) / res), int((hi[1] - lo[1] + 2) / res)
    img = Image.new("F", (w, h), 0.0)
    draw = ImageDraw.Draw(img)
    up = mesh.face_normals[:, 2] > 0.9
    tris = mesh.triangles[up]
    for z in sorted(set(np.round(tris[:, 0, 2], 3))):
        for t in tris[np.isclose(tris[:, 0, 2], z, atol=1e-3)]:
            draw.polygon([((x - x0) / res, (y1 - y) / res) for x, y, _ in t], fill=float(z))
    return np.asarray(img), x0, y1


def shadow(mesh, angle, elevation, lamp, gap, res, extent):
    hmap, x0, y1 = height_map(mesh, res)
    centre = (mesh.bounds[0] + mesh.bounds[1]) / 2
    a, e = math.radians(angle), math.radians(elevation)
    L = np.array([-math.sin(a) * math.cos(e) * lamp + centre[0], math.sin(e) * lamp + centre[1], math.cos(a) * math.cos(e) * lamp])
    # wall window centred on where the pendant centre's shadow falls
    t = gap / L[2]
    cx, cy = centre[0] + (centre[0] - L[0]) * t, centre[1] + (centre[1] - L[1]) * t
    n = int(2 * extent / res)
    xs = cx - extent + (np.arange(n) + 0.5) * res
    ys = cy + extent - (np.arange(n) + 0.5) * res
    WX, WY = np.meshgrid(xs, ys)
    dark = np.zeros_like(WX, dtype=bool)
    top = hmap.max()
    for z in np.arange(res / 4, top, res / 2):
        s = (z + gap) / (L[2] + gap)
        px, py = WX + (L[0] - WX) * s, WY + (L[1] - WY) * s
        c = ((px - x0) / res).astype(int)
        r = ((y1 - py) / res).astype(int)
        ok = (c >= 0) & (c < hmap.shape[1]) & (r >= 0) & (r < hmap.shape[0])
        hit = np.zeros_like(dark)
        hit[ok] = hmap[r[ok], c[ok]] >= z
        dark |= hit
    return dark


def picture(dark: np.ndarray, size: int) -> Image.Image:
    """Shadow on a warm wall with a soft spot of light, like the ShadowSays renders."""
    n = dark.shape[0]
    yy, xx = np.mgrid[0:n, 0:n] / n - 0.5
    spot = np.clip(1.15 - 1.1 * np.hypot(xx, yy), 0.45, 1.0)
    wall = np.array([196, 172, 136]) * spot[..., None]
    shade = np.array([22, 18, 14])
    img = np.where(dark[..., None], shade, wall).astype(np.uint8)
    out = Image.fromarray(img).resize((size, size), Image.LANCZOS)
    return out.filter(ImageFilter.GaussianBlur(0.6))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stl")
    ap.add_argument("out")
    ap.add_argument("--angle", type=float, default=36)
    ap.add_argument("--elevation", type=float, default=8)
    ap.add_argument("--lamp", type=float, default=170)
    ap.add_argument("--gap", type=float, default=90)
    ap.add_argument("--res", type=float, default=0.1)
    ap.add_argument("--extent", type=float, default=0, help="half width of the wall view, mm (default: fit)")
    ap.add_argument("--size", type=int, default=1000)
    o = ap.parse_args()
    mesh = trimesh.load(o.stl, force="mesh")
    mesh.apply_translation([0, 0, -mesh.bounds[0][2]])
    span = max(mesh.extents[:2])
    lz = o.lamp * math.cos(math.radians(o.angle)) * math.cos(math.radians(o.elevation))
    extent = o.extent or span * 0.5 * (lz + o.gap) / lz * 1.12
    picture(shadow(mesh, o.angle, o.elevation, o.lamp, o.gap, o.res, extent), o.size).save(o.out)


if __name__ == "__main__":
    main()
