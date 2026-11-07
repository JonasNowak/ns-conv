// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/base_top_deck.scad
// Part: Base Top Deck — Recessed Drop x MIT Planck Rev 6 Tray + Right-Side
//       38mm QMK Trackball Socket (Translucent Lilac SLA)
// Features:
//   - Full-width top plate (306 x 146 x 4.0 mm) + 11.0mm recessed Planck tray
//   - 2.0mm solid SLA barrier floor beneath the Planck PCB (physically and
//     thermally isolating the hotswap sockets from the INIU power bank below)
//   - 5x Slotted M2 OLKB Planck Rev 6 mounting bosses + 2.0mm perimeter shelf
//   - Integrated Right-Side Contoured 38.0mm Trackball Cup with 3x MR63ZZ
//     (3x6x2.5mm) roller bearing seats at 120-deg intervals, optical sensor
//     aperture, and underside PMW3360 / Ploopy Nano sensor mounting pocket
//   - 2x Optional 14.0x14.0mm Cherry MX thumb-click switch cutouts below ball
// ============================================================================

include <config.scad>

// Coordinate system matches base_bottom.scad:
// X=0 at center, Y=0 at front edge, Z=0 at top surface of base_bottom (Z=24.5mm in assembly)

deck_plate_d = deck_d - 16.0; // Leaves rear 16.0mm hinge spine exposed on base_bottom
tray_drop_z  = 11.5;          // Depth of Planck PCB pocket below top deck plane
barrier_t    = 2.0;           // Solid SLA floor thickness isolating Planck from power bank

// Same 8x M3 Mounting Boss X/Y coordinates as base_bottom.scad
base_boss_pts = [
    [-deck_w/2 + 6.5,  10.0],
    [ 0.0,             10.0],
    [ deck_w/2 - 6.5,  10.0],
    [-deck_w/2 + 6.5,  80.0],
    [ deck_w/2 - 6.5,  80.0],
    [-deck_w/2 + 6.5,  140.0],
    [ 0.0,             140.0],
    [ deck_w/2 - 6.5,  140.0]
];

