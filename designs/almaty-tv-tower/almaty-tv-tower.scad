// Almaty TV Tower — Kok-Tobe hill relief with the 372 m TV tower
// Terrain, roads and buildings come from terrain.scad (scripts/terrain-data.py).
// Author: Artem Novichkov · artemnovichkov.com
// Compatible with OpenSCAD 2021.01

include <terrain.scad>

/* [What to generate] */
part = "all"; // [all:Everything, terrain:Terrain, tower:Tower, frame:Frame, fit-test:Socket fit test, tower-top:Tower top print test]

/* [Size] */
// Side of the square base, mm
model_size = 120; // [80:5:250]
// Vertical exaggeration of the relief
relief_scale = 1; // [1:0.1:3]
// Base thickness under the lowest point, mm
base_t = 4; // [2:0.5:10]
// Contour terraces: height of each step, mm (0 for a smooth surface). Use a multiple of the layer height
terrace_h = 0.4; // [0:0.1:2]

/* [Roads and paths] */
// Road width, mm
road_w = 1.5; // [0.8:0.1:3]
// Footpath width, mm (0 hides paths)
path_w = 0.8; // [0:0.1:2]
// Height of roads and paths above the terrain, mm
road_h = 0.6; // [0.2:0.1:1.5]

/* [Buildings] */
// Vertical exaggeration of buildings (0 hides them)
building_scale = 1.5; // [0:0.5:5]

/* [Tower] */
// Print the tower apart and drop it over a peg on the terrain: a broken one reprints without the hill. Off: the tower grows out of the terrain
separate_tower = true;
// Height multiplier of the tower over true scale
tower_scale = 0.8; // [0.5:0.1:2]
// Width multiplier of the tower over true scale
tower_width = 1; // [0.5:0.1:2]
// Thinnest printable diameter (antenna mast), mm
min_d = 1.4; // [0.8:0.1:3]
// Side of the stepped plinth, mm
plinth = 9; // [6:0.5:20]
// Peg on the terrain that a separate tower drops over, mm
peg_d = 3; // [2:0.1:3.4]
peg_h = 5; // [3:0.5:6]
// Clearance around the peg, mm
gap = 0.1; // [0.05:0.05:0.5]

/* [Frame] */
// Show the terrain in its frame, a tray it drops into (printed separately)
frame = true;
// Wall width, mm
frame_w = 5; // [2:0.5:15]
// Wall height above the floor, mm
frame_h = 12; // [2:0.5:40]
// Floor under the terrain, mm
frame_floor = 1.6; // [0.8:0.2:4]
// Clearance between the terrain and the walls, mm
frame_gap = 0.3; // [0.1:0.05:1]

/* [Hidden] */
$fn = 48;
k = model_size / terrain_size;
tower_xy = [poi[0], poi[1]] * k;
// Real tower, m, measured from the lighting design drawing (Wikimedia Commons, "Проект башни Коктобе
// в Алматы.jpg"): stepped shaft, lower pod at 171.5–181 m, upper pod at 236–253.5 m, antenna to 371.5 m.
// Shaft sections: [z from, z to, d from, d to]
shaft = [[0, 39, 18, 18], [39, 178, 13.7, 13.7], [178, 240, 9.9, 9.9], [240, 300, 3.2, 2.6], [300, 371.5, 2.6, 1.7]];
// Collars, pods and balconies: [z from, z to, d, d of the section below]. A 45° cone under each
// collar grows it out of the section below, so it prints without supports.
collars = [
    [37.6, 39.1, 19.5, 18], [42.5, 44, 18.5, 13.7], [125.1, 126.6, 18.3, 13.7], [159.8, 161.3, 18.3, 13.7],
    [171.5, 178, 27.6, 13.7], [178, 181, 21, 21],                            // lower pod
    [213.2, 214.7, 15, 9.9], [229.2, 230.7, 15, 9.9],
    [239.5, 244.3, 19.3, 9.9], [244.3, 246.6, 20.3, 19.3], [246.6, 251.6, 19.3, 19.3],
    [251.6, 253.5, 15.5, 15.5],                                              // upper pod
    [285.3, 286.8, 7.7, 3.2], [312.5, 314, 6, 2.6]];                         // antenna platforms

// Square key at the foot of the tower peg: it lines the plinth up with its footing.
key_w = 4.2;
key_h = 1;
// Clearance between the plinth of a separate tower and the roads and buildings around it, mm
plinth_gap = 0.3;

function tz(z) = z * k * tower_scale;
function td(d) = max(min_d, d * k * tower_width);

function zt(z) = base_t + z * k * relief_scale;
function ring(m, s) = s < m ? [0, s] : s < 2 * m ? [s - m, m] : s < 3 * m ? [m, 3 * m - s] : [4 * m - s, 0];

