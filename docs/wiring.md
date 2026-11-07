# Phase 4: Electronics & Wiring Plan (`docs/wiring.md`)

This document specifies the internal electrical architecture, USB-C data and Power Delivery (PD) routing, inline overcurrent protection, RCM payload injection access, DIY trackball SPI pinout, and thermal management for the `ns-conv` clamshell cyberdeck.

---

## 1. Architecture Trade-Off: Internal USB-C PD Hub vs. Direct Soldered Harness

Requirement 4 asks us to compare connecting the **Drop × MIT Planck** and **Trackball** to the Switch's USB-C bus via a **small internal USB-C PD hub** vs. a **direct soldered wire harness**, and recommend one.

| Criterion | **Option A: Compact Internal USB-C PD 3.0 Hub (RECOMMENDED)** | **Option B: Direct Soldered Parallel Wire Harness (REJECTED)** |
| :--- | :--- | :--- |
| **USB 2.0 Data Integrity (`D+` / `D-`)** | **Active Hub Controller IC (`VL817` / `GL3523`):** Properly buffers and arbitrates USB packets from multiple downstream HID endpoints (Planck keyboard + Trackball + external USB-A port) onto the Switch's single upstream `D+/D-` pair with matched `90 Ω` differential impedance. | **Fails USB Specification:** USB is a point-to-point tiered-star bus, *not* a multi-drop shared bus like I2C or CAN. Soldering two USB devices in parallel onto `D+/D-` without a hub IC causes packet collisions and complete enumeration failure. |
| **Simultaneous `15V` PD Charging + USB Host Mode** | **Built-in USB-PD 3.0 Controller:** Automatically negotiates `15V @ 2.6A–3.0A` from the power bank on its PD input port and executes a **USB-PD Power Role Swap (`PR_Swap`)** over `CC1/CC2` so the Switch acts simultaneously as **USB Data Host (`DFP`)** and **15V Power Sink (`SNK`)**. | **Cannot Charge While Using Keyboard/Trackball:** A passive harness pulling `CC` to ground via a `5.1 kΩ` `Rd` resistor forces the Switch to output `5V VBUS` rather than sinking `15V` charge. |
| **Console Preservation & Reversibility** | **100% Plug-and-Play:** Connects to the Switch's stock bottom USB-C receptacle via a low-profile 90° flat FPC plug. Zero soldering on the Switch motherboard. | **High Risk of Board Damage:** Soldering wires to the `0.4 mm`-pitch `M92T36` / `P13USB` pads or USB-C tail violates Requirement 2 (reversibility) and risks lifting pads. |
| **Bonus External I/O** | Exposes **1× spare external USB 3.0 Type-A port** and **1× full-size 4K HDMI port** on the side wall of the base deck for free. | No extra ports or video output capability. |

**Engineering Verdict:** **Option A (Internal USB-C PD 3.0 Hub — `HUB-01`)** is mandatory for valid USB bus arbitration and simultaneous `15V` USB-PD charging while typing.

---

## 2. Internal Packaging & Compartment Fit Analysis

### 2.1 Why the Hub & Power Bank Live in the Base Half (Not the Switch Battery Bay)
- **Upper Lid (Switch Internal Battery Bay):** The Switch's factory-glued `4310 mAh` (`16 Wh`, `HAC-003`) LiPo cell measures `96.5 × 64.5 × 5.2 mm` and fills `100%` of the magnesium midframe's battery recess. We retain this internal battery in the lid so the Switch has uninterrupted UPS backup power whenever the base power bank is switched off or renegotiates PD.
- **Lower Base (Underneath the Planck + Trackball Deck):**
  - Base interior footprint: **`298 mm (W) × 155 mm (D) × 21 mm (Internal Z-Clearance below Planck PCB)`**.
  - **Front-Left Bay (`120 × 75 × 20 mm`):** Houses the **INIU 45W Slim Power Bank (`PWR-01`, `110 × 68 × 18.5 mm`)** cushioned on `1.5 mm` flame-retardant EVA/Poron pads with a `>= 3.5 mm` air gap from all fasteners.
  - **Rear-Center / Right Bay (`165 × 65 × 20 mm`):** Houses the **100W USB-C PD Hub (`HUB-01`, `115 × 27 × 12 mm`)**, the **Inline `5A` Blade Fuse Holder (`ELC-01`)**, the **Power Cutoff Switch (`ELC-02`)**, and the **Trackball Socket (`62 × 54 mm`)** with ample room for strain-relieved cable loops and passive airflow.
  - *Note:* Because the `HUB-01` aluminum body is only **`12.0 mm` thick**, it fits inside the `21.0 mm` base cavity **without even needing to decase its factory aluminum heat-spreader shell!**

