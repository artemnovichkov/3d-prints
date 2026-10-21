// Typewriter Kindle dock — your e-reader stands in a tiny typewriter like a sheet of paper.
// Author: Artem Novichkov · artemnovichkov.com
// Compatible with OpenSCAD 2021.01 (MakerWorld Parametric Model Maker)

/* [E-reader] */
// Your e-reader model
device = "pw6"; // [pw3:Kindle Paperwhite 3 (2015), pw4:Kindle Paperwhite 4 (2018), pw5:Kindle Paperwhite 5 (2021), pw6:Kindle Paperwhite 6 (2024), custom:Custom size]
// Custom width, mm
custom_width = 127.6; // [104:0.1:160]
// Custom thickness, mm
custom_thickness = 7.8; // [5:0.1:16]
// Extra thickness of a case or cover, mm (0 = bare device)
case_extra = 0; // [0:0.5:8]
// Backward lean, degrees
tilt = 10; // [5:1:18]

/* [Fit] */
// Gap in front of and behind the device, mm
clearance = 0.4; // [0.2:0.1:1.5]
// Gap on each side of the device, mm (printed slots come out narrower than modelled)
side_clearance = 0.5; // [0.2:0.1:2]
// Gap in the roller's dovetail, mm: raise it if the roller is hard to slide on
dt_gap = 0.15; // [0.05:0.05:0.4]

/* [Colours (preview only)] */
body_color = "#DE4343";
roller_color = "#000000";

/* [Hidden] */
// Parametric Model Maker builds its plates from mw_plate_N() below and would
// add any top-level geometry to every plate, so the default renders nothing.
// Use -D part="all" (or body / roller / fit_test) for local renders and exports.
part = "plates";
// Show the e-reader in the "all" preview
show_device = false;
// Slide the roller out along its axis in the "all" preview, mm
roller_slide = 0;
// How the roller attaches: dovetail slides in from the left, like a carriage return, and can't lift off; pegs need glue
roller_mount = "dovetail"; // [dovetail, pegs]

$fn = 64;

// ---------- device ----------
// [width, height, thickness], mm
dims = device == "pw3" ? [117, 170, 9.1]
     : device == "pw4" ? [116, 167, 8.18]
     : device == "pw5" ? [124.6, 174.2, 8.1]
     : device == "pw6" ? [127.56, 176.72, 7.83]
     : [custom_width, 176.7, custom_thickness];
DW = dims[0] + case_extra;
DH = dims[1] + case_extra;
DT = dims[2] + case_extra;
SW = DW + 2 * side_clearance; // slot width
ST = DT + 2 * clearance;      // slot thickness

// ---------- body ----------
W = SW + 5;                   // body width
F = -46;                      // front face, y
R = 55;                       // back face, y: deep enough that the device can't tip the dock back
back_r = 12;                  // rounded rear top edge, like a typewriter's back cover
HF = 9;                       // height at the front
HB = 24;                      // height of the flat top
YS = -4;                      // where the keyboard slope meets the flat top
SY = 10;                      // front of the slot, y
SZ = 13;                      // slot floor, z: the roller top stays at the bottom of the screen
pad = 15;                     // device rests on two pads; the middle is relieved for buttons and ports