// Heightmap solid; off lifts the top surface (roads are cut from a lifted copy).
module terrain(off = 0) {
    n = terrain_n;
    m = n - 1;
    s = terrain_size / 2;
    top = [for (i = [0:m]) for (j = [0:m])
        [(j * terrain_step - s) * k, (i * terrain_step - s) * k, zt(terrain_z[i][j]) + off]];
    bottom = [for (q = [0:4 * m - 1]) let(r = ring(m, q))
        [(r[1] * terrain_step - s) * k, (r[0] * terrain_step - s) * k, 0]];
    faces = concat(
        [for (i = [0:m - 1]) for (j = [0:m - 1]) each [
            [i * n + j, (i + 1) * n + j, (i + 1) * n + j + 1],
            [i * n + j, (i + 1) * n + j + 1, i * n + j + 1]]],
        [for (q = [0:4 * m - 1]) let(a = ring(m, q), b = ring(m, (q + 1) % (4 * m)))
            [a[0] * n + a[1], b[0] * n + b[1], n * n + (q + 1) % (4 * m), n * n + q]],
        [[for (q = [0:4 * m - 1]) n * n + q]]);
    polyhedron(concat(top, bottom), faces, convexity = 6);
}

// Terrain as stacked contour slices: each step is the cross-section of the smooth terrain at its top.
module relief(off = 0) {
    if (terrace_h <= 0) {
        terrain(off);
    } else {
        top = zt(max([for (row = terrain_z) max(row)]));
        translate([0, 0, off]) {
            linear_extrude(base_t) square(model_size, center = true);
            for (h = [base_t + terrace_h:terrace_h:top])
                linear_extrude(h) projection(cut = true) translate([0, 0, -h]) terrain();
        }
    }
}

module lines(list, w) {
    for (l = list) for (i = [0:len(l) - 2])
        hull() { translate(l[i] * k) circle(d = w, $fn = 8); translate(l[i + 1] * k) circle(d = w, $fn = 8); }
}

module roads() {
    // Roads follow the smooth surface, so they stay level ribbons over the terraces.
    intersection() {
        terrain(road_h);
        linear_extrude(zt(200) + 10) intersection() {
            square(model_size, center = true);
            union() { lines(roads, road_w); if (path_w > 0) lines(paths, path_w); }
        }
    }
}

module buildings() {
    if (building_scale > 0) for (b = buildings)
        translate([0, 0, zt(b[0]) - 0.5 - terrace_h])
            linear_extrude(zt(b[1]) - zt(b[0]) + 0.5 + terrace_h + b[2] * k * building_scale)
                polygon(b[3] * k);
}

// Highest terrain point under the plinth: the plinth sits level on top of it.
plinth_z = max([for (i = [0:terrain_n - 1]) for (j = [0:terrain_n - 1])
    let(x = (j * terrain_step - terrain_size / 2) * k, y = (i * terrain_step - terrain_size / 2) * k)
    if (abs(x - tower_xy[0]) <= plinth / 2 + 1 && abs(y - tower_xy[1]) <= plinth / 2 + 1) zt(terrain_z[i][j])]);

// Three steps, 3 mm high in total, standing on z = 0.
module plinth_steps() {
    linear_extrude(1.2) square(plinth, center = true);
    translate([0, 0, 1.2]) linear_extrude(1.0) square(plinth * 0.75, center = true);
    translate([0, 0, 2.2]) linear_extrude(0.8) square(plinth * 0.5, center = true);
}

// Square key and round peg with a chamfered tip, standing on z = 0.
module tower_peg() {
    tip = 0.5;
    linear_extrude(key_h) square(key_w, center = true);
    cylinder(d = peg_d, h = peg_h - tip);
    translate([0, 0, peg_h - tip]) cylinder(d1 = peg_d, d2 = peg_d - 2 * tip, h = tip);
}

// Socket for the peg, printed with its mouth on the plate. The roofs rise at 45°, so it needs no bridges
// to sag into it, and the flared mouth keeps first-layer squish from pinching it.
module tower_socket(clearance = gap) {
    w = key_w + 2 * clearance;
    d = peg_d + 2 * clearance;
    flare = 0.3;
    key_top = key_h + 2 * clearance;
    peg_top = peg_h + 2 * clearance;
    hull() {
        translate([0, 0, -0.01]) linear_extrude(0.01) square(w + 2 * flare, center = true);
        translate([0, 0, flare]) linear_extrude(0.01) square(w, center = true);
    }
    linear_extrude(key_top) square(w, center = true);
    hull() {
        translate([0, 0, key_top]) linear_extrude(0.01) square(w, center = true);
        translate([0, 0, key_top + (w * sqrt(2) - d) / 2]) cylinder(d = d, h = 0.01);
    }
    cylinder(d = d, h = peg_top);
    translate([0, 0, peg_top]) cylinder(d1 = d, d2 = 0.2, h = d / 2);
}