---

## 3. Complete System Wiring Diagram

### 3.1 Mermaid System Schematic

```mermaid
flowchart TB
    subgraph LID["UPPER LID ENCLOSURE (Translucent Lilac SLA)"]
        SW_MB["Nintendo Switch v1 Mainboard (HAC-001)<br/>• Internal 4310mAh (16Wh) Battery Connected<br/>• 53-pin LCD & 34-pin Digitizer Untouched"]
        SW_USBC["Switch Bottom USB-C Port"]
        SW_RRAIL["Right Joy-Con ZIF Socket (10-Pin)"]
        SPARE_JIG["Spare Right Joy-Con Rail Flex / Jig<br/>(Pin 10 HOME/RCM & Pin 1 GND)"]
        RCM_SW["Recessed Momentary Tactile Switch (RCM-01)<br/>Top-Right Lid Edge (Normally Open)"]

        SW_MB --- SW_USBC
        SW_MB --- SW_RRAIL
        SW_RRAIL ==>|10-Pin ZIF| SPARE_JIG
        SPARE_JIG -->|Pin 10 RCM & Pin 1 GND<br/>30 AWG Silicone Pair| RCM_SW
    end

    subgraph HINGE["CENTRAL HINGE CHANNEL & REAR MODE JUNCTION"]
        CAB01["CAB-01: 90° Right-Angle Flat Flexible USB-C 3.1 Ribbon<br/>(20 cm, 100W PD + 10Gbps, Service Loop in Hinge)"]
        REAR_PKT["Rear Recessed Coupler Pocket<br/>• Normal Mode: Hub Upstream Plugged into CAB-01<br/>• RCM / Hekate UMS Mode: Unplug Hub & Connect PC/Dongle to CAB-01"]
    end

    subgraph BASE["LOWER BASE ENCLOSURE (Translucent Lilac SLA)"]
        HUB["HUB-01: Internal 5-in-1 USB-C PD 3.0 Hub (115×27×12 mm)<br/>• Upstream USB-C Cable (15 cm)<br/>• 100W USB-C PD Input Port<br/>• 3× USB-A Data Ports + 1× 4K HDMI"]
        PLANCK["DON-02: Drop × MIT Planck Rev 6 PCB<br/>(USB-C Receptacle, QMK 6KRO Mode)"]
        TBALL["PER-01: 38mm QMK Trackball<br/>(Ploopy Nano 2 / RP2040-Zero + PMW3360, USB-C)"]
        EXT_IO["Right-Side / Rear Exposed Cutouts<br/>• 1× Spare USB-A 3.0 Port<br/>• 1× 4K HDMI Out Port"]

        subgraph PWR_SUB["Isolated Power Bank & Fused PD Subsystem"]
            EXT_PD["CAB-03: Rear Panel-Mount USB-C PD Socket<br/>(External Wall Charger Input — 45W–65W PD)"]
            PBANK["PWR-01: INIU 45W Slim Power Bank (10,000mAh / 37Wh)<br/>• UN 38.3 Certified, 15V @ 3.0A PD Output<br/>• Port C1: In/Out Pass-Through | Port C2/Out: 15V PD Out"]
            SW_CUT["ELC-02: High-Current Power Cutoff Switch<br/>(Inline on VBUS — Isolates Bank in Storage)"]
            FUSE["ELC-01: Inline 5A Fast-Acting Blade Fuse<br/>(16 AWG Holder on VBUS — Overcurrent Protection)"]
        end
    end

    SW_USBC ==>|Low-Profile 90° Plug| CAB01
    CAB01 ==> REAR_PKT
    REAR_PKT ==>|Upstream Host + 15V PD Sink| HUB

    HUB -->|USB-A1 via CAB-02a<br/>15cm Flat USB-A to USB-C| PLANCK
    HUB -->|USB-A2 via CAB-02b<br/>15cm Flat USB-A to USB-C| TBALL
    HUB -.->|USB-A3 & HDMI Flush at Wall| EXT_IO

    EXT_PD ==>|20cm Panel Cable| PBANK
    PBANK ==>|15V PD Output<br/>CC1/CC2 + GND Continuous| SW_CUT
    SW_CUT ==>|VBUS (15V max 3A)| FUSE
    FUSE ==>|15V PD Feed into Hub PD Port| HUB
```

