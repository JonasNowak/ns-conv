// ============================================================================
// ns-conv: Nintendo Switch v1 (Erista) -> Clamshell Cyberdeck Conversion
// File: cad/config.scad
// Purpose: Shared parametric configuration & single source of truth for all
//          custom 3D-printed enclosure parts (JLC3DP SLA 8001 Translucent /
//          PCBWay UTR-8100 Transparent).
// Units: Millimeters (mm)
// ============================================================================
// NOTE: Every dimension marked with [USER_VERIFY] should be checked with
// digital calipers against your physical hardware (see docs/teardown.md Part D)
// before ordering the full enclosure print.
// ============================================================================

$fn = $preview ? 36 : 72;
eps = 0.02; // Boolean CSG overlap epsilon to guarantee 2-manifold meshes

// ----------------------------------------------------------------------------
// 1. SLA MANUFACTURING & TOLERANCE PARAMETERS (JLC3DP SLA 8001 / PCBWay UTR-8100)
// ----------------------------------------------------------------------------
wall_thick        = 2.50;  // Nominal structural wall thickness (mm) for SLA rigidity & even lilac dye
rib_thick         = 1.80;  // Internal stiffening rib thickness (~72% of wall_thick to prevent sink marks)
corner_r          = 5.00;  // Outer enclosure corner fillet radius (mm)
chamfer_s         = 1.00;  // Edge break chamfer size (mm)

sla_clear_slip    = 0.20;  // Per-side slip-fit clearance for drop-in PCBs and mating shell lips (mm)
sla_clear_tight   = 0.10;  // Per-side snug locate clearance for bearings and switches (mm)
sla_clear_insert  = 0.05;  // Per-side cold-press + CA glue clearance for knurled brass inserts in thermoset SLA

// Metric Fasteners (M2, M2.5, M3, M4 — DIN 912 / ISO 7380 + DIN 934 Hex Nuts)
m2_thru_d         = 2.30;  // M2 screw clearance hole diameter
m2_head_d         = 4.20;  // M2 socket/button head counterbore diameter
m2_nut_w          = 4.15;  // M2 DIN 934 hex nut flat-to-flat width (4.0mm nominal + 0.15mm SLA clearance)
m2_nut_h          = 1.75;  // M2 hex nut trap depth
m2_insert_d       = 3.15;  // M2x3x3.2mm knurled brass insert bore (cold-press + CA glue)
m2_insert_h       = 3.50;  // M2 brass insert bore depth

m3_thru_d         = 3.35;  // M3 screw clearance hole diameter
m3_head_d         = 6.00;  // M3 socket/button head counterbore diameter
m3_nut_w          = 5.65;  // M3 DIN 934 hex nut flat-to-flat width (5.5mm nominal + 0.15mm SLA clearance)
m3_nut_h          = 2.55;  // M3 hex nut trap depth
m3_insert_d       = 4.45;  // M3x4x4.5mm knurled brass insert bore (cold-press + CA glue)
m3_insert_h       = 4.50;  // M3 brass insert bore depth

m4_thru_d         = 4.35;  // M4 screw clearance hole for Southco E6 hinge leaves

// ----------------------------------------------------------------------------
// 2. NINTENDO SWITCH v1 (MOD. HAC-001, 2017 ERISTA) CORE ASSEMBLY
//    (Front Bezel + Digitizer + LCD + Magnesium Midframe + Mainboard + Fan +
//     EMI Shield, with Rear Plastic Backplate & Joy-Con Side Rails Removed)
// ----------------------------------------------------------------------------
sw_core_w         = 166.50; // [USER_VERIFY] Width of Switch midframe/bezel without side Joy-Con rails (173.0mm w/ rails)
sw_core_h         = 102.00; // [USER_VERIFY] Height of Switch tablet from bottom edge to top edge
sw_core_thick     = 11.80;  // [USER_VERIFY] Thickness from front glass to rear aluminum EMI shield (13.9mm w/ plastic backplate)

sw_screen_view_w  = 137.00; // Active 6.2" LCD + touch margin opening width in lid bezel
sw_screen_view_h  = 77.20;  // Active 6.2" LCD + touch margin opening height in lid bezel
sw_glass_w        = 161.20; // [USER_VERIFY] Front digitizer outer glass width
sw_glass_h        = 94.20;  // [USER_VERIFY] Front digitizer outer glass height

// 10x M2 Side-Rail Mounting Holes in Magnesium Midframe (5 Left, 5 Right)
// Measured from bottom edge of Switch core (Y=0 at bottom edge of Switch)
sw_rail_hole_y    = [12.00, 31.50, 51.00, 70.50, 90.00]; // [USER_VERIFY] 5x M2 hole Y positions (mm)
sw_rail_hole_z    = 5.80;   // [USER_VERIFY] Z-distance from front glass surface to side M2 hole centers

// Switch Bottom USB-C Port & 90-Degree Flat FPC Plug (CAB-01) Clearance
sw_usbc_w         = 12.00;  // USB-C cutout width
sw_usbc_plug_h    = 14.50;  // Vertical clearance below Switch bottom edge for 90-deg flat USB-C plug & strain clamp
sw_usbc_plug_w    = 24.00;  // Width of 90-deg USB-C plug + clamp pocket

