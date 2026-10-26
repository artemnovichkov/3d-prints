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
// Cable diameter, mm: the braided cable is about 4 mm, and the clip under the seat grips it
cable_d = 4.0; // [2.5:0.1:5]
// Height of the cable centre above the bottom of the puck, mm (the cable leaves the side of the puck)
cable_exit = 3.35; // [1.5:0.05:6]
// Diagonal of the USB-C plug's housing, mm: the plug goes down through the hole in the pocket floor
plug_w = 14; // [8:0.5:20]

/* [Fit] */
// How much the crush ribs squeeze the puck, mm: raise it if the puck lifts off with the watch
grip = 0.5; // [0:0.05:1]
// How much narrower than the cable the opening of the clip under the seat is, mm (a braided cable barely squashes)
clip_squeeze = 0.4; // [0.2:0.1:1.2]

/* [Stool] */
// Total height, mm
height = 64; // [45:1:100]
// Width at the top, mm: the seat is the top of the legs, with no overhang
top_w = 48; // [42:0.5:60]
// Width at the feet, mm: wider is steadier, and the more the legs splay, the deeper the stools stack
bottom_w = 64; // [46:0.5:80]
// Wall thickness, mm
wall = 1.6; // [1.6:0.2:4]

/* [Output] */
// stool, fit_test and stack_test come in print orientation, upside down
part = "stool"; // [stool:Stool, fit_test:Fit test (seat only), stack_test:Stack test (seat and the ring that takes it), all:Preview with charger and watch, stack:Preview of three stacked stools]

/* [Colours (preview only)] */
stool_color = "#D7262E";

/* [Hidden] */
$fn = 96;
H = height;
T = top_w;
B = bottom_w;
corner = 4;                     // corner chamfer of the legs
leg = 11;                       // leg width seen on each face
top_bevel = 5;                  // the leg corners widen into bevels this tall at the top corners of the seat
top_bevel_w = 3;                // extra corner chamfer at the very top
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
band_h = seat_t + 5;            // wall band below the seat, above the windows
arch_h = round(0.13 * H);       // arch between the feet
rail = round(0.08 * H);         // bottom rail
win_r = 3.5;
arch_ch = round(0.5 * arch_h);  // 45° chamfers at the top corners of the arch, where it meets the legs
run_top = H - pocket_depth + cable_exit + cable_d / 2 + 0.3; // top of the hidden cable run
skin = H - run_top;             // seat top over the cable run
if (skin < 0.8) echo(str("WARNING: only ", skin, " mm of seat over the cable: lower cable_exit or puck_proud"));
post_d = 8;                     // corner stops under the seat, where the posts used to be
stack_gap = 0.3;                // between the walls of stacked stools

function s(z) = B + (T - B) * z / H;    // leg outline width at height z
function hw(z) = s(z) / 2 - leg;        // half-width of a window at height z
function d_in(z) = (s(z) - corner) / sqrt(2) - wall; // centre to the inner corner of a leg, along the diagonal

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

// one big window on each side, above the bottom rail
module window() trapezoid(arch_h + rail, H - band_h, win_r);

// the legs run straight up into the seat, like a moulded stool: no overhang, sharp straight
// edges, and the leg corners widen into bevels at the corners of the seat
module shell() hull() {
    slice(0, B);
    slice(H - top_bevel, s(H - top_bevel));
    translate([0, 0, H - 0.01]) linear_extrude(0.01) csq(T, corner + top_bevel_w);
}

// opening between the feet, with chamfered top corners
module arch() {
    z0 = -2;
    z1 = arch_h;
    polygon([[-hw(z0), z0], [hw(z0), z0], [hw(z1 - arch_ch), z1 - arch_ch], [hw(z1) - arch_ch, z1],
             [arch_ch - hw(z1), z1], [-hw(z1 - arch_ch), z1 - arch_ch]]);
}

module ledge() rotate_extrude() polygon([[hole_r, ledge_low - ledge_t], [pocket_r + 1, ledge_top - ledge_t + 1],
                                          [pocket_r + 1, H - seat_t + 3], [hole_r, H - seat_t + 3]]);