---

### 3.2 Detailed ASCII Wiring & Fused PD Cable Splice Diagram

To ensure the **INIU 45W Power Bank (`PWR-01`)** negotiates **15V USB-PD** with the **Internal Hub (`HUB-01`)** while still having a physical **Power Cutoff Switch (`ELC-02`)** and **Inline `5A` Blade Fuse (`ELC-01`)**, the `CC1/CC2` configuration channel and `GND` return must remain unbroken while `VBUS` (`+5V` to `+15V`) passes in series through the switch and `5A` fuse:

```text
================================================================================
       FUSED 15V USB-C PD POWER LINE DETAIL (POWER BANK -> INTERNAL HUB)
================================================================================

  [INIU 45W Slim Power Bank]                       [Internal USB-C PD Hub]
  (USB-C PD Output Port: 15V/3A)                   (100W USB-C PD Input Port)
  +----------------------------+                   +---------------------------+
  |                            |                   |                           |
  |  VBUS (+5V / +15V PD) o----+---[ SW: ELC-02 ]--+--[ FUSE: 5A Fast ELC-01 ]-+-o VBUS
  |                            |   (Panel/Inline   |  (16 AWG Mini Blade Fuse) |
  |                            |    Power Cutoff)  |                           |
  |  CC1 (PD BMC Comms)   o----+-------------------+---------------------------+-o CC1
  |  CC2                  o----+-------------------+---------------------------+-o CC2
  |  GND (Power Return)   o----+-------------------+---------------------------+-o GND
  +----------------------------+                   +---------------------------+

  HOW TO ASSEMBLE THIS CABLE IN 5 MINUTES (Using ELC-01 + ELC-02):
  1. Take the short USB-C PD Switch Cable (ELC-02).
  2. Carefully slit 25 mm of the outer PVC jacket midway along the cable (do not
     nick the inner wire insulation).
  3. Separate the thick RED wire (VBUS). Leave the BLACK (GND) and thin BLUE/WHITE/
     YELLOW (CC1/CC2) wires completely uncut!
  4. Cut only the RED (VBUS) wire and solder/crimp the two 16 AWG leads of the
     Inline 5A Blade Fuse Holder (ELC-01) in series with the two red ends.
  5. Insulate the splice with heat-shrink tubing and insert the 5A fast blade fuse.
================================================================================
```

---

## 4. Solving the RCM Payload Injection & Hekate UMS Mode Challenge

### 4.1 The Electrical Constraint
- During normal use in **Horizon OS** or **Switchroot L4T Ubuntu**, the Switch is a **USB Host (`DFP`)** reading the Planck keyboard and Trackball through `HUB-01`.
- However, when entering **Recovery Mode (`RCM`, USB `APX 0955:7321`)** to inject the `hekate` payload—or when using **Hekate's USB Mass Storage (`UMS`)** tool to transfer files to the microSD card from a PC—the Switch acts as a **USB Device (`UFP`)**. A USB Device cannot be enumerated *backwards* through the downstream port of a standard USB hub.

