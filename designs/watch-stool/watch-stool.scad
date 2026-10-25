// Watch Stool — a tiny plastic street-food stool that holds the Apple Watch charger.
// Author: Artem Novichkov · artemnovichkov.com
// Compatible with OpenSCAD 2021.01 (MakerWorld Parametric Model Maker)

/* [Charger] */
// Diameter of your charging puck, mm: 28 per the iFixit teardown, check yours with calipers
puck_d = 28.0; // [26:0.1:30]
// Thickness of the puck, mm: 6.7 per the iFixit teardown
puck_h = 6.7; // [5:0.1:10]
// How far the puck sticks out above the seat, mm. Flush is fine: the dome on the watch back keeps the watch off the seat
puck_proud = 0; // [0:0.25:2]
// Cable diameter, mm: the braided cable is about 4 mm, and the clips in the leg grip it
cable_d = 4.0; // [2.5:0.1:5]
// Height of the cable centre above the bottom of the puck, mm (the cable leaves the side of the puck)
cable_exit = 3.35; // [1.5:0.05:6]
// Diagonal of the USB-C plug's housing, mm: the plug goes down through the hole in the pocket floor
plug_w = 14; // [8:0.5:20]

/* [Fit] */
// How much the crush ribs squeeze the puck, mm: raise it if the puck lifts off with the watch
grip = 0.5; // [0:0.05:1]
// How much narrower than the cable the clips in the leg are, mm (a braided cable barely squashes)
clip_squeeze = 0.4; // [0.2:0.1:1.2]

/* [Stool] */
// Total height, mm
height = 64; // [45:1:100]
// Width at the top of the legs, mm (the seat is 2.4 mm wider)
top_w = 48; // [42:0.5:60]
// Width at the feet, mm: wider is steadier
bottom_w = 58; // [46:0.5:80]
// Wall thickness, mm
wall = 2.4; // [1.6:0.2:4]

/* [Output] */
// stool and fit_test come in print orientation, upside down
part = "stool"; // [stool:Stool, fit_test:Fit test (seat only), all:Preview with charger and watch]

/* [Colours (preview only)] */
stool_color = "#D7262E";

/* [Hidden] */
$fn = 96;
H = height;
T = top_w;
B = bottom_w;
corner = 4;                     // corner chamfer of the legs
leg = 11;                       // leg width seen on each face
lip = 1.2;                      // seat overhang beyond the legs
lip_h = 7;                      // height of the seat edge
top_ch = 1.6;                   // chamfer of the seat's top edge, so bands don't crease
pocket_depth = puck_h - puck_proud;
floor_t = 1.6;                  // seat under the puck, at the pocket wall
seat_t = pocket_depth + floor_t; // solid seat, also the interior ceiling
pocket_d = puck_d + 0.8;        // crush ribs fill the gap
pocket_r = pocket_d / 2;
rib_d = puck_d - grip;          // diameter across rib tips
// no flat floor: the seat prints face down, so the puck rests on a 45° ledge that needs no bridge
rest_r = puck_d / 2 - 0.3;      // the puck's rounded bottom edge rests on the ledge here
ledge_top = H - pocket_depth + (pocket_r - rest_r); // where the ledge meets the pocket wall
hole_r = max(plug_w / 2 + 1, pocket_r - 4); // the USB-C plug and a finger go through
ledge_low = ledge_top - (pocket_r - hole_r); // inner edge of the ledge
ledge_t = 2.3;                  // vertical thickness of the ledge
run_clip = 6;                   // the cable runs straight in a clip this long after the pocket, so its bend doesn't lift the puck
band_h = seat_t + 5;            // wall band below the seat, above the windows
arch_h = round(0.13 * H);       // arch between the feet
rail = round(0.08 * H);         // bottom rail and middle rail
win_r = 3.5;
arch_r = 4;
run_top = H - pocket_depth + cable_exit + cable_d / 2 + 0.3; // top of the hidden cable run
skin = H - run_top;             // seat top over the cable run
if (skin < 0.8) echo(str("WARNING: only ", skin, " mm of seat over the cable: lower cable_exit or puck_proud"));
post_d = 8;                     // solid post inside each leg: weight low down, room for the cable channel
chan_d = cable_d + 0.4;         // cable channel inside the back-right leg
clips = [12, 28, 44];           // clip centres, mm above the table
clip_len = 5;
exit_h = 5;                     // cut in the foot where the cable leaves

