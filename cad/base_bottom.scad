// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/base_bottom.scad
// Part: Lower Base Enclosure (Translucent Lilac SLA)
// Features:
//   - Outer rounded tub (306 x 162 x 24.5 mm) with 2.5mm uniform walls
//   - Ergonomic front wrist bevel (12-deg comfort slope)
//   - Isolated INIU 45W Slim Power Bank bay (110x68x18.5mm) with bottom intake
//     louvers and external M3 retention bosses (>=4.5mm away from cell wall)
//   - Internal 100W USB-C PD Hub cradle (115x27.5x12.2mm) with right-side
//     flush cutouts for spare USB 3.0 Type-A and 4K HDMI ports
//   - Rear Recessed Mode/Charging Coupler Pocket (Panel USB-C PD In + Switch
//     Direct USB-C coupler clip + Power Cutoff Switch window)
//   - Left & Right Southco E6-10-301-20 adjustable torque hinge pads with
//     M4/M3 through-holes and underside hex-nut traps
//   - 8x M3 perimeter mounting bosses for base_top_deck.scad
// ============================================================================

include <config.scad>

// Coordinate system: X=0 at center, Y=0 at front edge, Z=0 at bottom floor

// Power bank bay origin (Front-Left quadrant under Planck)
pbank_bay_x0 = -deck_w/2 + 18.0;
pbank_bay_y0 = 20.0;

// Internal USB-C PD Hub origin (Rear-Right quadrant)
hub_bay_x0   = 22.0;
hub_bay_y0   = 105.0;

// 8x M3 Top-Deck Mounting Boss Coordinates [x, y]
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

