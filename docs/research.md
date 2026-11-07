# Phase 1: Research Summary — Nintendo Switch v1 Clamshell Cyberdeck (`ns-conv`)

## 1. Executive Summary

This document establishes the engineering baseline, prior-art evaluation, donor verification protocol, and subsystem trade-offs for converting an unpatched **2017 Nintendo Switch v1 (Erista, `HAC-001`)** into a reversible, dual-booting (**Horizon OS + Switchroot L4T Ubuntu**) **clamshell cyberdeck** housed in a custom **translucent lilac SLA-printed enclosure**.

### Key Architectural Decisions Validated by Research
1. **Mainboard + Display Stay Together in the Lid:** Separating the Switch's 6.2" LCD from its mainboard requires extending a 53-pin high-speed MIPI DSI ribbon across a hinge—a major failure point in prior art due to signal reflection and mechanical fatigue. Keeping the Switch's factory-bonded LCD, digitizer, die-cast magnesium midframe, mainboard, cooling fan, and 4310 mAh battery as a unified core inside the lid means **only a single flexible USB-C connection crosses the hinge**.
2. **100% Reversible, Non-Destructive Mod:** Only the Switch's outer plastic rear cover and detachable Left/Right Joy-Con rails are unbolted. The 10 precision M2 threaded bosses along the left and right edges of the Switch's metal midframe (originally holding the Joy-Con rails) serve as structural mounting anchors inside the custom lid shell.
3. **Planck QMK Must Run in 6KRO Mode for Horizon OS:** Stock Horizon OS natively supports standard USB HID keyboards for text entry and compatible games, **but only via the 6-Key Rollover (6KRO) USB HID descriptor**. Enabling NKRO in QMK causes Horizon OS to ignore the keyboard; L4T Ubuntu supports both 6KRO and NKRO natively.
4. **Thermoset SLA Resin Fastening Strategy:** Translucent lilac is achieved via **clear SLA resin (`PCBWay UTR-8100 Transparent` or `JLC3DP 8001 Translucent`) + custom Pantone lilac immersion dyeing + UV-resistant clear urethane coat**. Because SLA resin is a *thermoset* (it chars/cracks under a hot soldering iron rather than melting like FDM PLA/ABS), screw bosses must use **captive hex nuts, factory-tapped threads, or bonded/cold-press knurled brass inserts** rather than thermal heat-set inserts.

---

## 2. Donor Hardware Verification (Pre-Disassembly Protocol)

Before purchasing parts or loosening a single screw on the donor console, the user **must verify** that the Switch is an unpatched **Erista (`HAC-001`)** vulnerable to the `fusee-gelee` coldboot BootROM exploit.

### 2.1 Model & Serial Number Check
1. **Check the Model Number on the Rear Shell:**
   - **Valid:** `MOD. HAC-001` (2017–mid-2018 Erista Tegra X1 `T210`).
   - **Invalid:** `MOD. HAC-001(-01)` (2019+ Mariko Tegra X1+ `T214`—patched BootROM, incompatible with `fusee-gelee`).
2. **Verify the Serial Number (Sticker on Bottom Edge AND in `System Settings → System → Serial Information`):**
   *Always verify the serial number inside `System Settings` to rule out a swapped plastic backplate.*

| Region Prefix | Unpatched (Guaranteed Vulnerable) | Potentially Patched (Mixed Transition Batch) | Patched (Not Vulnerable to `fusee-gelee`) |
| :--- | :--- | :--- | :--- |
| **XAW1** (NA) | `XAW10000000000` – `XAW10074000000` | `XAW10074000000` – `XAW10120000000` | `> XAW10120000000` |
| **XAW4** (NA) | `XAW40000000000` – `XAW40011000000` | `XAW40011000000` – `XAW40012000000` | `> XAW40012000000` |
| **XAW7** (NA) | `XAW70000000000` – `XAW70017800000` | `XAW70017800000` – `XAW70030000000` | `> XAW70030000000` |
| **XAJ1** (EU/JP) | `XAJ10000000000` – `XAJ10020000000` | `XAJ10020000000` – `XAJ10030000000` | `> XAJ10030000000` |
| **XAJ4** (EU/JP) | `XAJ40000000000` – `XAJ40046000000` | `XAJ40046000000` – `XAJ40060000000` | `> XAJ40060000000` |
| **XAJ7** (EU/JP) | `XAJ70000000000` – `XAJ70040000000` | `XAJ70040000000` – `XAJ70050000000` | `> XAJ70050000000` |

