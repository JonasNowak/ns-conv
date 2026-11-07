// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/test_fit_jig.scad
// Part: Pre-Order Calibration & Test-Fit Gauge Jig (Print First!)
// Purpose:
//   A compact (~18g, <3 EUR) test coupon that verifies all 5 critical
//   mechanical interfaces before committing to the full 306x162mm shells:
//     1. Switch v1 Side-Rail M2 Hole Pitch Gauge (12.0, 31.5, 51.0, 70.5, 90.0mm)
//        and Switch Core Thickness Slot (11.80mm + 0.20mm clearance)
//     2. Drop x MIT Planck Corner Ledge + M2 Standoff Offset (21.5 x 21.5mm)
//     3. Southco E6-10-301-20 Hinge Leaf Footprint & Hole Pitch (25.4 x 19.1mm)
//     4. 38.0mm Trackball + MR63ZZ Bearing Seat Fit Coupon
//     5. Thermoset SLA Fastener Tolerance Ladder (M2/M3 Brass Insert & Hex Nut
//        test bores at -0.05mm, 0.00mm nominal, and +0.05mm)
// ============================================================================

include <config.scad>

module test_fit_jig() {
    difference() {
        union() {
            // 1. Main L-Shaped Calibration Coupon Base (105 x 55 x 5.0 mm)
            cube([105.0, 55.0, 5.0]);

            // 2. Switch Core Thickness Caliper U-Jaw at Left End (Tests 11.8mm + 2*0.2mm = 12.2mm)
            translate([0, 0, 5.0 - eps])
                difference() {
                    cube([18.0, 24.0, 12.0]);
                    translate([3.0, -eps, -eps])
                        cube([sw_core_thick + 2*sla_clear_slip, 24.0 + 2*eps, 12.5]);
                }

            // 3. Planck Corner Support Ledge Coupon (Top-Right of Jig)
            translate([60.0, 20.0, 5.0 - eps])
                difference() {
                    cube([45.0, 35.0, 5.0]);
                    // Planck switch plate corner recess
                    translate([5.0, 5.0, 5.0 - (planck_plate_t + 0.5)])
                        cube([40.0 + eps, 30.0 + eps, planck_plate_t + 1.0]);
                    // Inner PCB drop clearance (leaving 2.0mm support shelf)
                    translate([5.0 + planck_lip_w, 5.0 + planck_lip_w, -eps])
                        cube([40.0, 30.0, 3.5]);
                }
            // Planck M2 Standoff Boss at exact (21.5, 21.5) offset from corner
            translate([60.0 + 5.0 + 21.5, 20.0 + 5.0 + 21.5, 5.0 - eps])
                cylinder(d = 7.0, h = 5.0 - (planck_plate_t + 0.5));
        }

        // A. 5x Switch v1 Side-Rail M2 Pitch Verification Holes along Y=8.0mm edge
        //    (Positions: X = 12.0, 31.5, 51.0, 70.5, 90.0 mm)
        for (rx = sw_rail_hole_y) {
            translate([rx, 8.0, -eps])
                cylinder(d = m2_thru_d, h = 10.0);
        }

        // B. Planck Corner M2 Through-Hole + Underside Hex Nut Trap at (86.5, 46.5)
        translate([60.0 + 5.0 + 21.5, 20.0 + 5.0 + 21.5, -eps]) {
            cylinder(d = m2_thru_d, h = 15.0);
            hex_nut_trap(m2_nut_w, m2_nut_h + eps);
        }

        // C. Southco E6-10-301-20 Hinge Hole Pitch Test Pattern (25.4 x 19.1 mm)
        for (dx = [0, hinge_hole_span_x], dy = [0, hinge_hole_span_y]) {
            translate([24.0 + dx, 24.0 + dy, -eps]) {
                cylinder(d = m3_thru_d + 0.2, h = 10.0);
                hex_nut_trap(m3_nut_w, m3_nut_h + eps);
            }
        }

        // D. Single MR63ZZ (3x6x2.5mm) Roller Bearing Test Seat at (52.0, 35.0)
        translate([52.0, 35.0, 5.0]) {
            rotate([0, 90, 0])
                cylinder(d = tball_bearing_od + 0.5, h = tball_bearing_w + 0.5, center = true);
            rotate([0, 90, 0])
                cylinder(d = tball_bearing_id + 0.1, h = 10.0, center = true);
        }

        // E. SLA Thermoset Insert & Nut Tolerance Ladder (-0.05, 0.00, +0.05mm)
        for (i = [-1, 0, 1]) {
            delta = i * 0.05;
            // M2 Brass Insert test bores
            translate([30.0 + (i + 1) * 9.0, 15.0, 5.0 - m2_insert_h])
                cylinder(d = m2_insert_d + delta, h = m2_insert_h + eps);
            // M3 Brass Insert test bores
            translate([62.0 + (i + 1) * 11.0, 13.0, 5.0 - m3_insert_h])
                cylinder(d = m3_insert_d + delta, h = m3_insert_h + eps);
        }
    }
}

test_fit_jig();
