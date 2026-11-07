// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/lid_bezel.scad
// Part: Upper Lid Front Bezel Retainer (Translucent Lilac SLA)
// Features:
//   - Full-width front bezel plate (306 x 162 x 3.0 mm) that frames the
//     Nintendo Switch v1 6.2" capacitive touchscreen & ambient light sensor
//   - Captures the Switch front glass perimeter cleanly without adhesives
//   - Includes dual speaker acoustic slots aligned with the Switch's front
//     stereo speakers
//   - 8x M3 counterbored perimeter mounting holes matching lid_rear.scad
//   - 6x Ø6.2 x 0.8mm shallow recesses for 6x1.5mm silicone closure bumpers
//     so the lid rests gently on the base deck rim without touching keycaps
// ============================================================================

include <config.scad>

lid_boss_pts = [
    [-deck_w/2 + 6.5,  12.0],
    [ deck_w/2 - 6.5,  12.0],
    [-deck_w/2 + 6.5,  81.0],
    [ deck_w/2 - 6.5,  81.0],
    [-deck_w/2 + 6.5,  deck_d - 8.0],
    [-80.0,            deck_d - 8.0],
    [ 80.0,            deck_d - 8.0],
    [ deck_w/2 - 6.5,  deck_d - 8.0]
];

bumper_pts = [
    [-deck_w/2 + 16.0, 22.0],
    [ deck_w/2 - 16.0, 22.0],
    [-deck_w/2 + 16.0, deck_d - 16.0],
    [ 0.0,             deck_d - 16.0],
    [ deck_w/2 - 16.0, deck_d - 16.0],
    [ 0.0,             14.0]
];

module lid_bezel() {
    sw_center_y = sw_bottom_y + sw_core_h/2;

    difference() {
        union() {
            // 1. Main Front Bezel Plate (306 x 162 x 3.0 mm)
            rounded_box_xcenter(deck_w, deck_d, lid_bezel_h, corner_r);

            // 2. Inner Engagement Rim around Switch Front Glass Perimeter (1.2mm lip)
            translate([
                sw_center_x - (sw_glass_w + 4.0)/2,
                sw_center_y - (sw_glass_h + 4.0)/2,
                -1.2
            ])
                difference() {
                    cube([sw_glass_w + 4.0, sw_glass_h + 4.0, 1.2 + eps]);
                    translate([2.2, 2.2, -eps])
                        cube([sw_glass_w - 0.4, sw_glass_h - 0.4, 1.2 + 3*eps]);
                }
        }

        // ====================================================================
        // SUBTRACTIONS (Touchscreen Window, Speaker Slots, M3 Screws, Bumpers)
        // ====================================================================

        // A. Active 6.2" Touchscreen + Bezel Viewing Window (144 x 83 mm with 45-deg bevel)
        translate([
            sw_center_x - (sw_screen_view_w + 6.0)/2,
            sw_center_y - (sw_screen_view_h + 5.0)/2,
            -2.0
        ])
            cube([sw_screen_view_w + 6.0, sw_screen_view_h + 5.0, lid_bezel_h + 4.0]);

        // B. Front Stereo Speaker Acoustic Port Slots + Ambient Light Sensor Window
        for (sx = [-1, 1]) {
            translate([sw_center_x + sx * 52.0 - 7.0, sw_bottom_y + 4.5, -2.0])
                cube([14.0, 3.0, lid_bezel_h + 4.0]);
        }
        // Ambient light sensor aperture (bottom-left of bezel)
        translate([sw_center_x - 71.0, sw_bottom_y + 11.0, -2.0])
            cylinder(d = 5.0, h = lid_bezel_h + 4.0);

        // C. Hinge Leaf Clearance Cutouts at Bottom Spine (Y = 0..16mm)
        for (hx = [-hinge_x_offset, hinge_x_offset]) {
            translate([hx - (hinge_w + 1.0)/2, -eps, -2.0])
                cube([hinge_w + 1.0, 16.5, lid_bezel_h + 4.0]);
        }

        // D. 8x M3 Counterbored Perimeter Mounting Screw Holes
        for (pt = lid_boss_pts) {
            translate([pt[0], pt[1], -2.0])
                cylinder(d = m3_thru_d, h = lid_bezel_h + 4.0);
            translate([pt[0], pt[1], lid_bezel_h - 1.6])
                cylinder(d = m3_head_d, h = 1.6 + eps);
        }

        // E. 6x Ø6.2 x 0.8mm Silicone Lid Bumper Seats on Front Face
        for (bp = bumper_pts) {
            translate([bp[0], bp[1], lid_bezel_h - 0.8])
                cylinder(d = 6.3, h = 0.8 + eps);
        }

        // F. Trackball Parking Clearance Aperture in Right Wing (X = +tball_cx, Y = deck_d - tball_cy)
        //    Allows the protruding top of the 38mm trackball to nest inside the right
        //    wing of the lid when the clamshell is folded closed (0 deg)!
        translate([tball_cx, deck_d - tball_cy, -2.0])
            cylinder(d = tball_d + 4.0, h = lid_bezel_h + 4.0);
    }
}

lid_bezel();
