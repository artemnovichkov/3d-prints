// Shadow Pumpkins: flat pumpkin pendants whose shadow shows one word with light from the left
// and another with light from the right.
//
// Every slat is split lengthwise. Light from the left is blocked by the right half of the slat
// to the left of each gap, so raising the right halves inside a word turns that word solid in
// the shadow. The left halves do the same for light from the right.
// Geometry follows the ShadowSays pumpkin (shadowsays.vercel.app).

/* [Your words] */
// Pick "Your words" to use the two words below
part = "custom"; // [custom:Your words, boo-eek:BOO / EEK, bat-cat:BAT / CAT, rip-bye:RIP / BYE, omg-run:OMG / RUN, all:All four]
// Shown in the shadow with light from the left. 3-4 capital letters read best
left_text = "BOO";
// Shown in the shadow with light from the right
right_text = "EEK";

/* [Text] */
// A heavy font reads best. Text widths below are measured for Nunito Black
font = "Nunito:style=Black";
// Letter size, mm. Longer words shrink to fit text_max_w
text_size = 18;
// Widest a word may be, mm
text_max_w = 60;
// Grows the letters, mm
bold = 0.6;
// Moves the words up (+) or down (-), mm
text_offset = 0;

/* [Slats] */
slat_w = 1.2;
gap_w = 0.8;
low_h = 0.6;
high_h = 1.6;
// Away from the words a slat is only this wide: a brighter shadow around the words. 0 = full slats
spine_w = 0;

/* [Pumpkin] */
width = 76;
frame_w = 1.2;
frame_h = 1.2;
// Lobe lines inside the pumpkin
ribs = true;
rib_w = 1.2;
hole_d = 4;

/* [Hanging] */
// Two small stem holes: a garland string goes in through one and out through the other, so the pumpkin hangs flat along it and sways. One hole: for a hook or nail
hang = "garland"; // [garland:Two holes, single:One hole]
// Garland hole size, mm. The holes sit this far apart
garland_hole_d = 2.4; // [1.5:0.1:3]

/* [Hidden] */
layer = "";
$fn = 96;
pairs = [["boo-eek", "BOO", "EEK"], ["bat-cat", "BAT", "CAT"], ["rip-bye", "RIP", "BYE"], ["omg-run", "OMG", "RUN"]];
pitch = slat_w + gap_w;
k = width / 76;
body_top = 0.35 * width;
// lobes, back to front, as fractions of the width: [cx, cy, rx, ry]
lobes = [[-0.31, 0, 0.19, 0.3], [0.31, 0, 0.19, 0.3], [-0.18, 0.005, 0.2, 0.335], [0.18, 0.005, 0.2, 0.335], [0, 0, 0.165, 0.35]];
// stem outline at width 76 mm, y from the body top (Catmull-Rom through the ShadowSays points)
stem = [[-6.800, -6.000], [-6.719, -5.598], [-6.612, -5.072], [-6.484, -4.445], [-6.341, -3.741], [-6.186, -2.981], [-6.025, -2.188], [-5.863, -1.384], [-5.704, -0.593], [-5.553, 0.164], [-5.416, 0.863], [-5.296, 1.483], [-5.200, 2.000], [-5.122, 2.426], [-5.055, 2.792], [-4.997, 3.106], [-4.948, 3.378], [-4.908, 3.615], [-4.875, 3.825], [-4.849, 4.017], [-4.830, 4.200], [-4.816, 4.381], [-4.806, 4.569], [-4.802, 4.773], [-4.800, 5.000], [-4.805, 5.245], [-4.820, 5.497], [-4.844, 5.752], [-4.874, 6.007], [-4.910, 6.262], [-4.950, 6.512], [-4.993, 6.757], [-5.037, 6.993], [-5.081, 7.217], [-5.124, 7.428], [-5.164, 7.623], [-5.200, 7.800], [-5.235, 7.960], [-5.271, 8.106], [-5.309, 8.241], [-5.348, 8.363], [-5.387, 8.474], [-5.425, 8.575], [-5.462, 8.666], [-5.496, 8.748], [-5.528, 8.822], [-5.556, 8.888], [-5.581, 8.947], [-5.329, 8.978], [-4.991, 8.947], [-4.594, 8.909], [-4.148, 8.867], [-3.664, 8.821], [-3.150, 8.775], [-2.617, 8.730], [-2.074, 8.689], [-1.531, 8.653], [-0.998, 8.625], [-0.484, 8.607], [0.000, 8.600], [0.484, 8.607], [0.998, 8.625], [1.531, 8.653], [2.074, 8.689], [2.617, 8.730], [3.150, 8.775], [3.664, 8.821], [4.148, 8.867], [4.594, 8.909], [4.991, 8.947], [5.329, 8.978], [5.581, 8.947], [5.556, 8.888], [5.528, 8.822], [5.496, 8.748], [5.462, 8.666], [5.425, 8.575], [5.387, 8.474], [5.348, 8.363], [5.309, 8.241], [5.271, 8.106], [5.235, 7.960], [5.200, 7.800], [5.164, 7.623], [5.124, 7.428], [5.081, 7.217], [5.037, 6.993], [4.993, 6.757], [4.950, 6.512], [4.910, 6.262], [4.874, 6.007], [4.844, 5.752], [4.820, 5.497], [4.805, 5.245], [4.800, 5.000], [4.802, 4.773], [4.806, 4.569], [4.816, 4.381], [4.830, 4.200], [4.849, 4.017], [4.875, 3.825], [4.908, 3.615], [4.948, 3.378], [4.997, 3.106], [5.055, 2.792], [5.122, 2.426], [5.200, 2.000], [5.296, 1.483], [5.416, 0.863], [5.553, 0.164], [5.704, -0.593], [5.863, -1.384], [6.025, -2.188], [6.186, -2.981], [6.341, -3.741], [6.484, -4.445], [6.612, -5.072], [6.719, -5.598]];
stem_hole = 5;
// advance widths of Nunito Black per 1 mm of text size; other characters count as 0.8
chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!?-' ";
char_w = [1.009, 0.929, 0.910, 1.040, 0.813, 0.765, 0.989, 1.040, 0.413, 0.516, 0.942, 0.774, 1.169, 1.002, 1.068, 0.894, 1.068, 0.934, 0.862, 0.852, 0.990, 0.982, 1.492, 0.924, 0.853, 0.827, 0.751, 0.821, 0.640, 0.821, 0.735, 0.531, 0.828, 0.802, 0.372, 0.380, 0.767, 0.460, 1.193, 0.802, 0.796, 0.821, 0.821, 0.573, 0.657, 0.563, 0.795, 0.717, 1.149, 0.757, 0.715, 0.644, 0.794, 0.794, 0.794, 0.794, 0.794, 0.794, 0.794, 0.794, 0.794, 0.794, 0.359, 0.633, 0.589, 0.355, 0.378];
function glyph_w(c) = let(k = search(c, chars)[0]) is_num(k) ? char_w[k] : 0.8;
function word_w(t, i = 0) = i >= len(t) ? 0 : glyph_w(t[i]) + word_w(t, i + 1);
// both words share one size: the text size, or smaller if the wider word would pass text_max_w
function fit_size(a, b) = min(text_size, (text_max_w - 2 * bold) / max(word_w(a), word_w(b), 0.01));
// gaps narrower than twice this between lobe lines and frame are filled
rib_close = 0.6;

