// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/cable_clamp.scad
// Part: USB-C Ribbon & Coupler Strain-Relief Clamps (2x Set, Translucent Lilac SLA)
// Purpose:
//   - Clamp A (x=0): Locks the 90-degree flat USB-C plug (CAB-01) into the
//     Switch's bottom USB-C port inside lid_rear.scad so hinge motion never
//     stresses the Switch's USB-C solder joints.
//   - Clamp B (x=22): Retains the CAB-01 <-> HUB-01 coupler inside the rear
//     base pocket (unclips with 2x M2 thumb/socket screws for RCM mode).
// ============================================================================

include <config.scad>

clamp_span_x = 28.0; // Matches 2x M2 brass insert bosses at +-14.0mm
clamp_w      = 10.0;
clamp_h      = 4.5;

module single_clamp(slot_w, slot_h) {
    difference() {
        hull() {
            for (sx = [-clamp_span_x/2, clamp_span_x/2]) {
                translate([sx, 0, 0])
                    cylinder(d = clamp_w, h = clamp_h);
            }
        }

        // Central cable / plug saddle cutout
        translate([-slot_w/2, -clamp_w, -eps])
            cube([slot_w, clamp_w * 2, slot_h + eps]);

        // 2x M2 Mounting Screw Holes at +-14.0mm
        for (sx = [-clamp_span_x/2, clamp_span_x/2]) {
            translate([sx, 0, -eps])
                cylinder(d = m2_thru_d, h = clamp_h + 2*eps);
            translate([sx, 0, clamp_h - 1.5])
                cylinder(d = m2_head_d, h = 1.6);
        }
    }
}

module cable_clamp_pair() {
    // Clamp A: Lid Switch 90-deg USB-C Plug Retainer
    single_clamp(16.0, 2.2);

    // Clamp B: Base Rear Coupler Retainer
    translate([0, 16.0, 0])
        single_clamp(14.5, 2.0);
}

cable_clamp_pair();
