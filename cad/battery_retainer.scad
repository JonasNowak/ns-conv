// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/battery_retainer.scad
// Part: Bolt-On Power Bank Retention Strap (Translucent Lilac SLA)
// Purpose:
//   Secures the INIU 45W Slim Power Bank (110 x 68 x 18.5 mm) inside the
//   lower base enclosure over a 1.5mm EVA/Poron foam pad. Bolts into the two
//   external M3 bosses located 4.5mm outside the battery casing so no screw
//   ever approaches the lithium-polymer pouch.
// ============================================================================

include <config.scad>

strap_span_y = pbank_d + 1.0 + 2 * pbank_safe_gap; // 68 + 1 + 9 = 78.0 mm center-to-center
strap_w      = 18.0;
strap_t      = 3.0;

module battery_retainer() {
    difference() {
        union() {
            // Main flat bridge bar with rounded mounting ears
            hull() {
                for (sy = [-strap_span_y/2, strap_span_y/2]) {
                    translate([0, sy, 0])
                        cylinder(d = strap_w, h = strap_t);
                }
            }
            // Side stiffener ribs along the bridge span
            for (sx = [-strap_w/2 + 1.5, strap_w/2 - 3.3]) {
                translate([sx, -pbank_d/2 + 2.0, strap_t - eps])
                    cube([1.8, pbank_d - 4.0, 2.2]);
            }
        }

        // 2x M3 Counterbored Mounting Holes at +-strap_span_y/2
        for (sy = [-strap_span_y/2, strap_span_y/2]) {
            translate([0, sy, -eps])
                cylinder(d = m3_thru_d, h = strap_t + 4.0);
            translate([0, sy, strap_t - 1.5])
                cylinder(d = m3_head_d, h = 2.0);
        }

        // Weight-relief / ventilation slots in center of strap
        for (sy = [-18.0, 0.0, 18.0]) {
            translate([-4.0, sy - 4.5, -eps])
                cube([8.0, 9.0, strap_t + 4.0]);
        }
    }
}

battery_retainer();