// ---------- keys and roller ----------
key_d = 9;                    // cap diameter
key_pitch = 11;
stem_d = 4.5;
cap_t = 1.8;                  // cap thickness, above a 45° cone from the stem
rim = 0.5;                    // raised ring around the cap top
legend_depth = 0.6;
legend_size = 4.2;
legend_font = "Jost:style=Bold";
legend_fit = false;           // shrink W and Q to fit inside the rim (needed for legend_size > 4.2)
row_y = [F + 14.5, F + 25, F + 35.5]; // front (Z) row to back (Q) row; the back row clears the knobs when the roller slides in
space_y = F + 5;              // space bar row
space_l = 58;                 // space bar length
space_w = 7;                  // space bar width
// [x in key pitches, row, legend]; "" is a blank key
key_map = concat(
    [for (i = [0:9]) [i - 4.5, 2, "QWERTYUIOP"[i]]],
    [[-5, 1, ""]], [for (i = [0:8]) [i - 4, 1, "ASDFGHJKL"[i]]], [[5, 1, ""]],
    [[-4.25, 0, ""]], [for (i = [0:6]) [i - 2.75, 0, "ZXCVBNM"[i]]], [[4.5, 0, ""]]
);
// narrow devices drop the blank keys that would stick out past the body sides
keys_fit = [for (k = key_map) if (abs(k[0]) * key_pitch + key_d / 2 <= W / 2 - 1) k];
RR = 6.5;                     // roller radius
RY = 4;                       // roller axis, y
RF = 4;                       // flat under the roller axis (prints flat side down)
RZ = HB + RF;                 // roller axis, z
knob_r = 8.5;
knob_l = 7;
peg_x = 35;
dt_w = 5;                     // dovetail width at the body top
dt_W = 7.4;                   // dovetail width at its top
dt_h = 1.8;                   // dovetail height
dt_x0 = -W / 2 + 2;           // left end of the tongue: the roller stops here

module dovetail(w, W2, h, x0, x1, z0) translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0)
    polygon([[RY - w / 2, z0], [RY + w / 2, z0], [RY + W2 / 2, HB + h], [RY - W2 / 2, HB + h]]);

// Tongue on the body top from x0 to x1, with a detent ridge across it 7 mm from its right end:
// only the end of the groove rides over it, then it clicks into the notch in the groove
module dt_tongue(x0, x1) {
    dovetail(dt_w, dt_W, dt_h, x0, x1, HB - 0.01);
    translate([x1 - 7, RY, HB + dt_h]) rotate([90, 0, 0]) scale([2, 0.6, 1]) cylinder(r = 0.6, h = dt_W - 1, center = true, $fn = 16);
}

// Groove cut into the roller flat: closed at x0 (the tongue's left end), detent notch at xd, open past x1.
// The groove ceiling prints as a bridge, so the notch spans its full width: a round dimple left loose strands.
module dt_groove(x0, xd, x1) {
    translate([xd - 1.5, RY - (dt_W + 2 * dt_gap) / 2, HB + dt_h + dt_gap - 0.01]) cube([3, dt_W + 2 * dt_gap, 0.5]);
    dovetail(dt_w + 2 * dt_gap, dt_W + 2 * dt_gap, dt_h + dt_gap, x0 - dt_gap, x1, HB);
    translate([x0 - dt_gap, RY - dt_w / 2 - dt_gap, HB - 1]) cube([x1 - x0 + dt_gap, dt_w + 2 * dt_gap, 1.01]);
}

function slope_z(y) = HF + (y - F) * (HB - HF) / (YS - F);
function key_top(r) = slope_z(row_y[r] + key_d / 2) + 2.5;

module rbox(s, r = 2) {
    hull() for (x = [r, s[0] - r], y = [r, s[1] - r])
        translate([x, y, 0]) cylinder(r = r, h = s[2]);
}

// local frame of the slot: origin at its front-bottom edge, leaning back
module slot_frame() translate([0, SY, SZ]) rotate([-tilt, 0, 0]) children();

// Typewriter key on a stem: a 45° cone under the cap prints without supports,
// a raised rim around the top and a debossed legend.
module key(top, legend) {
    cone = (key_d - stem_d) / 2;
    difference() {
        union() {
            cylinder(d = stem_d, h = top - cap_t - cone);
            translate([0, 0, top - cap_t - cone]) cylinder(d1 = stem_d, d2 = key_d, h = cone);
            translate([0, 0, top - cap_t]) cylinder(d = key_d, h = cap_t);
            translate([0, 0, top]) difference() {
                cylinder(d = key_d, h = rim);
                translate([0, 0, -1]) cylinder(d = key_d - 1.4, h = rim + 2);
            }
        }
        // W and Q are the widest letters: shrink them to stay inside the rim
        fit = !legend_fit ? 1 : legend == "W" ? 0.85 : legend == "Q" ? 0.95 : 1;
        if (legend != "") translate([0, 0, top - legend_depth]) linear_extrude(legend_depth + 1) scale(fit)
            text(legend, size = legend_size, font = legend_font, halign = "center", valign = "center");
    }
}