function s(z) = B + (T - B) * z / H;    // leg outline width at height z
function hw(z) = s(z) / 2 - leg;        // half-width of a window at height z
function d_in(z) = (s(z) - corner) / sqrt(2) - wall; // centre to the inner corner of a leg, along the diagonal
function d_chan(z) = d_in(z) - 1;       // cable channel centre, tucked into the corner

module csq(size, c = corner) {
    a = size / 2;
    polygon([[a - c, -a], [a, c - a], [a, a - c], [a - c, a],
             [c - a, a], [-a, a - c], [-a, c - a], [c - a, -a]]);
}
module slice(z, size, inset = 0) translate([0, 0, z]) linear_extrude(0.01) offset(delta = -inset) csq(size);

module trapezoid(z0, z1, r) offset(r = r) offset(delta = -r)
    polygon([[-hw(z0), z0], [hw(z0), z0], [hw(z1), z1], [-hw(z1), z1]]);

// cuts a 2D shape in the x-z plane through the +y face
module through_face() rotate([90, 0, 0]) translate([0, 0, -B]) linear_extrude(B) children();

module windows(split) {
    w0 = arch_h + rail;
    w1 = H - band_h;
    if (split) {
        mid = (w0 + w1) / 2;
        trapezoid(w0, mid - rail / 2, win_r);
        trapezoid(mid + rail / 2, w1, win_r);
    } else trapezoid(w0, w1, win_r);
}

module shell() {
    hull() {
        slice(0, B);
        slice(H - lip_h, s(H - lip_h));
    }
    hull() {
        slice(H - lip_h, s(H - lip_h));
        slice(H - lip_h + lip, T + 2 * lip);
        slice(H - top_ch, T + 2 * lip);
        slice(H - 0.01, T + 2 * lip - 2 * top_ch);
    }
}

module ledge() rotate_extrude() polygon([[hole_r, ledge_low - ledge_t], [pocket_r + 1, ledge_top - ledge_t + 1],
                                          [pocket_r + 1, H - seat_t + 3], [hole_r, H - seat_t + 3]]);

module pocket() {
    difference() {
        translate([0, 0, ledge_top]) cylinder(r = pocket_r, h = H - ledge_top + 1);
        // crush ribs, kept clear of the cable run at 45°
        for (a = [15:60:359]) rotate(a) translate([rib_d / 2, -0.6, ledge_top - 1]) cube([pocket_d, 1.2, H - ledge_top + 2]);
    }
    rotate_extrude() polygon([[0, ledge_top + 0.01], [pocket_r, ledge_top + 0.01], [hole_r, ledge_low], [0, ledge_low]]);
    translate([0, 0, ledge_low - ledge_t - 1]) cylinder(r = hole_r, h = ledge_t + 1.01);
    // lead-in chamfer: also eats the elephant foot, since the seat prints face down
    translate([0, 0, H - 0.8]) cylinder(d1 = pocket_d, d2 = pocket_d + 1.6, h = 0.81);
}

top_z = H - seat_t;              // underside of the seat

// along the diagonal of one corner: x is the distance from the centre
module diag_line(x0, z0, x1, z1, d) hull() {
    translate([x0, 0, z0]) cylinder(d = d, h = 0.01);
    translate([x1, 0, z1]) cylinder(d = d, h = 0.01);
}

module posts() intersection() {
    shell();
    for (a = [45:90:359]) rotate(a) diag_line(d_in(0) - 1, 0, d_in(top_z) - 1, top_z + 0.5, post_d);
}