module pocket() {
    difference() {
        translate([0, 0, ledge_top]) cylinder(r = pocket_r, h = H - ledge_top + 1);
        // crush ribs, either side of the cable run
        for (a = [30:60:359]) rotate(a) translate([rib_d / 2, -0.6, ledge_top - 1]) cube([pocket_d, 1.2, H - ledge_top + 2]);
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

// stools stack like the real ones: each one sits this much higher than the one below. The walls
// need room for their thickness on the slope of the legs, and the seat of the stool below has to
// clear the ledge under the pocket of the one above
stack_step = max((wall + stack_gap) * 2 * H / (B - T), H - (ledge_low - ledge_t) + stack_gap);
echo(str("Stools stack ", stack_step, " mm apart"));

// stops in the corners under the seat: the stool above rests on them with the corners of its seat,
// so the walls never wedge together
module posts() intersection() {
    shell();
    for (a = [45:90:359]) rotate(a) diag_line(d_in(0) - 1, 0, d_in(top_z) - 1, top_z + 0.5, post_d);
    translate([-B, -B, max(0, H - stack_step)]) cube([2 * B, 2 * B, H]);
}

// the cable leaves the side of the puck under the seat and runs straight out of the middle of
// the right side, so nothing bends it inside the stool, and it hangs down to the table in a free
// arc: a stiff cable that lies down by a foot lifts that foot. The run is open underneath: the
// plug goes down the hole in the floor, the cable slides along the slit in the floor to the edge,
// and the puck goes in tilted, cable first
module cable_run() {
    zc = H - pocket_depth + cable_exit;
    // slit in the ledge, from the plug hole to the pocket wall
    hull() for (x = [0, pocket_r + 0.5])
        translate([x, -(cable_d + 1) / 2, ledge_low - ledge_t - 1]) cube([0.01, cable_d + 1, ledge_top - ledge_low + ledge_t + 1.01]);
    // open run where the cable gets in at the pocket
    hull() for (x = [pocket_r - 1, pocket_r + 0.5])
        translate([x, -(cable_d + 1) / 2, top_z - 1]) cube([0.01, cable_d + 1, run_top - top_z + 1]);
    // clip from the pocket out through the side: the cable presses up past a narrow opening
    // into a round channel and stays straight, so its weight doesn't lift the puck
    hull() for (x = [pocket_r - 1, B / 2]) translate([x, 0, zc]) rotate([0, 90, 0]) cylinder(d = cable_d + 0.4, h = 0.01);
    // the opening runs down through the wall to the window, so the cable snaps in from below all the way out
    hull() for (x = [pocket_r + 0.5, B / 2])
        translate([x, -(cable_d - clip_squeeze) / 2, H - band_h - 1]) cube([0.01, cable_d - clip_squeeze, zc - H + band_h + 1]);
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
        window();
        arch();
    }
    pocket();
    cable_run();
}

module print_flip() translate([0, 0, H]) rotate([180, 0, 0]) children();

// ---------- preview props ----------
module puck_preview() color("#EDEDED") translate([0, 0, H - pocket_depth]) cylinder(d = puck_d, h = puck_h);

module cable_preview() color("#F4F4F4") {
    cz = H - pocket_depth + cable_exit;
    // straight out of the side, then a free arc down to the table
    c = [[B / 2, 0, cz], [B / 2 + 25, 0, cz], [B / 2 + 32, 0, cable_d / 2], [B / 2 + 60, 0, cable_d / 2]];
    arc = [for (t = [0:0.05:1]) pow(1 - t, 3) * c[0] + 3 * pow(1 - t, 2) * t * c[1] + 3 * (1 - t) * t * t * c[2] + pow(t, 3) * c[3]];
    pts = concat([[0, 0, cz]], arc, [[B / 2 + 100, 0, cable_d / 2]]);
    for (i = [0:len(pts) - 2]) hull() for (p = [pts[i], pts[i + 1]]) translate(p) sphere(d = cable_d, $fn = 16);
}

module watch_preview() {
    z = H + puck_proud;
    color("#E7C9A9") translate([0, 0, z]) linear_extrude(10.7) offset(r = 9) square([39 - 18, 46 - 18], center = true);
    color("#1E1E1E") translate([0, 0, z + 10.7]) linear_extrude(0.4) offset(r = 8) square([35 - 16, 42 - 16], center = true);
    // bands draped over the front and back
    color("#2B2B2B") for (m = [0, 1]) mirror([0, m, 0]) {
        translate([-11, 21, z + 2]) cube([22, T / 2 - 21 + 1, 3]);
        translate([0, T / 2 + 1, z + 2]) rotate([-8, 0, 0]) translate([-11, 0, -55]) cube([22, 3, 58]);
    }
}

if (part == "stool") color(stool_color) print_flip() stool();
module fit_test() intersection() {
    stool();
    translate([-B, -B, ledge_low - ledge_t - 0.5]) cube([2 * B, 2 * B, H]);
}
if (part == "fit_test") color(stool_color) print_flip() fit_test();
// the top of a stool as a thin cap and, beside it, the ring of the stool above that it goes into:
// push the cap up into the ring, and it should stop on the corner stops with a 0.3 mm gap at the walls
cap_h = 8;
module stack_test_cap() difference() {
    intersection() {
        shell();
        translate([-B, -B, H - cap_h]) cube([2 * B, 2 * B, cap_h]);
    }
    hull() {
        slice(H - cap_h - 1, s(H - cap_h - 1), wall);
        slice(H - 1.2, s(H - 1.2), wall);
    }
    cylinder(r = pocket_r, h = H + 1);
}
module stack_test_ring() difference() {
    z0 = H - stack_step - cap_h - 1;
    intersection() {
        stool();
        translate([-B, -B, z0]) cube([2 * B, 2 * B, top_z - z0]);
    }
    // without the seat, so the ledge under the pocket goes too
    cylinder(r = pocket_r + 1.5, h = H);
}
if (part == "stack_test") color(stool_color) print_flip() {
    translate([-(B / 2 + 3), 0, 0]) stack_test_cap();
    translate([B / 2 + 3, 0, seat_t]) stack_test_ring(); // down onto the plate: the ring ends under the seat
}
if (part == "stack") for (i = [0:2]) translate([0, 0, i * stack_step]) color(stool_color) stool();
if (part == "all") {
    color(stool_color) stool();
    puck_preview();
    cable_preview();
    watch_preview();
}