// Switch Thermal Vents, Top Controls & Rear microSD Access
sw_exhaust_x_off  = 11.00;  // [USER_VERIFY] Top radiator exhaust X offset from Switch centerline (+X = right)
sw_exhaust_w      = 42.00;  // [USER_VERIFY] Top copper radiator exhaust width
sw_exhaust_h      = 6.50;   // Top exhaust slot thickness
sw_intake_x_span  = 74.00;  // [USER_VERIFY] Center-to-center span between the two lower-rear intake grilles
sw_intake_y_off   = 18.00;  // [USER_VERIFY] Distance from Switch bottom edge to rear intake grilles
sw_intake_w       = 20.00;  // Rear intake grille width each
sw_intake_h       = 5.00;   // Rear intake grille height each

sw_sd_x_off       = -51.00; // [USER_VERIFY] Rear microSDXC slot X offset from Switch center (-X = left when facing screen)
sw_sd_y_off       = 26.00;  // [USER_VERIFY] Rear microSDXC slot Y height from Switch bottom edge
sw_sd_win_w       = 20.00;  // Rear microSDXC access window width
sw_sd_win_h       = 18.00;  // Rear microSDXC access window height

sw_btn_pwr_x      = -58.00; // [USER_VERIFY] Top Power button X offset from Switch center
sw_btn_vol_x      = -40.00; // [USER_VERIFY] Top Volume +/- rocker center X offset from Switch center
sw_btn_vol_w      = 20.00;  // Volume rocker cutout width
sw_audio_x        = 22.50;  // [USER_VERIFY] 3.5mm headphone jack X offset from Switch center
sw_gamecard_x     = 44.00;  // [USER_VERIFY] Game Card slot X offset from Switch center
sw_gamecard_w     = 31.00;  // Game Card slot cutout width

// Recessed Momentary RCM Boot Tactile Button (RCM-01: 6x6x5mm switch)
rcm_switch_w      = 6.30;   // Pocket width for 6x6mm tactile switch
rcm_pinhole_d     = 3.20;   // Recessed actuator pinhole diameter (prevents accidental press)

// ----------------------------------------------------------------------------
// 3. DROP x OLKB MIT PLANCK KEYBOARD (REV 6.x)
// ----------------------------------------------------------------------------
planck_w          = 233.00; // [USER_VERIFY] Bare switch plate & PCB width (mm)
planck_d          = 81.00;  // [USER_VERIFY] Bare switch plate & PCB depth (mm)
planck_plate_t    = 1.50;   // [USER_VERIFY] Top metal switch plate thickness (mm)
planck_pcb_drop   = 10.50;  // [USER_VERIFY] Distance from underside of switch plate to lowest PCB component (hotswap/piezo)
planck_keycap_h   = 12.00;  // [USER_VERIFY] Keycap clearance height above switch plate when lid is closed
planck_lip_w      = 2.00;   // Perimeter shelf supporting the edges of the 233x81mm switch plate

// OLKB Planck Rev 6 M2 Standoff Coordinates [x, y] measured from Front-Left corner of Planck
planck_mount_pts  = [
    [21.50,  21.50],
    [211.50, 21.50],
    [21.50,  59.50],
    [211.50, 59.50],
    [116.50, 40.50]
]; // [USER_VERIFY]

planck_usbc_x_off = 19.05;  // [USER_VERIFY] USB-C receptacle X offset from left edge of Planck PCB

// ----------------------------------------------------------------------------
// 4. TRACKBALL SUBSYSTEM (PER-01: 38.0mm Ball + Ploopy Nano 2 / PMW3360 + MR63ZZ)
// ----------------------------------------------------------------------------
tball_d           = 38.00;  // Standard 1.5-inch snooker/trackball diameter (mm)
tball_cup_clear   = 0.65;   // Radial clearance between 38mm ball and socket cup wall
tball_bearing_od  = 6.00;   // MR63ZZ bearing outer diameter (3x6x2.5mm)
tball_bearing_id  = 3.00;   // MR63ZZ bearing bore diameter
tball_bearing_w   = 2.50;   // MR63ZZ bearing width
tball_bearing_ang = 35.0;   // Elevation angle of the 3 roller bearings from bottom pole (deg)
tball_sensor_w    = 28.50;  // PMW3360 breakout / Ploopy Nano PCB pocket width
tball_sensor_d    = 22.00;  // PMW3360 breakout pocket depth
tball_lens_gap    = 2.40;   // PMW3360 optical lens working distance below bottom of 38mm ball
mx_cutout_w       = 14.00;  // Standard 14.0 x 14.0mm Cherry MX switch cutout for thumb click buttons