// the cable leaves the puck sideways under the seat, so the top shows only the round pocket;
// the run is open underneath: the plug goes down the hole in the floor, the cable slides
// along the slit in the floor to the edge, and the puck goes in tilted, cable first
module cable_run() rotate(45) {
    zc = H - pocket_depth + cable_exit;
    // slit in the ledge, from the plug hole to the pocket wall
    hull() for (x = [0, pocket_r + 0.5])
        translate([x, -(cable_d + 1) / 2, ledge_low - ledge_t - 1]) cube([0.01, cable_d + 1, ledge_top - ledge_low + ledge_t + 1.01]);
    // open run: where the cable gets in at the pocket, and where it bends down to the leg
    for (span = [[pocket_r - 1, pocket_r + 0.5], [pocket_r + run_clip, d_chan(top_z)]]) hull() for (x = span)
        translate([x, -(cable_d + 1) / 2, top_z - 1]) cube([0.01, cable_d + 1, run_top - top_z + 1]);
    // clip: the cable presses up past a narrow opening into a round channel
    hull() for (x = [pocket_r - 1, pocket_r + run_clip]) translate([x, 0, zc]) rotate([0, 90, 0]) cylinder(d = cable_d + 0.4, h = 0.01);
    hull() for (x = [pocket_r + 0.5, pocket_r + run_clip])
        translate([x, -(cable_d - clip_squeeze) / 2, top_z - 1]) cube([0.01, cable_d - clip_squeeze, zc - top_z + 1]);
    // funnel into the channel, so the cable doesn't rub on the edge
    translate([d_chan(top_z), 0, top_z - 3]) cylinder(d1 = chan_d, d2 = chan_d + 1.6, h = 3.01);
}

// channel down the back-right leg, open towards the inside so the cable presses in;
// narrower at the clips so it stays put
module cable_channel() rotate(45) {
    diag_line(d_chan(-1), -1, d_chan(top_z), top_z, chan_d);
    zs = concat([-1], [for (c = clips) each [c - clip_len / 2, c + clip_len / 2]], [top_z]);
    for (i = [0:len(zs) - 2]) {
        w = i % 2 == 0 ? cable_d + 0.2 : cable_d - clip_squeeze;
        hull() for (z = [zs[i], zs[i + 1]]) translate([d_chan(z) - 6, -w / 2, z]) cube([6, w, 0.01]);
    }
    // the cable leaves through the foot, low at the table
    hull() for (x = [d_chan(0), d_chan(0) + 10]) {
        translate([x, 0, -1]) cylinder(d = cable_d + 0.4, h = 0.01);
        translate([x, 0, exit_h - (cable_d + 0.4) / 2]) rotate([0, 90, 0]) cylinder(d = cable_d + 0.4, h = 0.01);
    }
}

module stool() difference() {
    union() {
        difference() {
            shell();
            hull() {
                slice(-1, B, wall);
                slice(top_z, s(top_z), wall);
            }
        }
        posts();
        ledge();
    }
    for (a = [0:90:270]) rotate(a) through_face() {
        windows(a % 180 == 90);
        trapezoid(-2 * arch_r, arch_h, arch_r);
    }
    pocket();
    cable_run();
    cable_channel();
}

module print_flip() translate([0, 0, H]) rotate([180, 0, 0]) children();

// ---------- preview props ----------
module puck_preview() color("#EDEDED") translate([0, 0, H - pocket_depth]) cylinder(d = puck_d, h = puck_h);

module cable_preview() color("#F4F4F4") rotate(45) {
    cz = H - pocket_depth + cable_exit;
    pts = [[0, 0, cz], [pocket_r + run_clip, 0, cz], [d_chan(top_z - 6), 0, top_z - 6], [d_chan(4), 0, 4],
           [d_chan(0) + 4, 0, 1.6], [d_chan(0) + 40, 0, 1.6]];
    for (i = [0:len(pts) - 2]) hull() for (p = [pts[i], pts[i + 1]]) translate(p) sphere(d = cable_d, $fn = 16);
}

module watch_preview() {
    z = H + puck_proud;
    color("#E7C9A9") translate([0, 0, z]) linear_extrude(10.7) offset(r = 9) square([39 - 18, 46 - 18], center = true);
    color("#1E1E1E") translate([0, 0, z + 10.7]) linear_extrude(0.4) offset(r = 8) square([35 - 16, 42 - 16], center = true);
    // bands draped over the front and back
    color("#2B2B2B") for (m = [0, 1]) mirror([0, m, 0]) {
        translate([-11, 21, z + 2]) cube([22, (T + 2 * lip) / 2 - 21 + 1, 3]);
        translate([0, (T + 2 * lip) / 2 + 1, z + 2]) rotate([-8, 0, 0]) translate([-11, 0, -55]) cube([22, 3, 58]);
    }
}

if (part == "stool") color(stool_color) print_flip() stool();
if (part == "fit_test") color(stool_color) print_flip() intersection() {
    stool();
    translate([-B, -B, ledge_low - ledge_t - 0.5]) cube([2 * B, 2 * B, H]);
}
if (part == "all") {
    color(stool_color) stool();
    puck_preview();
    cable_preview();
    watch_preview();
}