module base_bottom() {
    difference() {
        union() {
            // 1. Main Outer Shell Tub
            difference() {
                rounded_box_xcenter(deck_w, deck_d, base_bottom_h, corner_r);

                // Ergonomic front wrist chamfer along Y=0 top edge
                translate([-deck_w/2 - 1, -1.0, base_bottom_h - 4.5])
                    rotate([32, 0, 0])
                        cube([deck_w + 2, 12.0, 12.0]);

                // Main interior hollow cavity (leaves 2.5mm floor and 2.5mm walls)
                translate([0, wall_thick, wall_thick])
                    rounded_box_xcenter(
                        deck_w - 2*wall_thick,
                        deck_d - 2*wall_thick - 14.0, // Reserves solid 14mm rear hinge spine block
                        base_bottom_h,
                        corner_r - wall_thick
                    );

                // Rear coupler & cable routing bay in the spine between the two hinges
                translate([-hinge_x_offset + hinge_w/2 + 8.0, deck_d - 22.0, wall_thick + 2.0])
                    cube([
                        2*(hinge_x_offset - hinge_w/2 - 8.0),
                        22.0 - wall_thick,
                        base_bottom_h
                    ]);
            }

            // 2. Internal Structural Grid Ribs (1.8mm thick for uniform SLA dye tint)
            for (rx = [-65.0, 15.0, 85.0]) {
                translate([rx - rib_thick/2, wall_thick - eps, wall_thick - eps])
                    cube([rib_thick, deck_d - 18.0, 3.0 + eps]);
            }
            for (ry = [55.0, 98.0]) {
                translate([-deck_w/2 + wall_thick - eps, ry - rib_thick/2, wall_thick - eps])
                    cube([deck_w - 2*wall_thick + 2*eps, rib_thick, 3.0 + eps]);
            }

            // 3. Power Bank Containment Perimeter Walls (1.8mm walls, +1.0mm slip + foam margin)
            translate([pbank_bay_x0 - rib_thick, pbank_bay_y0 - rib_thick, wall_thick - eps])
                difference() {
                    cube([pbank_w + 2*rib_thick + 1.0, pbank_d + 2*rib_thick + 1.0, 12.0 + eps]);
                    translate([rib_thick, rib_thick, -eps])
                        cube([pbank_w + 1.0, pbank_d + 1.0, 12.0 + 3*eps]);
                    // Cable exit notch on right side of power bank bay
                    translate([pbank_w, 12.0, 2.0])
                        cube([rib_thick + 2.0, 44.0, 12.0]);
                }

            // 4. External Power Bank Retainer Strap Bosses (4.5mm clear of battery casing!)
            for (sy = [-pbank_safe_gap, pbank_d + 1.0 + pbank_safe_gap]) {
                translate([pbank_bay_x0 + pbank_w/2, pbank_bay_y0 + sy, wall_thick - eps])
                    cylinder(d = 9.0, h = pbank_h + pbank_foam_t + eps);
            }

            // 5. Internal 100W USB-C PD Hub Cradle Ribs (Rear-Right)
            translate([hub_bay_x0 - rib_thick, hub_bay_y0 - rib_thick, wall_thick - eps])
                difference() {
                    cube([hub_w + 2*rib_thick + 0.6, hub_d + 2*rib_thick + 0.6, 9.0 + eps]);
                    translate([rib_thick, rib_thick, -eps])
                        cube([hub_w + 0.6, hub_d + 0.6, 9.0 + 3*eps]);
                    // Upstream & downstream cable slots on left and front walls
                    translate([-eps, 4.0, 1.5])
                        cube([rib_thick + 2.0, hub_d - 6.0, 9.0]);
                    translate([10.0, -eps, 1.5])
                        cube([hub_w - 20.0, rib_thick + 2.0, 9.0]);
                }

            // 6. 8x M3 Perimeter Standoff Pillars for Base Top Deck
            for (pt = base_boss_pts) {
                translate([pt[0], pt[1], wall_thick - eps])
                    cylinder(d = 8.5, h = base_bottom_h - wall_thick + eps);
            }
        }

        // ====================================================================
        // SUBTRACTIONS (Vents, Fastener Bores, Hinge Mounts, Rear/Side I/O)
        // ====================================================================

        // A. Power Bank Retainer M3 Through-Holes + Bottom Hex-Nut Traps
        for (sy = [-pbank_safe_gap, pbank_d + 1.0 + pbank_safe_gap]) {
            translate([pbank_bay_x0 + pbank_w/2, pbank_bay_y0 + sy, -eps]) {
                cylinder(d = m3_thru_d, h = base_bottom_h + 2);
                hex_nut_trap(m3_nut_w, m3_nut_h + eps);
            }
        }

        // B. 8x M3 Top-Deck Boss Bores (Knurled Brass Insert Bores from Top + M3 Thru)
        for (pt = base_boss_pts) {
            translate([pt[0], pt[1], base_bottom_h - m3_insert_h])
                cylinder(d = m3_insert_d, h = m3_insert_h + eps);
            translate([pt[0], pt[1], wall_thick])
                cylinder(d = m3_thru_d, h = base_bottom_h);
        }

        // C. Bottom Passive Intake Ventilation Louvers Under Power Bank Bay
        for (i = [0 : 7]) {
            translate([pbank_bay_x0 + 12.0 + i * 11.5, pbank_bay_y0 + 12.0, -eps])
                hull() {
                    cylinder(d = 3.2, h = wall_thick + 2*eps);
                    translate([0, pbank_d - 24.0, 0])
                        cylinder(d = 3.2, h = wall_thick + 2*eps);
                }
        }

        // D. Bottom Ventilation Louvers Under USB-C PD Hub Bay
        for (i = [0 : 6]) {
            translate([hub_bay_x0 + 14.0 + i * 13.0, hub_bay_y0 + 5.0, -eps])
                hull() {
                    cylinder(d = 3.0, h = wall_thick + 2*eps);
                    translate([0, hub_d - 10.0, 0])
                        cylinder(d = 3.0, h = wall_thick + 2*eps);
                }
        }

        // E. Left & Right Southco E6-10-301-20 Hinge Leaf Pockets & M4/M3 Bolt Holes
        for (hx = [-hinge_x_offset, hinge_x_offset]) {
            // Recessed seat for lower hinge leaf on rear spine top
            translate([hx - (hinge_w + 0.5)/2, deck_d - 16.0, base_bottom_h - hinge_leaf_t])
                cube([hinge_w + 0.5, 16.5, hinge_leaf_t + eps]);

            // 2x Mounting bolts per base hinge leaf + underside M4/M3 hex nut traps
            for (dx = [-hinge_hole_span_x/2, hinge_hole_span_x/2]) {
                translate([hx + dx, deck_d - 8.5, -eps]) {
                    cylinder(d = m3_thru_d + 0.2, h = base_bottom_h + 2*eps);
                    hex_nut_trap(m3_nut_w + 0.1, m3_nut_h + 1.5);
                }
            }
        }

        // F. Rear Panel-Mount USB-C PD Charging Input Port (CAB-03, X = -42mm)
        translate([-42.0, deck_d + eps, 12.0])
            rotate([90, 0, 0]) {
                // Rounded USB-C nose cutout
                hull() {
                    for (sx = [-1, 1])
                        translate([sx * (panel_usbc_hole_w/2 - panel_usbc_hole_h/2), 0, 0])
                            cylinder(d = panel_usbc_hole_h, h = 10.0);
                }
                // 2x M2/M3 panel-mount screw ears (16.0mm span)
                for (sx = [-1, 1])
                    translate([sx * panel_usbc_span/2, 0, 0])
                        cylinder(d = m2_thru_d, h = 10.0);
            }

        // G. Rear Recessed Mode Coupler Pocket & Hinge USB-C Ribbon Entry (Center X = 0)
        // Allows unplugging HUB-01 from CAB-01 to inject RCM payload from external PC/dongle
        translate([-22.0, deck_d - 12.0, 8.0])
            cube([44.0, 12.0 + eps, base_bottom_h]);
        // Central hinge channel slot for 20cm 90-deg flat USB-C ribbon (CAB-01)
        translate([-11.0, deck_d - 22.0, base_bottom_h - 6.0])
            cube([22.0, 22.0 + eps, 6.0 + eps]);
        // 2x M2 Brass Insert bores for Rear Coupler Strain-Relief Clamp (cable_clamp.scad)
        for (sx = [-14.0, 14.0]) {
            translate([sx, deck_d - 16.0, 4.0])
                cylinder(d = m2_insert_d, h = m2_insert_h + 1.0);
        }

        // H. Rear Power Cutoff Slide/Rocker Switch Window (ELC-02, X = +42mm)
        translate([35.0, deck_d - wall_thick - 2.0, 8.5])
            cube([14.0, wall_thick + 4.0, 9.5]);

        // I. Right-Side Flush Cutout Window for Hub Spare USB-A 3.0 & 4K HDMI Ports
        translate([deck_w/2 - wall_thick - 1.0, hub_bay_y0 + 3.0, wall_thick + 1.5])
            cube([wall_thick + 2.0, hub_d - 4.0, 11.0]);

        // J. 4x Bottom Corner Recesses (Ø10.4 x 0.8mm) for Self-Adhesive Silicone Feet (MEC-04)
        for (fx = [-deck_w/2 + 18.0, deck_w/2 - 18.0], fy = [18.0, deck_d - 18.0]) {
            translate([fx, fy, -eps])
                cylinder(d = 10.4, h = 0.8 + eps);
        }
    }
}

base_bottom();