*Cross-reference tool:* [ismyswitchpatched.com](https://ismyswitchpatched.com/) and the [NH Switch Guide Serial Reference](https://nh-server.github.io/switch-guide/user_guide/getting_started/).

### 2.2 Mandatory Live RCM (`fusee-gelee`) Test Before Disassembly
Even if the serial number falls in the "Unpatched" range, a refurbished unit could have a replacement motherboard. Perform this non-invasive test before teardown:
1. Power the Switch completely **OFF** (hold Power for 3 seconds → *Power Options* → *Turn Off*).
2. Slide a plastic **RCM Jig** into the **Right Joy-Con rail** (bridging Pin 10 `HOME/RCM` to Ground Pin 1/7). *Never use a bent metal paperclip, which can bend Pin 9 (`+5V`) onto Pin 10 and fry the rail controller.*
3. Hold **Volume Up (`+`)** and press **Power** once. The screen will remain **completely black** (this is normal in Recovery Mode).
4. Connect the Switch via USB-C to a PC/Mac/Linux host:
   - **macOS/Linux:** Run `lsusb` or check `ioreg -p IOUSB` for `NVIDIA Corp. APX` (`VID:PID 0955:7321`).
   - Inject the `hekate` payload using `fusee-nano`, `Rekado` (Android), or `WebFG` / `TegraRcmGUI`.
5. **Pass Criteria:**
   - Payload Smash returns `0x7000` bytes transferred and the Switch display lights up into the **Hekate graphical bootloader menu**.
   - While in this pre-teardown check, test **touchscreen digitizer responsiveness**, **Wi-Fi/Bluetooth**, **microSD card reader**, **fan spin**, and **15V USB-C PD fast charging** in both USB-C connector orientations.

---

## 3. Prior Art Survey: What to Copy vs. What to Avoid

We surveyed existing Nintendo Switch clamshell/laptop conversions and Planck-based 40% ortholinear cyberdecks to identify proven mechanical patterns and avoid known dead ends.

| Prior Art Project / Category | Architecture Summary | Techniques to COPY | Mistakes to AVOID & Why |
| :--- | :--- | :--- | :--- |
| **Switch MIPI-Extension Clamshell Mods** *(GBA-SP style / split-board discussions on GBAtemp & Reddit `r/SwitchHacks`)* | Attempts to place the Switch mainboard in the base half and run extended 53-pin LCD MIPI DSI, 34-pin digitizer, and 4-pin backlight ribbons through a hinge to the lid. | None for the display bus. | **AVOID extending the 53-pin MIPI DSI ribbon.** MIPI DSI uses multi-gigabit low-voltage differential signaling without re-timers. Even a 10 cm passive FPC extension introduces severe impedance mismatch, EMI, and black-screen failures. |
| **Full Front-Housing / OLED Unbonding Swaps** *(eXtremeRate full shell swaps, Retro Remake Super5)* | Heating the front bezel to 80°C and prying the glued glass digitizer, LCD panel, and LiPo battery out of the stock magnesium midframe. | Reusing OEM M2 screw boss patterns for drop-in alignment. | **AVOID unbonding the LCD/digitizer or prying out the glued LiPo battery.** Prying the digitizer risks cracking the glass or trapping dust on the LCD; prying the glued 4310 mAh battery risks cell puncture and thermal runaway. |
| **Switch Clamshell / "Switch SP" Tablet-in-Lid Builds** *(Bob Wulff / Printables / MakerWorld)* | Houses the intact Switch tablet core in the upper lid and routes a low-profile 90° USB-C OTG cable to the base controller/keyboard. | **COPY tablet-in-lid architecture** and low-profile 90° right-angle USB-C plug with printed mechanical strain relief. | Avoid bulky consumer docks or unshielded 3D-printed PLA friction hinges that wear loose after ~50 cycles. |
| **Planck 40% Ortholinear Cyberdecks** *(READY! Model 100, Penkesu Computer, Yarh.io, `r/cyberDeck` Planck builds)* | Recesses a `233 × 81 mm` Planck plate/PCB assembly into the top deck above a flat battery/hub bay, using constant-torque metal laptop hinges. | **COPY recessed Planck top-plate mounting**, constant-torque metal friction hinges (`Southco E6` / `Sugatsune`), and placing the heavy power bank in the base for a low center of gravity. | Avoid routing rigid round USB cables through hinge knuckles; use flat flexible USB-C ribbon cables with dedicated service loops. |

### Resulting Mechanical Strategy for `ns-conv`
- **Upper Lid:** Retains the Switch v1 **front bezel + glass digitizer + LCD + die-cast magnesium midframe + mainboard + heatpipe/fan + speakers + stock 4310 mAh battery** as a single untouched factory sub-assembly (`~265 g` once the plastic backplate and metal Joy-Con rails are unscrewed).
- **Structural Lid Anchoring:** The Switch's magnesium midframe has **5× M2 threaded holes on the left edge** and **5× M2 threaded holes on the right edge** (originally securing the Joy-Con rails), plus the rear backplate screw bosses. Our translucent lilac SLA lid bolts directly into these 10 metal-threaded side holes via internal aluminum/printed brackets tied directly to the metal friction hinges.

---

## 4. Keyboard Integration: Drop × MIT Planck (40% Ortholinear)

### 4.1 Mechanical & PCB Specifications
- **Footprint (PCB & Switch Plate):** `233.0 mm × 81.0 mm` (official OLKB / Drop Planck specification; source: [`olkb/olkb_parts`](https://github.com/olkb/olkb_parts)).
- **Key Matrix:** 4 rows × 12 columns (47 keys in MIT layout with a central `2u` spacebar on the bottom row; `19.05 mm` standard MX key spacing).
- **Z-Height Stackup:**
  - Switch plate top to PCB bottom: `~10.8 mm` (`1.5 mm` plate + `3.5 mm` switch housing to PCB + `1.6 mm` PCB + `~4.2 mm` SMD components/hotswap sockets and USB-C receptacle clearance).
  - Keycap height above plate: `~8.5 mm` (DSA/XDA) to `~11.5 mm` (OEM/MT3).
- **Mounting Holes (M2 Standoffs between Plate & PCB → Case):**
  - Standard Drop Planck Rev 6 (Lo-Pro / Mid-Pro / Hi-Pro) uses M2 standoffs sandwiched between the switch plate and PCB, with through-holes in the PCB accepting M2 screws from the case floor.
  - Typical OLKB Rev 6 mounting coordinates (measured from top-left PCB corner, to be verified against the user's exact revision in Phase 3/5):
    - Left/Right pair: `(21.5 mm, 21.5 mm)`, `(211.5 mm, 21.5 mm)`, `(21.5 mm, 59.5 mm)`, `(211.5 mm, 59.5 mm)` and center `(116.5 mm, 40.5 mm)`.
  - Additionally, our base enclosure CAD will include a **full perimeter support ledge (`1.5 mm` shelf supporting the edges of the `233 × 81 mm` switch plate)** plus slotted M2 bottom mounting bosses so both Drop Lo-Pro and Hi-Pro Planck revisions drop in without modification.

### 4.2 USB HID Behavior in Horizon OS vs. Switchroot L4T Ubuntu

| Feature / Scenario | Stock / CFW Horizon OS | Switchroot L4T Ubuntu (Linux) | Engineering Requirement / Workaround |
| :--- | :--- | :--- | :--- |
| **USB Enumeration** | Native USB HID Boot/Report Keyboard driver (`hid` sysmodule). | Native Linux kernel `usbhid` / `libinput` driver. | **CRITICAL:** Horizon OS **only supports 6KRO (6-Key Rollover)**. If QMK `NKRO` is active, the keyboard will not respond in Horizon OS! Toggle QMK to 6KRO (`Magic + N` or `NKRO_ENABLE = no`). |
| **System Text Input** *(Wi-Fi passwords, eShop, naming, chat)* | **100% Supported Natively.** Typing on the Planck immediately fills any Horizon OS on-screen keyboard prompt. | **100% Supported Natively** across all desktop apps, terminal, browsers, and login prompt. | Works out of the box in 6KRO mode. |
| **In-Game Keyboard Input** | Works natively in games with USB keyboard support (*Minecraft*, *Quake*, *Doom*, *Skyrim* naming, *Factorio*, *Monster Hunter* chat). | Works natively in all Linux games, Steam/Box64 titles, and emulators. | None required for keyboard-aware titles. |
| **Horizon OS Home Menu Navigation / Controller-Only Games** | **Not supported via standard USB Keyboard HID.** Stock Horizon OS requires a gamepad input or touchscreen to navigate the Home menu. | Full desktop/window navigation via keyboard shortcuts. | **Conflict & Honest Workaround:** In stock Horizon OS, use the capacitive touchscreen or a wirelessly paired Joy-Con/Pro Controller (or on `emuNAND` CFW, install the [`sys-con`](https://github.com/o0Zz/sys-con) sysmodule or flash a secondary QMK/GP2040-CE gamepad descriptor). |

---

## 5. Trackball Selection & Integration Research

Because Horizon OS and L4T Linux sit in a compact clamshell base alongside a `233 × 81 mm` Planck keyboard, we evaluated four off-the-shelf USB HID trackball solutions against footprint, height, open-source CAD availability, and dual-OS compatibility.

### 5.1 Candidate Comparison

| Candidate | Dimensions (`L × W × H`) | Ball Ø | MCU / Sensor / Firmware | Buttons | Pros & Cons for `ns-conv` |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Ploopy Nano 2 (Recommended — Side or Top-Right Mount)** | `62 × 54 × 49 mm` (or `~48 × 48 × 36 mm` bare PCB + integrated socket) | `38.0 mm` (1.5") | RP2040 + PAW-3222 Optical Sensor, **QMK / VIA** (USB-C) | Via Planck QMK keys (or 2 added MX switches) | **Best ergonomics & open-source CAD.** Full 38 mm finger ball; STEP files on GitHub (`ploopyco/nano-trackball`); standard USB HID mouse. Left/Right/Middle click & Drag-Scroll sit right under the thumb on the Planck bottom row. |
| **2. Perixx PERIPRO-506 / Industrial 14mm USB Trackball Module (Recommended — Palm-Rest Mount)** | `~45 × 45 × 22 mm` module | `14.0 mm` / `16.0 mm` | Integrated USB 2.0 HID optical/laser controller | 2 integrated microswitches (L/R click) | **Best low-profile option (`22 mm` tall).** Fits centered in a narrow front palm rest below the Planck spacebar without adding width to the deck. |
| **3. ProtoArc EM04 / Perixx PERIMICE-517 (Decased Thumb Trackball)** | `~133 × 100 × 45 mm` (stock shell) | `34.0 mm` | Proprietary USB / 2.4GHz / BT PCB | 5 buttons + scroll wheel | Requires destructive decasing of an irregularly shaped consumer PCB; adds `~85 mm` width to the right of the Planck. |
| **4. Pimoroni Trackball Breakout (`PIM447`)** | `25 × 22 × 9.5 mm` | `4.5 mm` | Nuvoton I2C slave (`0x0A`), RGBW LED + click | Push-to-click | **Not standalone USB.** Requires soldering 4 I2C wires to the Planck PCB and compiling custom QMK firmware; tiny 4.5 mm ball fatigues fingers during desktop Linux use. |

### 5.2 Recommendation & Layout Options
We recommend **Ploopy Nano 2** as the primary choice (mounted to the right of the Planck keyboard in a dedicated socket, creating a comfortable right-hand finger trackball layout with Left/Right click on the Planck's bottom-right keys or two flanking choc/MX switches), **OR** a **low-profile 14–19 mm panel-mount USB HID optical trackball module** if you prefer a narrower symmetrical deck (`~255 mm` total width) with the trackball centered below the spacebar. *(See Open Questions at the end of this document to lock in your preference before CAD.)*

### 5.3 Trackball OS Behavior
- **Switchroot L4T Ubuntu:** Standard USB HID Mouse descriptor works immediately at boot (cursor, left/right/middle click, and QMK drag-scrolling).
- **Horizon OS:** Stock Horizon OS has **no mouse pointer in the Home Menu** (pointer actions use the capacitive touchscreen), **but** games that implement Nintendo's `Mouse` HID API (*Quake*, *Doom I/II/64*, *Factorio*, *Game Builder Garage*, *Hypnospace Outlaw*, *Minecraft* Bedrock, *Mario Paint* NSO) natively recognize a standard USB HID trackball!

---

## 6. Additional Battery (Slim USB-C PD Power Bank) & Charging Topology

### 6.1 Switch v1 Power Delivery Requirements
The Switch v1 (`HAC-001`) uses a **ROHM `BM92T36` USB-PD controller** paired with a **Texas Instruments `BQ24193` battery charger IC**.
- For maximum charging speed while playing (up to `~18W` total draw), the power source **must advertise a `15V` USB-PD Fixed PDO (`15V @ 2.6A` or `15V @ 3.0A`)**.
- Standard 5V/9V banks charge slowly (`~7.5W` max) and allow the internal battery to drain during heavy CPU/GPU workloads in L4T Ubuntu.

### 6.2 Comparison of Candidate Slim UN 38.3 USB-C PD Power Banks

All candidates below are factory-sealed commercial lithium-polymer packs certified to **UN 38.3**, **CE**, **FCC**, and **UL 2056**:

| Model | Capacity | Dimensions (`L × W × H`) | Weight | USB-C PD Output (15V PDO) | Pass-Through Support | Fit & Verdict for Base Half |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Baseus Blade HD 100W (`PPBLD100-HD`) — Recommended Primary** | `20,000 mAh` (`74 Wh`) | **`134 × 134 × 18.0 mm`** | `445 g` | `2× USB-C` (up to `100W`, includes **`15V/3A`** & `20V/5A`), `2× USB-A` | **Yes** (simultaneous 60W in / 30W–45W out; briefly renegotiates on plug/unplug) | **Best Z-Height (`18.0 mm`) & Capacity.** Sits completely flat underneath the Planck keyboard tray (`233 × 81 mm`), adding ~3.5× runtime (`~92 Wh` total system energy with Switch's `16 Wh` battery). |
| **2. Baseus Blade 100W Original (`PPBLD100-S`)** | `20,000 mAh` (`74 Wh`) | `162 × 143 × 18.0 mm` | `490 g` | `2× USB-C` (`100W`, **`15V/3A`**), `2× USB-A` | **Yes** | Equally thin (`18.0 mm`), requires `~20 mm` deeper base enclosure than the Blade HD (`143 mm` vs `134 mm`). |
| **3. INIU B62 / P50-E1 45W Slim (Lightweight Alternative)** | `10,000 mAh` (`37 Wh`) | `~110 × 68 × 18.5 mm` | `~210 g` | `USB-C` (`45W` PD, **`15V/3A`**) | **Yes** | Half the weight and footprint of the Baseus Blade HD (`+1.8×` runtime extension). Ideal if keeping total cyberdeck weight under `1.1 kg` is prioritized over maximum battery life. |
| **4. Anker 537 PowerCore 24K 65W (`A1379`)** | `24,000 mAh` (`86.4 Wh`) | `160 × 85 × 26.5 mm` | `500 g` | `2× USB-C` (`65W` PD, **`15V/3A`**) | **No** (disables USB-C PD output while charging via USB-C1) | Too thick (`26.5 mm` adds 8.5 mm to base height) and lacks USB-C-to-USB-C pass-through. **Eliminated.** |

### 6.3 Charging, Data & Safety Architecture
To allow a **single external USB-C port** to charge the cyberdeck while also allowing direct USB-C connection to the Switch (for initial RCM payload injection or Hekate USB Mass Storage access to the microSD card without opening the lid):
1. **Normal Operating & Pass-Through Mode:**
   - The **Switch's bottom USB-C port** plugs via a custom-clamped low-profile 90° right-angle USB-C ribbon cable into the upstream port of a **compact internal USB-C PD 3.0 Hub** in the base.
   - The **Planck keyboard** and **Trackball** plug into two of the hub's USB 2.0/3.0 downstream HID ports.
   - The **Baseus Blade HD (`USB-C2 Out`)** feeds the hub's **USB-C PD Power-In port** through a **panel-accessible High-Current Slide Switch** and an **inline 5A Fast-Acting Blade/Cartridge Fuse**. This lets you turn off power-bank charging when the Switch internal battery is full or stored, preventing continuous trickle-charge wear.
   - The **Baseus Blade HD (`USB-C1 In/Out`)** connects to a rear panel-mount **External Charging USB-C Port**. Plugging a 65W+ wall charger into the rear port recharges the Baseus Blade HD while simultaneously passing power through to the Switch.
2. **RCM Payload Injection / USB Device Mode:**
   - Because `fusee-gelee` RCM payload injection requires the Switch to act as a **USB Device (`APX 0955:7321`)** rather than a USB Host (a USB-C hub places the Switch in Host mode via `CC` pull-down `Rd`), we will evaluate two clean options in Phase 4 (Wiring):
     - **Option 1 (Internal Switchable USB-C 2:1 Mux / Short Extension Header):** A small rear access port or DPDT/USB-C mux switch that switches the Switch's USB-C port between the Internal Hub (Normal Host Mode) and External Port / Dongle (RCM Device Mode).
     - **Option 2 (Internal Zero-Solder RCM Dongle Docked in Lid/Base):** An off-the-shelf USB-C payload injector (e.g., RCMLoader One or an RP2040-Tiny flashed with `fusee-nano`) connected on the Switch USB-C line during the first 2 seconds of boot before the hub enumerates.
3. **Mandatory Thermal & Mechanical Safety Rules:**
   - **Certification:** Only factory-sealed UN 38.3 certified packs (Baseus Blade HD or INIU 45W).
   - **Fastener Clearance:** Minimum `3.5 mm` clearance between the power bank casing and any screw tip, standoff, or metal edge; an unbroken `2.0 mm` SLA barrier wall plus `1.5 mm` flame-retardant Poron/silicone foam pads isolate the battery bay from the Planck PCB above it.
   - **Thermal Isolation:** Because the Switch mainboard resides in the **upper lid** and the power bank resides in the **lower base**, the two heat sources are physically separated across the air gap of the clamshell! Dedicated bottom intake slots and rear exhaust louvers cool the power bank bay passively.

---

## 7. Boot Selection & Console Preservation Without Joy-Cons

Since the Switch is mounted inside the upper lid without removable Joy-Cons attached to the sides, boot navigation and RCM entry must work reliably using only hardware accessible on the deck:

1. **Entering RCM (`fusee-gelee`) Non-Destructively:**
   - We do **not** use `AutoRCM` (which modifies `BOOT0` on `sysNAND` and prevents normal stock cold-booting without a payload injector).
   - Instead, a tiny **Right-Rail RCM Flex Adapter (or modified replacement Right Joy-Con rail ribbon)** connects to the Switch's Right Joy-Con ZIF header (or slides into the preserved Right rail inside the lid bezel) and routes **Pin 10 (`RCM`)** and **Pin 1 (`GND`)** to a recessed **momentary tactile "RCM Boot" button** on the upper lid edge.
   - **To boot pure Stock Horizon OS (`sysNAND`):** Simply press **Power** (do not hold the RCM button). The Switch boots 100% untouched stock firmware for safe online play.
   - **To boot Hekate (`Kefir CFW emuNAND` or `Switchroot L4T Ubuntu`):** Hold **[RCM Button] + [Volume Up]** and press **Power**, then inject `hekate`.
2. **Navigating the Boot Menu Without Joy-Cons:**
   - **Hekate Nyx GUI** has **full native capacitive touchscreen support**! Once Hekate boots, the user simply taps **Launch → Kefir emuNAND** or **More Configs → Switchroot L4T Ubuntu** directly on the Switch screen.
   - Even if Nyx GUI is missing (`hekate` text menu fallback), Hekate navigates completely using **`Volume +` (Up)**, **`Volume -` (Down)**, and **`Power` (Select)**—all three buttons remain directly accessible through precision cutouts (with printed actuator caps) on the top edge of our upper lid shell!

---

## 8. Materials & Manufacturing Research: Translucent Lilac 3D Printing

### 8.1 Process & Material Selection (PCBWay vs. JLC3DP)
Neither SLA nor MJF offers a pre-tinted "translucent lilac" raw resin vat. Industrial prototyping bureaus produce translucent colored enclosures by printing in **optically clear SLA photopolymer resin** followed by **heated immersion dyeing** and a **UV-protective clear urethane topcoat**:

| Parameter | **PCBWay (Recommended for Turnkey Lilac Dyeing)** | **JLC3DP (Budget Alternative — Clear or DIY Dye)** |
| :--- | :--- | :--- |
| **Process** | **SLA (Stereolithography)** | **SLA (Stereolithography)** |
| **Material** | **`UTR-8100 (Transparent)`** or **`UTR-8100 (Translucent)`** | **`8001 Translucent Resin`** |
| **Color / Dyeing** | Select **Surface Finish → Dyeing → Custom Color** and specify **Pantone `2577 C` or `2645 C` (Translucent Lilac / Pastel Purple)** in order notes. | `8001` ships clear/slightly cool-tinted with **Clear Oil Spraying**. *(JLC3DP does not offer custom Pantone translucent purple dyeing in its automated checkout; requires either DIY Rit DyeMore Synthetic *Royal Purple* dip prior to clear-coat, or ordering from PCBWay).* |
| **Surface Finish** | **Polishing + Dyeing + Clear Glossy or Semi-Matte Acrylic/Urethane Spray** (prevents UV yellowing and yields a frosted or glass-like Game Boy Atomic Purple / Lilac look). | **Sanding + Clear Oil Spraying** (Translucent finish). |
| **Dimensional Tolerance** | `±0.10 mm` (for features `<100 mm`) or `±0.15%` (`~±0.38 mm` across a `255 mm` shell). | `±0.15 mm` or `±0.20%` (`~±0.50 mm` across a `255 mm` shell). |
| **Layer Height** | `0.05 mm` (`50 µm`) high-resolution or `0.10 mm` standard. | `0.10 mm` (`100 µm`). |
| **Min. Wall Thickness** | `0.8 mm` unsupported (`2.2–2.5 mm` recommended for structural laptop shells to prevent post-cure warp and keep uniform color saturation). | `1.0 mm` minimum (`2.5 mm` recommended for large flat enclosures). |

### 8.2 Designing Parametric OpenSCAD for Translucent SLA Resin
- **Uniform Wall Thickness (`2.5 mm` nominal):** Because immersion dye penetrates the outer `~0.3–0.5 mm` surface layer and light transmits through the bulk cross-section, sudden jumps from `1.5 mm` to `8.0 mm` solid blocks create dark blotches. We will core out thick structural ribs (`1.8 mm` rib thickness = `~70%` of nominal wall) so the translucent lilac tint looks even throughout.
- **Fastener Strategy for Thermoset Resin:** Standard thermal heat-set inserts designed for FDM thermoplastics **crack SLA thermoset resin** if pressed in with a hot iron. Instead, all screw joints in `cad/` will use:
  1. **Hex-nut trap pockets (`DIN 934` M2, M2.5, and M3 stainless steel nuts)** for high-torque structural joints (hinges and Switch midframe brackets), which are visible as clean mechanical details through the translucent lilac shell, AND
  2. **Cold-press / epoxy-bonded knurled brass inserts** (or PCBWay factory-tapped threads) for blind standoffs.

---

## 9. Preliminary Ergonomics, Hinge Torque & Mass Budget

### 9.1 Lid Mass & Hinge Torque Calculation
To ensure the upper lid holds any angle between **100° and 120°** without drooping during typing or lifting the base when opening:

1. **Upper Lid Mass ($m_{\text{lid}}$):**
   - Switch v1 core without plastic backplate and metal Joy-Con rails: `~265 g`
   - Custom SLA Upper Lid Shell + Front Bezel Retainer + RCM Button assembly: `~95 g`
   - Internal Steel Hinge Arms + M2/M3 Fasteners + USB-C right-angle connector: `~30 g`
   - **Total Lid Mass ($m_{\text{lid}}$):** $\approx \mathbf{390\text{ g}\ (0.39\text{ kg})}$
2. **Lid Center of Gravity ($L_{\text{cog}}$):**
   - Total lid height from hinge axis to top edge: `~118 mm`.
   - Center of gravity sits near the geometric center of the Switch core: $L_{\text{cog}} \approx \mathbf{58\text{ mm}\ (0.058\text{ m})}$ from the hinge pivot axis.
3. **Static Gravitational Torque ($\tau_{g}$):**
   - At maximum horizontal overhang ($90^\circ$ from vertical):
     $$\tau_{\max} = m_{\text{lid}} \cdot g \cdot L_{\text{cog}} = 0.39\text{ kg} \times 9.81\text{ m/s}^2 \times 0.058\text{ m} = \mathbf{0.222\text{ N}\cdot\text{m}}$$
   - At typical $115^\circ$ viewing angle ($25^\circ$ past vertical):
     $$\tau_{115^\circ} = 0.222\text{ N}\cdot\text{m} \times \sin(25^\circ) = \mathbf{0.094\text{ N}\cdot\text{m}}$$
4. **Required Constant-Torque Friction Hinge Spec:**
   - Applying a **$1.8\times$ dynamic hold safety factor** over $\tau_{\max}$ (so tapping the capacitive touchscreen at $110^\circ$ does not push the lid backward):
     $$\tau_{\text{hinge, total}} = 1.8 \times 0.222\text{ N}\cdot\text{m} \approx \mathbf{0.40\text{ N}\cdot\text{m}}\quad (\mathbf{0.20\text{ N}\cdot\text{m}\text{ per hinge}}\text{ using 2 hinges})$$
   - **Selected Off-the-Shelf Hinge Family:** **Southco `E6-10-204-50`** (`0.23 N·m` symmetric constant torque per hinge, `0.46 N·m` pair) or **Sugatsune `HG-TA20` / `HG-IT`** compact friction hinges, with an integrated hard mechanical stop built into the SLA hinge knuckles at **$120^\circ$**.

### 9.2 Center-of-Gravity Anti-Tip Verification & Overall Dimensions
- **Base Half Mass ($m_{\text{base}}$):**
  - Drop × MIT Planck PCB + steel plate + 47 switches + keycaps: `~260 g`
  - Baseus Blade HD 20,000 mAh power bank: `~445 g`
  - Trackball module + Internal USB-C Hub + cabling + fasteners: `~95 g`
  - Custom SLA Base Enclosure + Tray + Feet: `~185 g`
  - **Total Base Mass ($m_{\text{base}}$):** $\approx \mathbf{985\text{ g}}$
- **Stability Ratio:** The base (`~985 g`) is **$2.5\times$ heavier than the lid (`~390 g`)**. Even at the $120^\circ$ maximum opening stop, the combined center of mass remains `>42 mm` forward of the rear rubber feet—guaranteeing the deck **will never tip backward** on a desk or lap, even when poking the touchscreen.
- **Estimated Overall Dimensions & Weight:**
  - **Closed Dimensions (Layout A — Compact Front/Corner Trackball):** `~255 mm (W) × 175 mm (D) × 39 mm (H)`
  - **Closed Dimensions (Layout B — Right-Side Ploopy Nano 38mm Trackball):** `~305 mm (W) × 165 mm (D) × 39 mm (H)`
  - **Front Typing Wrist Height:** `~19.5 mm` (recessed Planck switch plate keeps top of keycaps nearly flush with the top deck bezel).
  - **Total Cyberdeck Weight:** **`~1.37 kg`** (with 20,000 mAh Baseus Blade HD) or **`~1.14 kg`** (with 10,000 mAh INIU 45W slim bank).

---

## 10. Confirmed User Decisions (Locked In for Phase 2–10)

The following design decisions were confirmed by the user at the conclusion of Phase 1:

1. **Trackball Module & Placement — Option A Confirmed:**
   - **Ploopy Nano 2** (`38 mm` ball, RP2040 QMK/VIA, USB-C) mounted in a dedicated socket to the right of the Planck keyboard, with Left/Right/Middle click and Drag-Scroll mapped to the Planck's bottom-right keys (plus optional flanking switches). Total deck width: `~305 mm`.
2. **Internal Power Bank — Cheaper Option in Germany Confirmed:**
   - **INIU Carry `P50-E1` / `BI-B62` 45W Slim USB-C PD Power Bank (`10,000 mAh / 37 Wh`, `15V @ 3A` PD, UN 38.3)** at **~€33.99 on Amazon.de** (vs. €69.99+ for Baseus Blade HD 100W). *Note: Parametric OpenSCAD (`cad/config.scad`) will default to the INIU 45W Slim and retain a 1-line preset toggle for the `20,000 mAh` INIU P62-E1 65W (`€44.99`) and Baseus Blade HD (`€69.99`).*
3. **Translucent Lilac 3D Printing Service — Cheaper Option in Germany Confirmed:**
   - **JLC3DP `SLA 8001 Translucent Resin` (`~€50.00` shipped to Germany incl. IOSS VAT) + DIY `Rit DyeMore Synthetic — Royal Purple` immersion dye (`€9.99` on Amazon.de) + UV-protective clear acrylic coat (`€8.99`)** for a total enclosure cost of **~€68.98** (saving ~€95 compared to PCBWay custom-dyed `UTR-8100`). PCBWay remains documented as the turnkey alternative.
4. **Drop × MIT Planck Revision — Confirmed:**
   - **Drop + OLKB Planck Rev 6.x** (`233.0 × 81.0 mm`, USB-C receptacle, MX hotswap PCB + switch plate).