module plinth() {
    translate(tower_xy) {
        // Footing from below the slope up to the first step
        translate([0, 0, zt(poi[2]) - 5]) linear_extrude(plinth_z - zt(poi[2]) + 5.01) square(plinth, center = true);
        translate([0, 0, plinth_z]) if (separate_tower) tower_peg();
    }
}

module terrain_part() {
    relief();
    difference() {
        union() {
            roads();
            buildings();
        }
        // Roads and buildings stop short of the plinth, so a separate tower drops in.
        if (separate_tower) translate([tower_xy[0], tower_xy[1], plinth_z])
            linear_extrude(zt(200)) square(plinth + 2 * plinth_gap, center = true);
    }
    plinth();
    if (!separate_tower) translate([tower_xy[0], tower_xy[1], plinth_z]) tower_part();
}

// Tower standing on z = 0.
module tower() {
    for (s = shaft) translate([0, 0, tz(s[0])])
        cylinder(d1 = td(s[2]), d2 = td(s[3]), h = tz(s[1] - s[0]) + 0.01, $fn = 16);
    for (c = collars) let(d = td(c[2]), below = td(c[3]), cone = max(0, (d - below) / 2))
        translate([0, 0, tz(c[0])]) {
            if (cone > 0) translate([0, 0, -cone]) cylinder(d1 = below, d2 = d, h = cone + 0.01, $fn = 32);
            cylinder(d = d, h = max(0.4, tz(c[1] - c[0])), $fn = 32);
        }
}

// Plinth steps and tower standing on z = 0; a separate tower has the peg socket in its base.
module tower_part() {
    difference() {
        union() {
            plinth_steps();
            translate([0, 0, 2.2]) cylinder(d = td(shaft[0][2]), h = 1, $fn = 16);
            translate([0, 0, 3]) tower();
        }
        if (separate_tower) tower_socket();
    }
}

// Tray standing on z = 0; the terrain sits on its floor at z = frame_floor.
module frame_tray() {
    inner = model_size + 2 * frame_gap;
    difference() {
        linear_extrude(frame_floor + frame_h) square(inner + 2 * frame_w, center = true);
        translate([0, 0, frame_floor]) linear_extrude(frame_h + 1) square(inner, center = true);
    }
}

// Fit test: three tower bases with sockets at gap - 0.05, gap and gap + 0.05 mm, marked by 1, 2 and 3 dots,
// and a peg for each to try them on.
module fit_test() {
    for (i = [0:2]) translate([i * (plinth + 3), 0, 0]) difference() {
        union() {
            translate([-plinth / 2, -plinth / 2 - 4, 0]) cube([plinth, plinth + 4, 2]);
            translate([0, 0, 2]) plinth_steps();
            cylinder(d = td(shaft[0][2]), h = peg_h + 4, $fn = 16);
        }
        tower_socket(gap + (i - 1) * 0.05);
        for (j = [0:i]) translate([(j - i / 2) * 2, -plinth / 2 - 2, 1.4]) cylinder(d = 1.2, h = 1, $fn = 16);
    }
    for (i = [0:2]) translate([i * (plinth + 3), plinth + 3, 0]) {
        linear_extrude(1.2) square(plinth, center = true);
        translate([0, 0, 1.2]) tower_peg();
    }
}

// Print test of the thin top: the tower above probe_from m on a 45° foot wide enough to stay put.
probe_from = 200;
module tower_top() {
    foot_d = 20;
    foot = (foot_d - td(9.9)) / 2;
    cylinder(d = foot_d, h = 0.6);
    translate([0, 0, 0.6]) cylinder(d1 = foot_d, d2 = td(9.9), h = foot);
    translate([0, 0, 0.6 + foot - tz(probe_from)]) intersection() {
        tower();
        translate([-50, -50, tz(probe_from)]) cube([100, 100, 200]);
    }
}

if (part == "all") {
    if (frame) color("#262626") frame_tray();
    color("#CBC6B8") translate([0, 0, frame ? frame_floor : 0]) {
        terrain_part();
        if (separate_tower) translate([tower_xy[0], tower_xy[1], plinth_z]) tower_part();
    }
} else if (part == "frame") {
    frame_tray();
} else if (part == "terrain") {
    terrain_part();
} else if (part == "tower") {
    tower_part();
} else if (part == "fit-test") {
    fit_test();
} else if (part == "tower-top") {
    tower_top();
}
