// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/lid_rear.scad
// Part: Upper Lid Rear Shell (Translucent Lilac SLA)
// Features:
//   - Full-width clamshell lid (306 x 162 x 15.0 mm) with 2.5mm uniform walls
//   - Precision central cradle for the intact Nintendo Switch v1 Core Assembly
//     (166.5 x 102.0 x 11.8 mm — LCD + Digitizer + Magnesium Midframe +
//     Mainboard + Fan + 4310mAh Battery)
//   - 10x M2 Side-Rail Structural Mounting Holes (5 Left + 5 Right) aligned
//     with the factory Joy-Con rail screw bosses on the Switch midframe
//   - Diagonal X-truss stiffening ribs (1.8mm thick) linking the two Southco
//     E6-10-301-20 hinge pads directly to the Switch core cradle
//   - Unobstructed OEM Rear Fan Intake Louvers, Top Radiator Exhaust Channel,
//     Rear microSDXC Access Window, Top Controls (Power, Vol+/-, Audio,
//     Game Card), and Recessed Right-Side RCM Boot Tactile Switch Pocket
//   - Bottom 90-Degree Flat USB-C (CAB-01) Strain-Relief Channel & Clamp Bosses
// ============================================================================

include <config.scad>

// Coordinate system for lid_rear (printed flat on its outer back face Z=0):
// X=0 at center, Y=0 at hinge edge (bottom of lid), Y=deck_d at top edge of lid,
// Z=0 at outer rear surface of lid, Z=lid_rear_h (15.0mm) at inner bezel mating rim.

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