### 4.2 The Zero-Solder Solution: Rear Recessed Mode Coupler Pocket
Our CAD design routes the female end of the **`20 cm` 90° Flat Flexible USB-C Extension Ribbon (`CAB-01`)** (which comes directly from the Switch's bottom USB-C port through the hinge) to a **Recessed Rear Coupler Pocket** at the back of the base enclosure, right alongside the male upstream plug of the internal hub (`HUB-01`):

```text
  REAR VIEW OF BASE ENCLOSURE — RECESSED COUPLER & CHARGING POCKET
  +----------------------------------------------------------------------+
  |  [1: Rear Panel USB-C PD In]   [2: Switch Direct USB-C]  [3: Hub Plug]|
  |         (CAB-03)                     (CAB-01 Female)     (HUB-01 Male)|
  |           (===)                          (===) <------------ [===]   |
  |     Charges Power Bank               Normal Mode: Hub Plugged In     |
  |                                      RCM Mode: Plug PC/Dongle Here!  |
  +----------------------------------------------------------------------+
```

- **Mode 1 — Normal Desktop / Gaming Use (Default):** The short flexible upstream tail of `HUB-01` plugs directly into `CAB-01` inside the recessed rear pocket and snaps under a printed retainer clip. The Planck, Trackball, and 15V PD charging all route automatically to the Switch.
- **Mode 2 — RCM Payload Injection / Hekate UMS SD Card Access:** Unplug the `HUB-01` male plug from `CAB-01` at the rear pocket and plug your PC USB-C cable (or a pocket RCM payload dongle) directly into `CAB-01`. Hold the lid's **RCM Button (`RCM-01`) + `Volume +`** and tap **`Power`** to inject `hekate`, then plug `HUB-01` back into `CAB-01`!

---

## 5. DIY AliExpress 38 mm Trackball (`RP2040-Zero` + `PMW3360`) SPI Wiring

If you purchase the **`€21.50` AliExpress DIY Trackball Kit (`PER-01`)** instead of the pre-assembled `$69.99 CAD` Ploopy Nano 2 from Canada, solder these **6 short `28–30 AWG` silicone wires** between the **Waveshare `RP2040-Zero`** and the **`PMW3360` Optical Sensor Breakout Board**:

| `PMW3360` Breakout Pin | Function | `RP2040-Zero` Pin | Wire Color (Suggested) | Electrical Notes |
| :--- | :--- | :--- | :--- | :--- |
| **`VCC` / `VDD`** | `+3.3V` Logic & Sensor Power | **`3V3`** *(Pin 36 / 3.3V LDO Out)* | Red | **WARNING:** Connect to `3V3` (`3.3V`), **NEVER** to `5V`/`VBUS`! |
| **`GND`** | Ground Return | **`GND`** | Black | Common ground reference |
| **`SCLK` / `SCK`** | SPI0 Clock | **`GP2`** (`SPI0 SCK`) | Yellow | Standard QMK `RP2040` hardware SPI0 clock |
| **`MISO` / `SO`** | SPI0 Master-In Slave-Out | **`GP0`** (`SPI0 RX`) | Green | Sensor data to MCU |
| **`MOSI` / `SI`** | SPI0 Master-Out Slave-In | **`GP3`** (`SPI0 TX`) | Blue | MCU commands to sensor |
| **`NCS` / `CS`** | SPI0 Chip Select (Active Low) | **`GP1`** (`SPI0 CSn`) | White | Pull-up handled by QMK driver |
| **`RST`** *(if exposed)* | Sensor Reset (Active Low) | Tie to **`3V3`** *(or `GP4`)* | Orange | Most breakouts pull `NRESET` high internally via `10 kΩ` |

### Flashing QMK to the `RP2040-Zero` Trackball
1. Hold the **`BOOT`** button on the `RP2040-Zero` while plugging it into your PC via USB-C; it mounts as a USB drive named `RPI-RP2`.
2. Compile or download the standard QMK `ploopyco/nano` or `pmw3360` RP2040 `.uf2` firmware with `POINTING_DEVICE_DRIVER = pmw3360` and drag-and-drop the `.uf2` file onto `RPI-RP2`.
3. It immediately reboots as a standard **1000 Hz USB HID Mouse** that works plug-and-play in **Switchroot L4T Ubuntu** and mouse-enabled **Horizon OS** games!

---

## 6. Thermal Dissipation & Battery Safety Engineering

```text
  SIDE CROSS-SECTION — THERMAL ISOLATION & AIRFLOW PATHS
  
               UPPER LID (Switch Core ~12–18W Peak)
              //==================================\\
             //  [Top Exhaust Louver: 42 x 6 mm]   \\  ---> Hot Air Out (Fan)
            //         ^ Copper Heatpipe/Fan        \\
           //          |                             \\
          //   [Switch Mainboard + 4310mAh Battery]   \\
         //    [Rear Intake Slots: 2x 18 x 4 mm] <-----\\-- Cool Air In
        //==============================================\\
       ( O )  <-- Hinge Axis + Air Gap (~12mm Thermal Break)
  +-------------------------------------------------------------------+
  |  [ Drop x MIT Planck 233x81mm ]    [ 38mm Trackball ]             |
  |  ---------------------------------------------------------------  |
  |  ====== 2.0mm SLA Barrier Wall + 1.5mm EVA/Poron Foam Pad ======  |
  |  [ INIU 45W Slim Power Bank ]      [ UGREEN 100W PD Hub ]         |
  |    (Max ΔT < 12°C at 15V/1.2A)       (Aluminum Heat-Spreader)     |
  +------^^^^^------------------------------^^^^^---------------------+
         ||||| Bottom Intake Louvers        ||||| Rear/Side Exhaust
```

1. **Full Physical Separation of Heat Sources:**
   - The **Switch Tegra X1 SoC (`~12–18W` peak thermal load)** sits in the **upper lid**, actively cooled by its stock centrifugal fan. Our upper lid rear shell (`cad/lid_rear.scad`) replicates the exact OEM intake grille geometry (`2× 18 × 4 mm` bottom-rear mesh slots) and top exhaust louver (`42 × 6 mm`) with zero restriction.
   - The **INIU 45W Slim Power Bank (`PWR-01`)** sits in the **lower base**, separated from the Switch mainboard by the hinge air gap and isolated from the Planck PCB above by a **`2.0 mm` solid SLA structural rib wall + `1.5 mm` flame-retardant EVA/Poron foam sheet**.
2. **Low-Stress Power Bank Operating Point:**
   - Even when the Switch is under 100% load while charging (`~18W` at `15V @ 1.2A`), the `45W`-rated INIU power bank operates at only **`40%` of its rated continuous output (`18W / 45W`)**, keeping DC-DC converter efficiency above `91%` and surface temperature below `36°C`.
3. **Mechanical Fastener Clearance Around the Power Bank:**
   - The power bank retention bay uses a **bolt-on SLA strap bracket (`cad/battery_retainer.scad`)** whose `M3` screws thread into bosses located **`4.5 mm` outside** the perimeter of the INIU power bank—no screw tip ever points toward the lithium-polymer casing.

---

## 7. Complete Cabling & Electrical Shopping List Checklist

All cabling and electrical items below match [`docs/bom.md`](bom.md) and [`hardware/BOM.csv`](../hardware/BOM.csv):

- [ ] **`HUB-01`:** `1×` 5-in-1 100W USB-C PD Hub (`UGREEN Revodok 105` or `Baseus`, `115 × 27 × 12 mm`, with `100W PD In` + `3× USB-A` + `HDMI`).
- [ ] **`CAB-01`:** `1×` `20 cm` 90° Right-Angle Flat Flexible USB-C 3.1 Male-to-Female Extension Ribbon (`100W PD` + `10 Gbps` data, routes from Switch bottom port through hinge to rear coupler pocket).
- [ ] **`CAB-02`:** `2×` `15 cm` Flat Silicone USB-A Male to USB-C Male Data Cables (connects `HUB-01` USB-A1/A2 to Planck Rev 6 and 38 mm Trackball).
- [ ] **`CAB-03`:** `1×` `20 cm` Rear Panel-Mount USB-C Female-to-Male PD Extension Cable (`M2/M3` screw ears, `16 mm` hole spacing, connects external wall charger to Power Bank input).
- [ ] **`ELC-01`:** `1×` `16 AWG` Inline Blade Fuse Holder + `5A` Fast-Acting Blade Fuse (spliced in series with the `VBUS` red wire between Power Bank output and Hub PD input).
- [ ] **`ELC-02`:** `1×` `15–20 cm` USB-C Male-to-Female Inline Power Cutoff Switch Cable (connects Power Bank `15V` PD output to `HUB-01` PD input through the `5A` fuse).
- [ ] **`RCM-01`:** `1×` `6×6×5 mm` Momentary Tactile Pushbutton Switch + `20 cm` of `28–30 AWG` flexible silicone wire (wired to Pin 10 `RCM` and Pin 1 `GND` on your spare Right Joy-Con rail/jig).