// ----------------------------------------------------------------------------
// 5. POWER BANK (PWR-01: INIU 45W SLIM) & USB-C PD HUB (HUB-01: UGREEN 105)
// ----------------------------------------------------------------------------
// Default Preset: INIU Carry P50-E1 / BI-B62 45W Slim (10,000 mAh, 15V/3A PD)
pbank_w           = 110.00; // [USER_VERIFY] Power bank length (mm) — Set to 134.0 for Baseus Blade HD
pbank_d           = 68.00;  // [USER_VERIFY] Power bank width (mm)  — Set to 134.0 for Baseus Blade HD
pbank_h           = 18.50;  // [USER_VERIFY] Power bank thickness (mm) — Set to 18.0 for Baseus Blade HD
pbank_foam_t      = 1.50;   // EVA/Poron shock & thermal isolation foam thickness
pbank_safe_gap    = 4.50;   // Mandatory safety clearance from battery wall to any M3 fastener boss

hub_w             = 115.00; // [USER_VERIFY] UGREEN Revodok 105 / Baseus 5-in-1 100W PD Hub length (mm)
hub_d             = 27.50;  // [USER_VERIFY] Hub width (mm)
hub_h             = 12.20;  // [USER_VERIFY] Hub height (mm)

// Rear Panel-Mount USB-C Socket (CAB-03)
panel_usbc_hole_w = 9.40;   // USB-C receptacle nose cutout width
panel_usbc_hole_h = 3.60;   // USB-C receptacle nose cutout height
panel_usbc_span   = 16.00;  // M2/M3 mounting ear center-to-center pitch

// ----------------------------------------------------------------------------
// 6. ADJUSTABLE FRICTION TORQUE HINGES (MEC-01: SOUTHCO E6-10-301-20 / CL226)
// ----------------------------------------------------------------------------
hinge_w           = 42.90;  // [USER_VERIFY] Hinge width along hinge axis (mm)
hinge_d           = 36.50;  // [USER_VERIFY] Total open leaf span perpendicular to axis (mm)
hinge_knuckle_d   = 12.70;  // [USER_VERIFY] Hinge barrel diameter / thickness (mm)
hinge_leaf_t      = 3.20;   // Hinge leaf thickness (mm)
hinge_hole_span_x = 25.40;  // [USER_VERIFY] Horizontal mounting hole pitch on each leaf (1.00 inch)
hinge_hole_span_y = 19.10;  // [USER_VERIFY] Distance between base leaf holes and lid leaf holes (0.75 inch)
hinge_x_offset    = 96.00;  // Distance from deck centerline (X=0) to Left (-96) and Right (+96) hinge centers

// ----------------------------------------------------------------------------
// 7. OVERALL CLAMSHELL ENCLOSURE ENVELOPE (DERIVED AUTOMATICALLY)
// ----------------------------------------------------------------------------
// X-Axis (Width): Left Margin (10) + Planck (233) + Divider (7) + Trackball Zone (48) + Right Margin (8) = 306.0 mm
deck_w            = 306.00;
// Y-Axis (Depth): Front Wrist Bevel (16) + Planck (81) + Rear Deck/USB-C Zone (47) + Hinge Spine (18) = 162.0 mm
deck_d            = 162.00;

// Layout Coordinates in Base Deck (Origin [0,0,0] = Center-X, Front-Y=0, Bottom-Z=0)
planck_x0         = -deck_w/2 + 10.00; // Left X edge of Planck cutout (-143.0 mm)
planck_y0         = 16.00;             // Front Y edge of Planck cutout (+16.0 mm from front edge)

tball_cx          = planck_x0 + planck_w + 31.00; // Trackball X center (+121.0 mm)
tball_cy          = planck_y0 + 52.00;            // Trackball Y center (+68.0 mm)

// Z-Axis Heights
base_bottom_h     = 24.50;  // Lower base tub height (2.5mm floor + 20.0mm battery/hub cavity + 2.0mm lip)
base_top_h        = 4.00;   // Top deck plate visible flange thickness (total base height = 28.50 mm)
base_total_h      = base_bottom_h + base_top_h;

lid_rear_h        = 15.00;  // Upper lid rear shell height (2.5mm back + 12.5mm Switch core & 90-deg USB-C cavity)
lid_bezel_h       = 3.00;   // Upper lid front bezel retainer flange thickness (total lid height = 18.00 mm)
lid_total_h       = lid_rear_h + lid_bezel_h;

// Switch Core Placement in Upper Lid (Centered on X=0, Y positioned above 90-deg USB-C channel)
sw_center_x       = 0.00;   // Switch centered horizontally in lid for balanced hinge torque
sw_bottom_y       = 26.00;  // Distance from hinge-side bottom edge of lid to Switch bottom edge

// ----------------------------------------------------------------------------
// 8. SHARED UTILITY MODULES
// ----------------------------------------------------------------------------

// Rounded rectangular prism centered in X, starting at Y=0, Z=0
module rounded_box_xcenter(w, d, h, r) {
    hull() {
        for (sx = [-1, 1], sy = [0, 1]) {
            translate([sx * (w/2 - r), r + sy * (d - 2*r), 0])
                cylinder(r = r, h = h);
        }
    }
}

// Standard DIN 934 Hex Nut Trap (flat-to-flat width w, depth h)
module hex_nut_trap(flat_w, depth) {
    cylinder(d = flat_w / cos(30), h = depth, $fn = 6);
}
