// Ringlet — customizable perpetual ring calendar
// Put a ring on the weekday, the date and the month.
// Author: Artem Novichkov · artemnovichkov.com
// Compatible with OpenSCAD 2021.01 (MakerWorld Parametric Model Maker)

/* [What to generate] */
// Which part to render. Export "base" and "labels" separately for two-colour printing
part = "all"; // [all:Everything, base:Base only, labels:Labels only, rings:Rings only]
// How many marker rings
ring_count = 3; // [1:1:6]

/* [Labels] */
// Language of weekday and month labels
language = "en"; // [en:English, ru:Russian, custom:Custom]
// First day of the week
week_start = "mon"; // [mon:Monday, sun:Sunday]
// Custom weekday labels, comma separated (7 items, starting from Monday)
custom_days = "mo,tu,we,th,fr,sa,su";
// Custom month labels, comma separated (12 items)
custom_months = "1,2,3,4,5,6,7,8,9,10,11,12";
// Font name (Google Fonts names work on MakerWorld)
font = "Nunito:style=Bold";
// Text height, mm
text_size = 3.5; // [2.5:0.25:7]
// Inlay: flush text for 2-colour print. Raised: text stands above the peg
label_style = "inlay"; // [inlay:Inlay (flush), raised:Raised]
// Inlay depth or raised height, mm
text_depth = 0.4; // [0.2:0.1:1.2]

/* [Pegs] */
// Peg diameter, mm
peg_d = 12; // [8:0.5:20]
// Peg height above the plate, mm
peg_h = 4; // [2:0.5:8]
// Chamfer on the top edge of each peg, mm
peg_chamfer = 0.4; // [0:0.1:1]
// Extra space between a worn ring and the next peg, mm
peg_spacing = 1.7; // [0.5:0.1:6]

/* [Plate] */
// Plate thickness, mm
plate_t = 3; // [1.5:0.5:6]
// Border from outer pegs to plate edge, mm
margin = 10; // [3:1:25]
// Extra gap between weekday / date / month blocks, mm
group_gap = 5; // [0:1:15]
// Corner radius, mm
corner_r = 5; // [0:1:15]

/* [Rings] */
// Clearance between ring and peg (tune for your printer), mm
gap = 0.3; // [0.1:0.05:0.8]
// Ring wall thickness, mm
ring_wall = 1.5; // [0.8:0.1:3]
// Ring height, mm
ring_h = 2; // [1:0.5:6]
// Chamfer on inner ring edges, mm
ring_chamfer = 0.3; // [0:0.1:0.8]

/* [Colours (preview only)] */
base_color = "#3f7a46";
text_color = "#f2f2f2";
ring_color = "#f2f2f2";

/* [Hidden] */
$fn = 64;
eps = 0.01;
cols = 7;

// ---------- string helpers ----------
function _sub(s, a, b) = a >= b ? "" : str(s[a], _sub(s, a + 1, b));
function _split(s, sep, start = 0, i = 0) =
    i >= len(s) ? [_sub(s, start, len(s))] :
    s[i] == sep ? concat([_sub(s, start, i)], _split(s, sep, i + 1, i + 1)) :
    _split(s, sep, start, i + 1);
function _trim_l(s, i = 0) = i < len(s) && s[i] == " " ? _trim_l(s, i + 1) : _sub(s, i, len(s));
function split(s) = [for (x = _split(s, ",")) _trim_l(x)];

// ---------- labels ----------
days_en   = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];
days_ru   = ["пн", "вт", "ср", "чт", "пт", "сб", "вс"];
months_en = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
months_ru = ["янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"];

days_mon = language == "ru" ? days_ru : language == "custom" ? split(custom_days) : days_en;
days = week_start == "sun" ? concat([days_mon[6]], [for (i = [0:5]) days_mon[i]]) : days_mon;
months = language == "ru" ? months_ru : language == "custom" ? split(custom_months) : months_en;
dates = [for (i = [1:31]) str(i)];

groups = [days, dates, months];
group_rows = [for (g = groups) ceil(len(g) / cols)];
total_rows = group_rows[0] + group_rows[1] + group_rows[2];
function rows_before(g) = g == 0 ? 0 : g == 1 ? group_rows[0] : group_rows[0] + group_rows[1];

// ---------- layout ----------
pitch   = peg_d + 2 * ring_wall + gap + peg_spacing;
plate_w = (cols - 1) * pitch + peg_d + 2 * margin;
plate_l = (total_rows - 1) * pitch + 2 * group_gap + peg_d + 2 * margin;
peg_top = plate_t + peg_h;
ring_od = peg_d + gap + 2 * ring_wall;

function pos(g, i) =
    let(row_from_bottom = total_rows - 1 - (rows_before(g) + floor(i / cols)),
        gaps_below = len(groups) - 1 - g)
    [margin + peg_d / 2 + (i % cols) * pitch,
     margin + peg_d / 2 + row_from_bottom * pitch + gaps_below * group_gap];

// shrink long labels so they stay inside the peg
function fit_size(t) = len(t) <= 3 ? text_size : text_size * 3 / len(t);

// ---------- geometry ----------
module plate() {
    r = min(corner_r, plate_w / 2 - eps, plate_l / 2 - eps);
    linear_extrude(plate_t)
        if (r > 0) offset(r = r) offset(delta = -r) square([plate_w, plate_l]);
        else square([plate_w, plate_l]);
}

module peg() {
    c = min(peg_chamfer, peg_h / 2, peg_d / 4);
    cylinder(d = peg_d, h = peg_h - c);
    if (c > 0) translate([0, 0, peg_h - c]) cylinder(d1 = peg_d, d2 = peg_d - 2 * c, h = c);
}

module pegs() {
    for (g = [0:len(groups) - 1], i = [0:len(groups[g]) - 1])
        translate([pos(g, i)[0], pos(g, i)[1], plate_t]) peg();
}

module label_2d(t) {
    text(t, size = fit_size(t), font = font, halign = "center", valign = "center");
}

// z0 / h: where the text solid starts and how tall it is
module labels_at(z0, h) {
    for (g = [0:len(groups) - 1], i = [0:len(groups[g]) - 1])
        translate([pos(g, i)[0], pos(g, i)[1], z0])
            linear_extrude(h) label_2d(groups[g][i]);
}

module labels() {
    if (label_style == "inlay") labels_at(peg_top - text_depth, text_depth);
    else labels_at(peg_top - eps, text_depth + eps);
}

module base() {
    difference() {
        union() { plate(); pegs(); }
        if (label_style == "inlay") labels_at(peg_top - text_depth, text_depth + 1);
    }
}

module ring() {
    id = peg_d + gap;
    c = min(ring_chamfer, ring_h / 2, ring_wall / 2);
    difference() {
        cylinder(d = ring_od, h = ring_h);
        translate([0, 0, -eps]) cylinder(d = id, h = ring_h + 2 * eps);
        if (c > 0) {
            translate([0, 0, -eps]) cylinder(d1 = id + 2 * c + 2 * eps, d2 = id, h = c + eps);
            translate([0, 0, ring_h - c]) cylinder(d1 = id, d2 = id + 2 * c + 2 * eps, h = c + eps);
        }
    }
}

module rings(x0) {
    for (i = [0:ring_count - 1])
        translate([x0 + ring_od / 2, ring_od / 2 + i * (ring_od + 3), 0]) ring();
}

// ---------- output ----------
if (part == "all" || part == "base")   color(base_color) base();
if (part == "all" || part == "labels") color(text_color) labels();
if (part == "all" || part == "rings")  color(ring_color) rings(part == "all" ? plate_w + 5 : 0);
