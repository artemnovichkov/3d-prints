// Render scenes for README / MakerWorld images: the calendar with rings set to a date.
// Not printable. Accepts the same -D overrides as ringlet-calendar.scad (language, week_start, ...).
include <../ringlet-calendar.scad>

part = "none"; // silence the included file's own output

/* [Scene] */
// Indices into the weekday / date / month groups (0-based)
scene_day = 4;    // fri with week_start = "mon"
scene_date = 12;  // 13
scene_month = 9;  // oct

module ring_on(g, i) {
    translate([pos(g, i)[0], pos(g, i)[1], plate_t]) ring();
}

translate([-plate_w / 2, -plate_l / 2, 0]) {
    color(base_color) base();
    color(text_color) labels();
    color(ring_color) {
        ring_on(0, scene_day);
        ring_on(1, scene_date);
        ring_on(2, scene_month);
    }
}