module lobe(l, d = 0) {
    translate([l[0] * width, l[1] * width]) scale([l[2] * width + d, l[3] * width + d]) circle(r = 1);
}

module body(d = 0) {
    for (l = lobes) lobe(l, d);
}

// outline, lobe lines and stem
module frame_2d() {
    difference() {
        union() {
            intersection() {
                offset(r = -rib_close) offset(r = rib_close) union() {
                    difference() { body(); body(-frame_w); }
                    if (ribs) for (i = [0 : len(lobes) - 1]) difference() {
                        lobe(lobes[i]);
                        lobe(lobes[i], -rib_w);
                        if (i < len(lobes) - 1) for (j = [i + 1 : len(lobes) - 1]) lobe(lobes[j]);
                    }
                }
                body();
            }
            difference() {
                translate([0, body_top]) scale(k) polygon(stem);
                body(-frame_w);
            }
        }
        holes_2d();
    }
}

module holes_2d() {
    translate([0, body_top + stem_hole * k])
        if (hang == "single") circle(d = hole_d, $fn = 48);
        else for (s = [-1, 1]) translate([s * garland_hole_d, 0]) circle(d = garland_hole_d, $fn = 48);
}

// side 0: left halves, 1: right halves
module halves_2d(side) {
    n = ceil(width / 2 / pitch) + 1;
    intersection() {
        body(-frame_w / 2);
        for (i = [-n : n])
            translate([i * pitch - slat_w / 2 + side * slat_w / 2, -width / 2]) square([slat_w / 2, width]);
    }
}

module word_2d(t, size) {
    translate([0, text_offset]) offset(r = bold) text(t, size = size, font = font, halign = "center", valign = "center");
}

module spines_2d() {
    n = ceil(width / 2 / pitch) + 1;
    intersection() {
        body(-frame_w / 2);
        for (i = [-n : n]) translate([i * pitch - spine_w / 2, -width / 2]) square([spine_w, width]);
    }
}

module low_2d(left, right) {
    if (spine_w > 0) {
        spines_2d();
        // a tall half closes the gap next to it, up to the half of the next slat, which must be
        // full: right halves left of a right-light word, left halves right of a left-light word
        reach = pitch - slat_w / 2;
        intersection() { halves_2d(1); translate([-reach, 0]) word_2d(right, fit_size(left, right)); }
        intersection() { halves_2d(0); translate([reach, 0]) word_2d(left, fit_size(left, right)); }
    } else { halves_2d(0); halves_2d(1); }
}

module high_2d(left, right) {
    intersection() { halves_2d(1); word_2d(left, fit_size(left, right)); }
    intersection() { halves_2d(0); word_2d(right, fit_size(left, right)); }
}

// layer: "" = the 3D pendant; "frame", "low" or "high" = that layer in 2D, e.g. as DXF for Fusion
module pendant(left, right) {
    if (layer == "frame") frame_2d();
    else if (layer == "low") difference() { low_2d(left, right); holes_2d(); }
    else if (layer == "high") difference() { high_2d(left, right); holes_2d(); }
    else {
        linear_extrude(frame_h) frame_2d();
        linear_extrude(low_h) difference() { low_2d(left, right); holes_2d(); }
        linear_extrude(high_h) difference() { high_2d(left, right); holes_2d(); }
    }
}

if (part == "all") {
    for (i = [0 : 3]) translate([(i % 2 - 0.5) * (width + 5), (0.5 - floor(i / 2)) * (0.85 * width + 5)])
        pendant(pairs[i][1], pairs[i][2]);
} else if (part == "custom") {
    pendant(left_text, right_text);
} else {
    for (p = pairs) if (p[0] == part) pendant(p[1], p[2]);
}
