// Props for the Fusion render scene: Apple Watch, sport band, charging puck and braided cable,
// in assembled positions around the stool from watch-stool.scad (mm, stool upright).
// Watch case after Apple's dimensional drawing of Apple Watch Series 11, 46 mm.
// Export one prop at a time: -D 'part="none"' -D 'prop="band_front"' etc.
// (part="none" stops the included watch-stool.scad from rendering its own part.)

include <../watch-stool.scad>

prop = "stool"; // [stool, puck_body, puck_top, cable, case, glass, crown, button, face_time, face_date, band_front, band_back]

// ---------- watch ----------
case_l = 46.00;
case_w = 39.76;
case_t = 9.70;                  // flat of back to the display glass
glass_l = 43.45;
glass_w = 37.21;
dome_d = 26.60;
dome_h = 2.44;
crown_d = 7.25;
crown_out = (41.63 - case_w) / 2;
puck_top_z = H + puck_proud;
back_z = puck_top_z - 1.0 + dome_h; // the dome sinks into the puck's dish
lug_z = back_z + 4.6;

module rrect(l, w, inset = 0) offset(r = 10.5 - inset) square([w - 21, l - 21], center = true);
module case_slice(z, inset) translate([0, 0, back_z + z]) linear_extrude(0.01) rrect(case_l, case_w, inset);

module watch_case() {
    hull() {
        case_slice(0, 2.2);
        case_slice(1.2, 0.5);
        case_slice(2.6, 0);
        case_slice(6.6, 0);
        case_slice(8.6, 0.9);
    }
    // sensor dome on the back
    translate([0, 0, back_z]) scale([1, 1, 2 * dome_h / dome_d]) sphere(d = dome_d);
}

module glass() hull() {
    translate([0, 0, back_z + 8.55]) linear_extrude(0.01) rrect(glass_l + 1.2, glass_w + 1.2);
    translate([0, 0, back_z + case_t - 0.01]) linear_extrude(0.01) rrect(glass_l - 2.2, glass_w - 2.2);
}

module crown() translate([case_w / 2 - 0.6, 8.66, back_z + 5.07]) rotate([0, 90, 0]) {
    cylinder(d = crown_d, h = crown_out + 0.6, $fn = 48);
    for (a = [0:10:359]) rotate(a) translate([crown_d / 2, 0, 0.6]) cylinder(d = 0.5, h = crown_out - 0.2, $fn = 8);
}

module side_button() hull() for (y = [-12.46 + 1.4, -0.03 - 1.4])
    translate([case_w / 2 - 0.8, y, back_z + 4.8]) rotate([0, 90, 0]) cylinder(d = 2.8, h = 1.3, $fn = 24);

module face_text(t, size, y, style = "Medium") translate([0, y, back_z + case_t - 0.02]) linear_extrude(0.06)
    text(t, size = size, font = str("Jost:style=", style), halign = "center", valign = "center");

// ---------- sport band ----------
band_w = 22;
band_t = 3;
// centreline in the y-z plane on the +y side: out of the lug, over the seat edge, down the face, onto the table
band_path = [[21, lug_z], [23, lug_z - 0.4], [25, lug_z - 2], [26.2, lug_z - 4.8], [26.5, H - 1],
             [26.8, H - 8], [30.4, 6], [30.9, 3.2], [32.4, 1.8], [35, band_t / 2]];

function seg_len(p, i) = norm(p[i + 1] - p[i]);
function path_len(p, i = 0) = i >= len(p) - 1 ? 0 : seg_len(p, i) + path_len(p, i + 1);

// band of the given total length (from the lug); ends lying flat on the table get a round tip
module band(total, stud = false) {
    hang = path_len(band_path);
    end_y = band_path[len(band_path) - 1][0] + total - hang;
    intersection() {
        rotate([90, 0, 90]) translate([0, 0, -band_w / 2]) linear_extrude(band_w) {
            for (i = [0:len(band_path) - 2]) hull() for (p = [band_path[i], band_path[i + 1]]) translate(p) circle(d = band_t, $fn = 24);
            hull() for (y = [band_path[len(band_path) - 1][0], end_y]) translate([y, band_t / 2]) circle(d = band_t, $fn = 24);
        }
        // plan outline: full width, rounded tip
        translate([0, 0, -1]) linear_extrude(H + 30) hull() {
            translate([-band_w / 2, 0]) square([band_w, 1]);
            translate([0, end_y - band_w / 2]) circle(d = band_w, $fn = 64);
        }
    }
    if (stud) translate([0, end_y - 9, band_t]) cylinder(d = 3.4, h = 1.2, $fn = 24);
}

module band_holes(total, holes) {
    hang = path_len(band_path);
    end_y = band_path[len(band_path) - 1][0] + total - hang;
    for (i = [1:holes]) translate([0, end_y - 8 - 6.5 * (i - 1), band_t / 2]) cylinder(d = 2.6, h = band_t + 1, center = true, $fn = 20);
}

// ---------- puck and cable ----------
puck_face = 1.8; // white top face
module puck_body() translate([0, 0, H - pocket_depth]) cylinder(d = puck_d, h = puck_h - puck_face);
module puck_top() difference() {
    translate([0, 0, puck_top_z - puck_face]) cylinder(d = puck_d - 0.6, h = puck_face);
    // shallow dish for the dome
    translate([0, 0, puck_top_z + 60 - 0.8]) sphere(r = 60, $fn = 192);
}

// cubic Bézier, sampled
function bez(p0, p1, p2, p3, t) = pow(1 - t, 3) * p0 + 3 * pow(1 - t, 2) * t * p1 + 3 * (1 - t) * t * t * p2 + pow(t, 3) * p3;
function bez_pts(c, n = 16) = [for (i = [0:n]) bez(c[0], c[1], c[2], c[3], i / n)];
function diag(r, z) = [r / sqrt(2), r / sqrt(2), z];

cable_z = H - pocket_depth + cable_exit; // the cable leaves the side of the puck, no strain relief
cable_pts = concat(
    [[10, 0, cable_z]],
    // straight out of the side of the seat, then a free arc down to the table
    bez_pts([[B / 2, 0, cable_z], [B / 2 + 25, 0, cable_z], [B / 2 + 32, 0, cable_d / 2], [B / 2 + 60, 0, cable_d / 2]], 20),
    bez_pts([[B / 2 + 60, 0, cable_d / 2], [B / 2 + 90, 0, cable_d / 2], [110, 60, cable_d / 2], [120, 140, cable_d / 2]], 16),
    bez_pts([[120, 140, cable_d / 2], [125, 180, cable_d / 2], [150, 210, cable_d / 2], [140, 260, cable_d / 2]], 16));

module cable() for (i = [0:len(cable_pts) - 2]) hull() for (p = [cable_pts[i], cable_pts[i + 1]]) translate(p) sphere(d = cable_d, $fn = 20);

// ---------- output ----------
if (prop == "stool") stool();
if (prop == "puck_body") puck_body();
if (prop == "puck_top") puck_top();
if (prop == "cable") cable();
if (prop == "case") watch_case();
if (prop == "glass") glass();
if (prop == "crown") crown();
if (prop == "button") side_button();
if (prop == "face_time") face_text("10:09", 8, -1);
if (prop == "face_date") face_text("SAT 25", 3, 9, "SemiBold");
// long piece with holes lies on the table in front, the pin piece behind
if (prop == "band_front") mirror([0, 1, 0]) difference() { band(118); band_holes(118, 6); }
if (prop == "band_back") band(88, stud = true);