module base_top_deck() {
    difference() {
        union() {
            // 1. Main Top Deck Plate (Z = 0 to base_top_h = 4.0mm)
            difference() {
                rounded_box_xcenter(deck_w, deck_plate_d, base_top_h, corner_r);
                // Front wrist comfort bevel matching base_bottom
                translate([-deck_w/2 - 1, -1.0, base_top_h - 2.2])
                    rotate([28, 0, 0])
                        cube([deck_w + 2, 8.0, 6.0]);
            }

            // 2. Dropped Planck Tray Box & 2.0mm Power-Bank Isolation Floor
            //    Extends downward into base_bottom cavity (Z = -tray_drop_z to 0)
            translate([planck_x0 - wall_thick, planck_y0 - wall_thick, -tray_drop_z])
                cube([
                    planck_w + 2*wall_thick,
                    planck_d + 2*wall_thick,
                    tray_drop_z + eps
                ]);

            // 3. Contoured 38.0mm Trackball Socket Housing (Right of Planck)
            translate([tball_cx, tball_cy, 0]) {
                // Raised ergonomic volcano rim (+3.5mm above deck) + lower cup (-16.5mm below deck)
                translate([0, 0, -16.5])
                    cylinder(d1 = tball_d + 10.0, d2 = tball_d + 13.0, h = 16.5 + base_top_h + 3.0);
            }

            // 4. Underside Locator Lip around Perimeter (drops 1.8mm into base_bottom)
            translate([0, wall_thick + sla_clear_slip, -1.8])
                difference() {
                    rounded_box_xcenter(
                        deck_w - 2*(wall_thick + sla_clear_slip),
                        deck_plate_d - wall_thick - sla_clear_slip,
                        1.8 + eps,
                        corner_r - wall_thick
                    );
                    translate([0, rib_thick, -eps])
                        rounded_box_xcenter(
                            deck_w - 2*(wall_thick + sla_clear_slip + rib_thick),
                            deck_plate_d - wall_thick - 2*rib_thick,
                            1.8 + 3*eps,
                            corner_r - wall_thick - rib_thick
                        );
                }
        }

        // ====================================================================
        // SUBTRACTIONS (Planck Recess, M2 Bosses, Trackball Cup, MX Switches)
        // ====================================================================

        // A. Drop x MIT Planck Switch Plate Upper Recess (233.4 x 81.4 x 2.0mm)
        //    Supports the 1.5mm switch plate on a 2.0mm perimeter ledge
        translate([
            planck_x0 - sla_clear_slip,
            planck_y0 - sla_clear_slip,
            base_top_h - (planck_plate_t + 0.5)
        ])
            cube([
                planck_w + 2*sla_clear_slip,
                planck_d + 2*sla_clear_slip,
                planck_plate_t + 1.0
            ]);

        // B. Planck PCB & Hotswap Socket Inner Cavity (inset by planck_lip_w = 2.0mm)
        //    Leaves a solid 2.0mm barrier floor at the bottom (Z = -tray_drop_z to -tray_drop_z + barrier_t)
        difference() {
            translate([
                planck_x0 + planck_lip_w,
                planck_y0 + planck_lip_w,
                -tray_drop_z + barrier_t
            ])
                cube([
                    planck_w - 2*planck_lip_w,
                    planck_d - 2*planck_lip_w,
                    tray_drop_z + base_top_h
                ]);

            // Keep 5x OLKB Planck Rev 6 M2 Standoff Boss Pillars inside the cavity
            for (pt = planck_mount_pts) {
                translate([planck_x0 + pt[0], planck_y0 + pt[1], -tray_drop_z + barrier_t - eps])
                    cylinder(d = 7.5, h = (tray_drop_z - barrier_t) + (base_top_h - planck_plate_t - 0.5));
            }
        }

        // C. 5x Slotted M2 Through-Holes + Underside Hex Nut Traps for Planck PCB
        for (pt = planck_mount_pts) {
            translate([planck_x0 + pt[0], planck_y0 + pt[1], -tray_drop_z - eps]) {
                // +-0.8mm X/Y slot tolerance so both Lo-Pro and Hi-Pro Rev 6 plates align effortlessly
                hull() {
                    translate([-0.6, 0, 0]) cylinder(d = m2_thru_d, h = tray_drop_z + base_top_h + 2*eps);
                    translate([ 0.6, 0, 0]) cylinder(d = m2_thru_d, h = tray_drop_z + base_top_h + 2*eps);
                }
                hex_nut_trap(m2_nut_w, m2_nut_h + eps);
            }
        }

        // D. Planck Rear USB-C Receptacle & 15cm Cable Exit Window (CAB-02a)
        translate([
            planck_x0 + planck_usbc_x_off - 9.0,
            planck_y0 + planck_d - planck_lip_w - 1.0,
            -tray_drop_z + barrier_t
        ])
            cube([18.0, planck_lip_w + wall_thick + 3.0, tray_drop_z]);

        // E. Planck Bottom Reset Button Access Pinhole (Center-Left of Planck Floor)
        translate([planck_x0 + 96.0, planck_y0 + 38.0, -tray_drop_z - eps])
            cylinder(d = 4.0, h = barrier_t + 2*eps);

        // F. 38.0mm Trackball Spherical Socket & 3x MR63ZZ Roller Bearing Seats
        //    Ball center sits at Z = +2.5mm so 56% of the 38mm ball protrudes ergonomically
        tball_cz = 2.50;
        tball_r  = tball_d/2 + tball_cup_clear; // 19.65mm socket radius

        translate([tball_cx, tball_cy, tball_cz]) {
            // Spherical ball cavity
            sphere(r = tball_r);
            // Upper clearance bore so the 38.0mm ball drops in cleanly from the top
            cylinder(r = tball_r - 0.2, h = 25.0);

            // 3x MR63ZZ (3x6x2.5mm) Roller Bearing Seats at 120-deg intervals, 35-deg from bottom pole
            for (ang = [0, 120, 240]) {
                rotate([0, 0, ang + 30])
                    rotate([tball_bearing_ang, 0, 0])
                        translate([0, 0, -tball_r - 1.2]) {
                            // Bearing outer wheel clearance slot (Ø6.6 x 3.0mm)
                            rotate([0, 90, 0])
                                cylinder(d = tball_bearing_od + 0.6, h = tball_bearing_w + 0.6, center = true);
                            // M3 / 3.0mm Dowel Pin axle cradle slot
                            rotate([0, 90, 0])
                                cylinder(d = tball_bearing_id + 0.1, h = 11.0, center = true);
                        }
            }

            // Bottom Optical Sensor Aperture (8.0 x 8.0mm lens window at bottom pole)
            translate([0, 0, -tball_r - 6.0])
                cylinder(d = 9.0, h = 10.0);

            // Underside Pocket for PMW3360 Sensor Breakout / Ploopy Nano PCB
            // Positioned so lens surface sits 2.40mm below the 38mm ball bottom pole
            translate([-tball_sensor_w/2, -tball_sensor_d/2, -tball_r - tball_lens_gap - 6.0])
                cube([tball_sensor_w, tball_sensor_d, 6.2]);

            // 2x M2 Brass Insert Bores to retain the PMW3360 Sensor Bracket
            for (sx = [-11.5, 11.5]) {
                translate([sx, 0, -tball_r - 5.5])
                    cylinder(d = m2_insert_d, h = m2_insert_h + 1.0);
            }
        }

        // G. 2x Optional Cherry MX Thumb-Click Switch Cutouts (14.0 x 14.0mm) Below Trackball
        for (sx = [-10.5, 10.5]) {
            translate([tball_cx + sx - mx_cutout_w/2, planck_y0 + 6.0, -2.0])
                cube([mx_cutout_w, mx_cutout_w, base_top_h + 4.0]);
            // Under-plate clearance for MX switch bottom housing & pins
            translate([tball_cx + sx - 8.0, planck_y0 + 5.0, -12.0])
                cube([16.0, 16.0, base_top_h + 12.0 - 1.5]);
        }

        // H. 8x M3 Perimeter Counterbored Mounting Holes (matching base_bottom bosses)
        for (pt = base_boss_pts) {
            translate([pt[0], pt[1], -tray_drop_z - eps])
                cylinder(d = m3_thru_d, h = tray_drop_z + base_top_h + 2*eps);
            translate([pt[0], pt[1], base_top_h - 2.0])
                cylinder(d = m3_head_d, h = 2.0 + eps);
        }
    }
}

base_top_deck();
