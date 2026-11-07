// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/assembly_preview.scad
// Purpose: Complete Clamshell Assembly Model (Open at 112-deg or Closed at 0-deg)
//          Shows all custom Translucent Lilac SLA parts assembled with
//          reference models of the Switch v1 Core, Drop x MIT Planck Rev 6,
//          38mm Trackball, Southco E6 Hinges, INIU 45W Power Bank, and Hub.
// ============================================================================

include <config.scad>
use <base_bottom.scad>
use <base_top_deck.scad>
use <lid_rear.scad>
use <lid_bezel.scad>
use <battery_retainer.scad>
use <cable_clamp.scad>

// Open angle in degrees: 0 = Closed Clamshell, 112 = Ergonomic Typing Angle (100-120 deg)
lid_open_angle = 112;
exploded_z     = 0; // Set >0 for exploded assembly view

// Colors matching Translucent Lilac SLA & Donor Hardware
c_lilac_shell = [0.74, 0.56, 0.88, 0.78]; // Translucent Lilac SLA (UTR-8100 / 8001 + Royal Purple dye)
c_lilac_trim  = [0.66, 0.46, 0.82, 0.85]; // Slightly deeper lilac for bezel & straps
c_switch_body = [0.16, 0.17, 0.19, 1.00]; // Switch magnesium midframe & black glass bezel
c_switch_lcd  = [0.10, 0.48, 0.72, 1.00]; // 6.2" LCD active screen
c_planck_plate= [0.22, 0.22, 0.25, 1.00]; // Anodized Planck switch plate
c_keycap_al   = [0.90, 0.90, 0.93, 1.00]; // Planck alpha keycaps
c_keycap_mod  = [0.35, 0.32, 0.45, 1.00]; // Planck modifier keycaps
c_keycap_spc  = [0.55, 0.35, 0.75, 1.00]; // MIT 2u spacebar accent
c_trackball   = [0.82, 0.16, 0.22, 1.00]; // 38mm Crimson Snooker Trackball
c_hinge       = [0.14, 0.14, 0.16, 1.00]; // Southco E6-10-301-20 black acetal hinge
c_pbank       = [0.18, 0.20, 0.24, 1.00]; // INIU 45W Slim Power Bank

// Reference Model: Drop x MIT Planck 47-Key Ortholinear Keyboard
module ref_planck_keyboard() {
    translate([planck_x0, planck_y0, base_bottom_h + base_top_h - planck_plate_t - 0.5]) {
        // 1.5mm Switch Plate
        color(c_planck_plate)
            cube([planck_w, planck_d, planck_plate_t]);

        // 4x12 Ortholinear Keycap Grid (with 2u MIT Spacebar at Row 0, Col 5..6)
        pitch = 19.05;
        x_start = (planck_w - 12 * pitch) / 2;
        y_start = (planck_d - 4 * pitch) / 2;

        for (r = [0 : 3], c = [0 : 11]) {
            // In row 0 (bottom row), col 5 & 6 form a single 2u MIT spacebar
            if (!(r == 0 && c == 6)) {
                is_space = (r == 0 && c == 5);
                is_mod   = (r == 0 || c == 0 || c == 11);
                kw = is_space ? (2 * pitch - 1.8) : (pitch - 1.8);
                kh = pitch - 1.8;

                color(is_space ? c_keycap_spc : (is_mod ? c_keycap_mod : c_keycap_al))
                    translate([x_start + c * pitch + 0.9, y_start + r * pitch + 0.9, planck_plate_t])
                        hull() {
                            cube([kw, kh, 1.0]);
                            translate([1.8, 1.8, 7.5])
                                cube([kw - 3.6, kh - 3.6, 1.0]);
                        }
            }
        }
    }
}

// Reference Model: Nintendo Switch v1 Core Module (166.5 x 102.0 x 11.8mm)
module ref_switch_core() {
    translate([sw_center_x - sw_core_w/2, sw_bottom_y, lid_rear_h - sw_core_thick - 1.25]) {
        color(c_switch_body)
            cube([sw_core_w, sw_core_h, sw_core_thick]);
        // Active 6.2" LCD Panel
        color(c_switch_lcd)
            translate([
                (sw_core_w - sw_screen_view_w)/2,
                (sw_core_h - sw_screen_view_h)/2,
                sw_core_thick - 0.5
            ])
                cube([sw_screen_view_w, sw_screen_view_h, 0.8]);
    }
}

// Reference Model: Southco E6-10-301-20 Hinges
module ref_hinges() {
    for (hx = [-hinge_x_offset, hinge_x_offset]) {
        color(c_hinge) {
            // Base Hinge Leaf
            translate([hx - hinge_w/2, deck_d - 16.0, base_bottom_h - hinge_leaf_t])
                cube([hinge_w, 16.0, hinge_leaf_t]);
            // Hinge Knuckle Barrel at Pivot Axis (Y = deck_d - 6.0, Z = base_total_h)
            translate([hx - hinge_w/2, deck_d - 6.0, base_total_h])
                rotate([0, 90, 0])
                    cylinder(d = hinge_knuckle_d, h = hinge_w);
        }
    }
}

module full_cyberdeck_assembly() {
    // ------------------------------------------------------------------------
    // 1. LOWER BASE ASSEMBLY
    // ------------------------------------------------------------------------
    color(c_lilac_shell)
        base_bottom();

    // Internal INIU 45W Slim Power Bank + Retainer Strap
    color(c_pbank)
        translate([-deck_w/2 + 18.5, 20.5, wall_thick + pbank_foam_t])
            cube([pbank_w, pbank_d, pbank_h]);

    color(c_lilac_trim)
        translate([-deck_w/2 + 18.0 + pbank_w/2, 20.0 + (pbank_d + 1.0)/2, wall_thick + pbank_h + pbank_foam_t])
            battery_retainer();

    // Base Top Deck (Planck Tray + Trackball Socket)
    color(c_lilac_trim)
        translate([0, 0, base_bottom_h + exploded_z])
            base_top_deck();

    // Donor Drop x MIT Planck Keyboard
    translate([0, 0, exploded_z])
        ref_planck_keyboard();

    // 38.0mm Trackball Sphere
    color(c_trackball)
        translate([tball_cx, tball_cy, base_bottom_h + 2.5 + exploded_z])
            sphere(d = tball_d);

    // Southco Adjustable Friction Torque Hinges
    ref_hinges();

    // ------------------------------------------------------------------------
    // 2. UPPER LID ASSEMBLY (Rotated around Hinge Pivot Axis at Y = deck_d - 6.0)
    //    At lid_open_angle = 0 (closed): rotate([180, 0, 0]) folds lid flat over
    //    base with screen facing down (-Z).
    //    At lid_open_angle = 112 (open): rotate([68, 0, 0]) raises lid upward
    //    at 112 deg to the keyboard deck with the Switch screen facing forward (-Y).
    // ------------------------------------------------------------------------
    pivot_y = deck_d - 6.0;
    pivot_z = base_total_h + 2.0;

    translate([0, pivot_y, pivot_z + exploded_z * 1.5])
        rotate([180 - lid_open_angle, 0, 0])
            translate([0, -6.0, -lid_total_h]) {
                // Upper Lid Rear Shell
                color(c_lilac_shell)
                    lid_rear();

                // Donor Nintendo Switch v1 Core Module
                ref_switch_core();

                // Upper Lid Front Bezel Retainer
                color(c_lilac_trim)
                    translate([0, 0, lid_rear_h + exploded_z * 0.8])
                        lid_bezel();
            }
}

full_cyberdeck_assembly();