module lid_rear() {
    difference() {
        union() {
            // 1. Outer Lid Tub (306 x 162 x 15.0 mm)
            difference() {
                rounded_box_xcenter(deck_w, deck_d, lid_rear_h, corner_r);

                // Exterior rear perimeter aesthetic bevel along top/left/right edges
                // (Gives a sleek laptop profile while keeping uniform wall thickness)
                translate([0, wall_thick, wall_thick])
                    rounded_box_xcenter(
                        deck_w - 2*wall_thick,
                        deck_d - 2*wall_thick,
                        lid_rear_h,
                        corner_r - wall_thick
                    );
            }

            // 2. Central Nintendo Switch v1 Core Cradle Walls (Left, Right, Bottom, Top)
            //    Left & Right structural rail walls are 4.5mm thick to house the
            //    10x M2 counterbored side bolts into the Switch magnesium midframe!
            sw_pocket_w = sw_core_w + 2*sla_clear_slip; // 166.90 mm
            sw_pocket_h = sw_core_h + 2*sla_clear_slip; // 102.40 mm
            rail_wall_t = 4.50;

            translate([
                sw_center_x - sw_pocket_w/2 - rail_wall_t,
                sw_bottom_y - wall_thick,
                wall_thick - eps
            ])
                difference() {
                    cube([
                        sw_pocket_w + 2*rail_wall_t,
                        sw_pocket_h + 2*wall_thick,
                        lid_rear_h - wall_thick + eps
                    ]);
                    // Inner Switch core pocket
                    translate([rail_wall_t, wall_thick, -eps])
                        cube([sw_pocket_w, sw_pocket_h, lid_rear_h + 2*eps]);
                }

            // 3. Structural Load-Transfer Ribs from Hinge Pads to Switch Cradle
            //    (1.8mm thick ribs transfer hinge torque smoothly across the SLA lid)
            for (sx = [-1, 1]) {
                // Hinge mounting block at Y=0..18mm
                translate([sx * hinge_x_offset - (hinge_w + 6.0)/2, wall_thick - eps, wall_thick - eps])
                    cube([hinge_w + 6.0, 16.0, lid_rear_h - wall_thick + eps]);

                // Vertical and diagonal ribs into Switch side rail wall
                hull() {
                    translate([sx * hinge_x_offset - rib_thick/2, 16.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                    translate([sx * (sw_pocket_w/2 + rail_wall_t/2), sw_bottom_y + 15.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                }
                hull() {
                    translate([sx * (deck_w/2 - wall_thick - 2.0), 45.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                    translate([sx * (sw_pocket_w/2 + rail_wall_t/2), sw_bottom_y + 45.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                }
                hull() {
                    translate([sx * (deck_w/2 - wall_thick - 2.0), 105.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                    translate([sx * (sw_pocket_w/2 + rail_wall_t/2), sw_bottom_y + 85.0, wall_thick - eps])
                        cylinder(d = rib_thick, h = lid_rear_h - wall_thick - 2.0 + eps);
                }
            }

            // 4. 2x M2 Brass-Insert Standoffs for 90-Degree USB-C Strain-Relief Clamp (CAB-01)
            for (sx = [-14.0, 14.0]) {
                translate([sw_center_x + sx, sw_bottom_y - 11.0, wall_thick])
                    cylinder(d = 6.5, h = 6.5);
            }

            // 5. Recessed Momentary RCM Boot Tactile Switch Holder (Right of Switch Cradle)
            translate([sw_center_x + sw_pocket_w/2 + rail_wall_t - 0.5, sw_bottom_y + 78.0, wall_thick])
                cube([10.0, 12.0, 9.0]);

            // 6. 8x M3 Perimeter Bosses for Front Bezel Retainer (lid_bezel.scad)
            for (pt = lid_boss_pts) {
                translate([pt[0], pt[1], wall_thick])
                    cylinder(d = 8.0, h = lid_rear_h - wall_thick);
            }
        }

        // ====================================================================
        // SUBTRACTIONS (10x Midframe Bolts, Vents, SD Window, USB-C, Hinges)
        // ====================================================================
        sw_pocket_w = sw_core_w + 2*sla_clear_slip;
        sw_pocket_h = sw_core_h + 2*sla_clear_slip;
        rail_wall_t = 4.50;

        // A. 10x M2 Side-Rail Structural Mounting Holes (5 Left + 5 Right)
        //    Screws pass horizontally through the cradle side walls into the
        //    Switch's factory M2 Joy-Con rail threads!
        //    Also includes outer side-access clearance holes for long M2 hex driver.
        for (ry = sw_rail_hole_y) {
            hole_y = sw_bottom_y + sla_clear_slip + ry;
            hole_z = lid_rear_h - sw_rail_hole_z; // Measured down from front glass plane

            // Left & Right Cradle Wall M2 Clearance Holes + Head Counterbores
            for (sx = [-1, 1]) {
                translate([sw_center_x + sx * (sw_pocket_w/2 - 1.0), hole_y, hole_z])
                    rotate([0, sx * 90, 0]) {
                        cylinder(d = m2_thru_d, h = rail_wall_t + 3.0);
                        translate([0, 0, rail_wall_t - 1.2])
                            cylinder(d = m2_head_d, h = 20.0);
                    }
            }
        }

        // B. Switch Bottom 90-Degree Flat USB-C Plug (CAB-01) Channel & Hinge Exit
        translate([sw_center_x - sw_usbc_plug_w/2, -eps, wall_thick])
            cube([sw_usbc_plug_w, sw_bottom_y + 4.0, lid_rear_h]);
        // Hinge exit slot at bottom spine (Y = 0)
        translate([sw_center_x - 11.0, -eps, wall_thick + 2.0])
            cube([22.0, wall_thick + 4.0, lid_rear_h]);
        // 2x M2 Brass Insert bores for USB-C Strain-Relief Clamp
        for (sx = [-14.0, 14.0]) {
            translate([sw_center_x + sx, sw_bottom_y - 11.0, wall_thick + 6.5 - m2_insert_h])
                cylinder(d = m2_insert_d, h = m2_insert_h + eps);
        }

        // C. OEM-Aligned Rear Fan Intake Louvers (2x 20x5mm slotted grilles)
        for (sx = [-1, 1]) {
            gx = sw_center_x + sx * (sw_intake_x_span / 2);
            gy = sw_bottom_y + sw_intake_y_off;
            for (slot = [-2 : 2]) {
                translate([gx + slot * 3.6 - 1.0, gy - sw_intake_h/2, -eps])
                    cube([2.0, sw_intake_h, wall_thick + 2*eps]);
            }
        }

        // D. Top Copper Radiator Active Fan Exhaust Channel & Top Edge Louver
        //    Routes hot air from top of Switch core straight out the top edge of the lid!
        ex_x = sw_center_x + sw_exhaust_x_off - sw_exhaust_w/2;
        translate([ex_x, sw_bottom_y + sw_core_h - 2.0, wall_thick + 2.0])
            cube([sw_exhaust_w, deck_d - (sw_bottom_y + sw_core_h) + 4.0, sw_exhaust_h + 2.0]);
        // Rear exhaust relief slots directly above radiator
        for (i = [0 : 7]) {
            translate([ex_x + 3.0 + i * 5.0, sw_bottom_y + sw_core_h - 4.0, -eps])
                cube([2.8, 12.0, wall_thick + 2*eps]);
        }

        // E. Rear microSDXC Card Access Window (Bevelled slot so card can be swapped anytime)
        translate([
            sw_center_x + sw_sd_x_off - sw_sd_win_w/2,
            sw_bottom_y + sw_sd_y_off - sw_sd_win_h/2,
            -eps
        ])
            cube([sw_sd_win_w, sw_sd_win_h, wall_thick + 2*eps]);

        // F. Top Control Cutouts (Power, Volume +/-, 3.5mm Audio Jack, Game Card Slot)
        //    Direct finger access channels from the top edge of the Switch core to top of lid
        // 1. Power + Volume Rocker Access Recess
        translate([sw_center_x + sw_btn_pwr_x - 8.0, sw_bottom_y + sw_core_h - 2.0, wall_thick])
            cube([38.0, deck_d - (sw_bottom_y + sw_core_h) + 2.0, lid_rear_h]);
        // 2. 3.5mm Headphone + Game Card Access Recess
        translate([sw_center_x + sw_audio_x - 6.0, sw_bottom_y + sw_core_h - 2.0, wall_thick])
            cube([46.0, deck_d - (sw_bottom_y + sw_core_h) + 2.0, lid_rear_h]);

        // G. Recessed Momentary RCM Boot Tactile Switch Pocket (6.3 x 6.3mm + Ø3.2mm Pinhole)
        //    Located on the rear-right of the Switch cradle (Y = sw_bottom_y + 84mm)
        translate([sw_center_x + sw_pocket_w/2 + rail_wall_t + 1.5, sw_bottom_y + 81.0, wall_thick + 1.5])
            cube([rcm_switch_w, rcm_switch_w, 8.0]);
        // Wire slot into Right Joy-Con rail channel
        translate([sw_center_x + sw_pocket_w/2 - 1.0, sw_bottom_y + 82.5, wall_thick + 2.0])
            cube([rail_wall_t + 4.0, 3.5, 6.0]);
        // Recessed rear pinhole so you can hold RCM at boot without accidental bumps
        translate([
            sw_center_x + sw_pocket_w/2 + rail_wall_t + 1.5 + rcm_switch_w/2,
            sw_bottom_y + 81.0 + rcm_switch_w/2,
            -eps
        ])
            cylinder(d = rcm_pinhole_d, h = wall_thick + 2.0);

        // H. Left & Right Southco E6-10-301-20 Hinge Leaf Seats & M3/M4 Mounting Bores
        for (hx = [-hinge_x_offset, hinge_x_offset]) {
            // Hinge leaf pocket on inner bottom spine (Y = 0..16mm)
            translate([hx - (hinge_w + 0.5)/2, -eps, lid_rear_h - hinge_leaf_t])
                cube([hinge_w + 0.5, 16.5, hinge_leaf_t + eps]);
            // 2x M3/M4 Mounting Bores + Outer Rear Hex-Nut Traps
            for (dx = [-hinge_hole_span_x/2, hinge_hole_span_x/2]) {
                translate([hx + dx, 8.5, -eps]) {
                    cylinder(d = m3_thru_d + 0.2, h = lid_rear_h + 2*eps);
                    hex_nut_trap(m3_nut_w + 0.1, m3_nut_h + 0.5);
                }
            }
        }

        // I. 8x M3 Perimeter Brass Insert Bores for Front Bezel Retainer (lid_bezel.scad)
        for (pt = lid_boss_pts) {
            translate([pt[0], pt[1], lid_rear_h - m3_insert_h])
                cylinder(d = m3_insert_d, h = m3_insert_h + eps);
            translate([pt[0], pt[1], wall_thick])
                cylinder(d = m3_thru_d, h = lid_rear_h);
        }

        // J. Spherical Trackball Parking Pocket in Right Wing when Lid is Closed
        //    Leaves a full 2.5mm solid outer rear wall (Z = 2.5mm)
        translate([tball_cx, deck_d - tball_cy, lid_rear_h + 8.0])
            sphere(d = tball_d + 3.0);
    }
}

lid_rear();