module keys() {
    for (k = keys_fit) translate([k[0] * key_pitch, row_y[k[1]], 0]) key(key_top(k[1]), k[2]);
}

module stadium(l, w) hull() for (s = [-1, 1]) translate([s * (l - w) / 2, 0]) circle(d = w);

// Space bar in the same style as the keys: a long cap with a rim on a thin web
module space_bar() {
    top = slope_z(space_y + space_w / 2) + 3.5;
    web = stem_d / 2;
    cone = (space_w - web) / 2;
    translate([0, space_y, 0]) {
        linear_extrude(top - cap_t - cone) stadium(space_l - 2 * cone, web);
        hull() {
            translate([0, 0, top - cap_t - cone]) linear_extrude(0.01) stadium(space_l - 2 * cone, web);
            translate([0, 0, top - cap_t]) linear_extrude(cap_t) stadium(space_l, space_w);
        }
        translate([0, 0, top]) linear_extrude(rim) difference() {
            stadium(space_l, space_w);
            offset(delta = -0.7) stadium(space_l, space_w);
        }
    }
}

// Paper table behind the device, like on a real typewriter: straight where the device
// leans on it, then curling back, so the empty dock still reads as a typewriter.
rest_w = 100;                 // width
rest_t = 2.4;                 // thickness
rest_h = 27;                  // straight part, from the slot floor along the device
rest_r = 40;                  // curl radius
rest_a = min(32, 44 - tilt);  // curl angle, degrees: the curl tip stays within 45° of vertical

module paper_rest() {
    y0 = ST + rest_t / 2;     // centre line of the plate
    module profile() {
        translate([y0 - rest_t / 2, 0]) square([rest_t, rest_h]);
        translate([y0 + rest_r, rest_h]) intersection() {
            difference() { circle(rest_r + rest_t / 2, $fn = 180); circle(rest_r - rest_t / 2, $fn = 180); }
            polygon([[0, 0], [-2 * rest_r, 0], [-2 * rest_r * cos(rest_a), 2 * rest_r * sin(rest_a)]]);
        }
        // rounded top edge
        translate([y0 + rest_r - rest_r * cos(rest_a), rest_h + rest_r * sin(rest_a)]) circle(d = rest_t, $fn = 24);
    }
    slot_frame() translate([-rest_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(rest_w) profile();
}

module body() {
    difference() {
        union() {
            hull() {
                translate([-W / 2, F, 0]) rbox([W, 4, HF], 2);
                translate([-W / 2, YS, 0]) rbox([W, R - back_r - YS, HB], 2);
                translate([-W / 2, YS, 0]) rbox([W, R - YS, HB - back_r], 2);
                translate([-W / 2 + 2, R - back_r, HB - back_r]) rotate([0, 90, 0]) cylinder(r = back_r, h = W - 4);
            }
            paper_rest();
            keys();
            space_bar();
            if (roller_mount == "pegs")
                for (s = [-1, 1]) translate([s * peg_x, RY, HB - 0.01]) cylinder(d = 3, h = 2.5);
            if (roller_mount == "dovetail") dt_tongue(dt_x0, W / 2 - 1);
        }
        slot_frame() {
            translate([-SW / 2, 0, 0]) cube([SW, ST, DH]);
            translate([-SW / 2 + pad, -0.01, -3]) cube([SW - 2 * pad, ST + 0.02, 3.01]);
        }
    }
}

// assembled position; the flat underside sits on the body top at z = HB
module roller() {
    module flat_cut() translate([-W, -50, HB - 50]) cube([2 * W, 100, 50]);
    difference() {
        union() {
            translate([-W / 2, RY, RZ]) rotate([0, 90, 0]) cylinder(r = RR, h = W);
            for (s = [-1, 1]) translate([s * (W / 2 + knob_l / 2), RY, RZ]) rotate([0, 90, 0]) {
                cylinder(r = knob_r, h = knob_l, center = true);
                // grip rings
                for (o = [-2, 2]) translate([0, 0, o]) cylinder(r = knob_r + 0.6, h = 1.2, center = true);
            }
            // fixed carriage return lever, lying in the plane of the flat
            translate([0, 0, HB]) hull() {
                translate([-W / 2 - knob_l, RY, 0]) cylinder(d = 4, h = 4);
                translate([-W / 2 - knob_l - 6, RY - 3, 0]) cylinder(d = 4, h = 4);
            }
            translate([0, 0, HB]) hull() {
                translate([-W / 2 - knob_l - 6, RY - 3, 0]) cylinder(d = 4, h = 4);
                translate([-W / 2 - knob_l - 9, RY - 24, 0]) cylinder(d = 4, h = 4);
            }
            translate([-W / 2 - knob_l - 9, RY - 24, HB]) cylinder(d = 8, h = 4.5);
        }
        flat_cut();
        if (roller_mount == "pegs")
            for (s = [-1, 1]) translate([s * peg_x, RY, HB - 0.01]) cylinder(d = 3.4, h = 3);
        // dovetail groove, open at the right knob and closed at the left: the roller slides on from the left
        if (roller_mount == "dovetail") dt_groove(dt_x0, W / 2 - 8, W / 2 + knob_l + 1);
    }
}

module device_preview() {
    color("#2b2b2e") slot_frame() translate([-DW / 2, clearance, 0])
        rotate([90, 0, 0]) translate([0, 0, -DT]) rbox([DW, DH, DT], 6);
    color("#e9e6dc") slot_frame() translate([-DW / 2 + 9, clearance - 0.3, 21]) cube([DW - 18, 0.4, DH - 30]);
}

// ---------- output ----------
// centre the layout on the origin: MakerWorld puts the origin in the middle of the bed
CY = -(F + R) / 2;
translate([0, CY, 0]) {
    if (part == "all" || part == "body") color(body_color) body();
    if (part == "all") color(roller_color) translate([roller_slide, 0, 0]) roller();
    if (part == "all" && show_device) device_preview();
}
// print orientation: flat side down
if (part == "roller") color(roller_color) translate([0, -RY, -HB]) roller();
// Render helpers (Fusion / Blender scenes): roller and a device mock-up in assembled position
if (part == "roller_placed") translate([0, CY, 0]) roller();
if (part == "device_body") translate([0, CY, 0]) slot_frame() translate([-DW / 2, clearance, 0])
    rotate([90, 0, 0]) translate([0, 0, -DT]) rbox([DW, DH, DT], 6);
if (part == "device_screen") translate([0, CY, 0]) slot_frame()
    translate([-DW / 2 + 9, clearance - 0.3, 21]) cube([DW - 18, 0.4, DH - 30]);
if (part == "device_text") translate([0, CY, 0]) slot_frame() for (i = [0:17])
    translate([-DW / 2 + 16, clearance - 0.45, 32 + i * 7.6]) cube([DW - 32 - (i % 5 == 4 ? 40 : (i % 3) * 6), 0.3, 1.6]);
// Full-width strip of the body around the slot, to check the fit before the full print.
// The slot floor sits 3 mm above the plate; includes the straight part of the paper table.
if (part == "fit_test") color(body_color) translate([0, -SY, -(SZ - 3)]) intersection() {
    body();
    translate([-W, SY - 8, SZ - 3]) cube([2 * W, ST + 14, rest_h + 3]);
}

// ---------- MakerWorld Parametric Model Maker ----------
// PMM calls these itself and builds a multi-plate 3MF; don't call them here.
// Plate 1: body with keys. Plate 2: roller, a second colour at the same heights.
module mw_plate_1() {
    translate([0, CY, 0]) color(body_color) body();
}

module mw_plate_2() {
    color(roller_color) translate([0, -RY, -HB]) roller();
}

module mw_assembly_view() {
    translate([0, CY, 0]) {
        color(body_color) body();
        color(roller_color) roller();
    }
}
