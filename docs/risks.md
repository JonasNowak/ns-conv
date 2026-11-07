# Phase 10: Engineering Risk Register — Top 10 Risks & Mitigations (`docs/risks.md`)

This risk register documents the **top 10 technical, mechanical, electrical, and operational risks** across the **`ns-conv`** Nintendo Switch v1 clamshell cyberdeck conversion, along with the preventive design controls built into the CAD/wiring architecture and step-by-step recovery mitigations.

---

## 1. Risk Matrix Summary

| ID | Risk Title | Category | Likelihood | Impact | Built-In Preventive Design Control |
| :--- | :--- | :--- | :---: | :---: | :--- |
| **`RSK-01`** | **Nintendo Account / Console Telemetry Ban on `sysNAND`** | Software / Security | Medium | Critical | Strict isolation of Kefir CFW & L4T Linux on microSD `emuNAND` + `exosphere` blanking + `dns.mitm`; `AutoRCM` left OFF for clean `sysNAND` boot. |
| **`RSK-02`** | **Switch `M92T36` / `P13USB` IC Damage from Non-Compliant PD Hub or Charger** | Electrical / Power | Low | Critical | Certified `15V @ 3.0A` USB-C PD 3.0 power bank (`INIU P50-E1`) + compliant `100W` PD hub (`HUB-01`) + inline `5A` fast-acting fuse (`ELC-01`). |
| **`RSK-03`** | **Mainboard Ribbon Tear or Display Flex Damage During Teardown** | Teardown / Board | Low | High | **No-Mainboard-Removal Architecture:** Display (`53-pin` MIPI DSI), digitizer, fan, and Wi-Fi coax stay factory-mounted inside the magnesium midframe (`docs/teardown.md`). |
| **`RSK-04`** | **SLA Photopolymer Shrinkage, Thin-Wall Bowing, or Boss Cracking** | CAD / 3D Print | Medium | Medium | Two-stage print (`test_fit_jig.stl` first); captive `DIN 934` stainless hex nuts + cold-press CA-bonded brass inserts (zero hot-iron thermal stress). |
| **`RSK-05`** | **Drop × MIT Planck Keyboard Ignored by Stock Horizon OS (`NKRO` Trap)** | USB HID / Firmware | High *(if unconfigured)* | Medium | Disable QMK `NKRO` (`Lower + Raise + N` or `NKRO_ENABLE = no`) so the Planck enumerates with a standard `6KRO` boot-protocol HID descriptor (`docs/wiring.md`). |
| **`RSK-06`** | **Lithium-Ion Power Bank Mechanical Puncture, Swelling, or Thermal Runaway** | Battery Safety | Low | Critical | UN 38.3 certified `INIU P50-E1` mounted in the base half (thermally isolated from the lid SoC), cushioned by `1.5 mm` EVA foam, with all `M3` screws `>= 4.5 mm` outside the cell perimeter. |
| **`RSK-07`** | **SLA Thermal Softening / Creep Around Switch Exhaust or Hinge Pads (`HDT ~ 54 °C`)** | Thermal / Structural | Low | High | Top heatsink exhaust (`Y = 162 mm`) and rear intake (`Y = 55..85 mm`) are 100% unobstructed; hinges bolt through `4.5 mm`-thick SLA spine pads backed by steel washers and `DIN 934` nuts. |
| **`RSK-08`** | **Hinge `CAB-01` Flat USB-C Ribbon Fatigue or RCM Payload Injection Lockout** | Cabling / Hinge | Low | Medium | `20 cm` ultra-flat FPC ribbon (`CAB-01`) routed with a `15 mm` rolling service loop clamped by `2× cable_clamp.stl`; accessible rear coupler pocket allows direct 1:1 RCM USB-C connection. |
| **`RSK-09`** | **Parasitic Battery Drain During Multi-Day Clamshell Storage** | Electrical / Power | High *(without switch)* | Low | Physical series power cutoff switch (`ELC-02`) on the rear panel completely isolates the power bank from the USB-C PD hub (`0 mA` standby draw). |
| **`RSK-10`** | **UV Yellowing or Dye Fading of Translucent Lilac SLA Resin** | Materials / Finish | Medium | Low | Factory UV-resistant clear urethane topcoat (`Clear Spraying` on PCBWay `UTR-8100` / JLC3DP `8001`); store out of direct midday sunlight. |

---

## 2. Detailed Risk Analysis & Recovery Playbooks

### `RSK-01` — Nintendo Server Telemetry Ban (`sysNAND` Contamination)
- **Root Cause:** Running unsigned `.nsp` homebrew, custom user avatars, or modified crash logs on `sysNAND` (or allowing `emuNAND` without `exosphere` serial blanking to go online) flags the console's hardware certificate on Nintendo's CDN.
- **Preventive Control:** Keep `sysNAND` 100% unmodified. Install Kefir CFW exclusively onto an SD card **`emuNAND` (SD Partition)** where Kefir's pre-configured `exosphere.ini` zeroes the prodinfo serial (`XAW00000000000`) and `hosts/default.txt` (`dns.mitm`) blocks all `*.nintendo.net` telemetry endpoints.
- **Contingency / Recovery:** Restore the pre-modification raw `BOOT0/BOOT1` and `rawnand.bin` backup created in Hekate before connecting `sysNAND` to Wi-Fi.

### `RSK-02` — Switch `M92T36` / `BQ24193` / `P13USB` IC Failure from Bad PD Negotiation
- **Root Cause:** Early Switch v1 boards (`HAC-CPU-10/20`) are notorious for blowing the `M92T36` USB-C PD controller or `P13USB` video/data mux if subjected to over-voltage spikes or non-compliant `15V` PD resistor profiles.
- **Preventive Control:** We use only an USB-IF / UN 38.3 compliant **`15V @ 3.0A` PD 3.0 power bank (`INIU P50-E1`)** paired with a reputable **`100W` PD 3.0 hub (`UGREEN Revodok 105` / `Baseus`)** and a **`5A` fast-acting inline blade fuse (`ELC-01`)**.
- **Contingency / Recovery:** Never connect unbranded/DIY buck-boost modules directly to the Switch USB-C port. If `ELC-01` blows, inspect `CAB-01` and `HUB-01` for pin shorts before replacing the `5A` blade fuse.

### `RSK-03` — Tearing the `53-Pin` MIPI DSI LCD Ribbon or Micro-Coax Antennas
- **Root Cause:** Attempting to unbond the Switch LCD/digitizer from the midframe or extending the high-speed `53-pin` MIPI DSI ribbon across a laptop hinge almost always results in torn ZIF latches or black screens.
- **Preventive Control:** Our architecture **never removes the mainboard, LCD, digitizer, fan, or Wi-Fi coax cables from the magnesium midframe** (`docs/teardown.md`). Only the plastic rear shell (`HAC-001`) and side Joy-Con rails (`2× 5` exterior `M2` screws) are removed, reducing teardown risk to near zero.
- **Contingency / Recovery:** Keep the removed OEM rear backplate, metal kickstand bracket, and screws in a labeled storage bag so the Switch can be returned to its original handheld form factor in `< 15 minutes` at any time.

### `RSK-04` — SLA Photopolymer Dimensional Shrinkage or Boss Cracking
- **Root Cause:** SLA photopolymer resins (`UTR-8100`, `8001`, `9000R`) can exhibit `±0.15%` post-cure shrinkage, and thermoset resins crack if a user attempts to heat-set brass inserts with a hot soldering iron or over-torques self-tapping screws.
- **Preventive Control:**
  1. Order the `18 g` [`cad/stl/test_fit_jig.stl`](../cad/stl/test_fit_jig.stl) first (`~€4.50`) to verify the Switch `M2` rail pitch, Planck corner ledge, hinge hole pattern, `MR63ZZ` bearing snap fit, and brass insert hole ladder (`-0.05 / 0.00 / +0.05 mm`).
  2. All blind bosses use **cold-pressed + medium CA gel-bonded brass inserts (`MEC-03`)**, and all high-load joints (hinges and battery strap) use **through-bolts with captive stainless `DIN 934` hex nuts (`MEC-02`)**.
- **Contingency / Recovery:** If a thin bezel part (`lid_bezel.stl`) arrives with slight shipping bow (`>0.5 mm`), warm gently with a hairdryer (`~45 °C` for `30 s`) and cool under a flat book for `10 minutes`.

### `RSK-05` — Drop × MIT Planck Keyboard Fails to Type in Stock Horizon OS (`NKRO`)
- **Root Cause:** Custom QMK keyboards with `NKRO` (N-Key Rollover) enabled present a composite non-boot HID report descriptor that Linux (`hid-generic`) accepts natively, but Nintendo's stock Horizon OS USB HID stack completely ignores.
- **Preventive Control:** Toggle `NKRO` **OFF** on the Planck using QMK Magic Key (`Lower + Raise + N`) or set `NKRO_ENABLE = no` in `rules.mk` so the keyboard presents a standard `6KRO` (`1-byte modifier + 6-byte keycode`) USB HID descriptor (`docs/wiring.md`).
- **Contingency / Recovery:** Test the Planck in Horizon OS `System Settings → Change Console Nickname` (`TST-B2` in [`docs/testing.md`](testing.md)) before bolting down `base_top_deck`.

### `RSK-06` — Internal Power Bank Puncture, Swelling, or Thermal Hazard
- **Root Cause:** Uncertified bare LiPo pouch cells or metal screw tips protruding into a battery compartment can puncture the cell pouch during transport or vibration.
- **Preventive Control:**
  1. Only a hard-cased, **UN 38.3 / CE certified commercial power bank (`INIU Carry P50-E1`)** with built-in BMS over-current/over-temperature protection is used.
  2. In [`cad/base_bottom.scad`](../cad/base_bottom.scad), the two `M3` retainer bosses are placed **`4.5 mm` outside** the battery bay perimeter walls, and the bank rests on `1.5 mm` shock-absorbing EVA foam above `8` passive intake louvers.
- **Contingency / Recovery:** Inspect the power bank every `6 months` by unscrewing the `8× M3` top-deck screws; if the bank shows any casing bulge, unbolt `battery_retainer.stl` (`2× M3` screws) and replace the bank immediately.

### `RSK-07` — SLA Enclosure Softening Near Heatsink Exhaust or Hinge Creep
- **Root Cause:** Standard SLA resins have an `HDT` of `~52–58 °C`; blocking the Switch's top exhaust vent or subjecting thin resin hinge bosses to `0.40 N·m` bending torque at elevated temperatures can cause resin creep.
- **Preventive Control:**
  1. [`cad/lid_rear.scad`](../cad/lid_rear.scad) leaves a full `44 × 8 mm` unobstructed window over the Switch's top copper heatsink exhaust (`Y = 162 mm`) and `7` rear intake louvers (`Y = 55..85 mm`) directly over the blower intake.
  2. The Southco `E6-10-301` torque hinges clamp across a solid `14 mm`-deep rear spine backed by stainless `M3` washers and captive `DIN 934` steel hex nuts.
- **Contingency / Recovery:** Never operate the Switch with the clamshell lid closed (`0°`) while running a heavy 3D game; ensure L4T Ubuntu sleep-on-lid-close (`HandleLidSwitch=suspend` or manual sleep button press) is used before closing the deck.

### `RSK-08` — Hinge USB-C Ribbon (`CAB-01`) Fatigue or RCM Payload Blockage by Hub
- **Root Cause:** Repeated `0°–120°` flexing can fatigue stiff round USB-C cables, and USB-C hubs block the raw USB 2.0 `APX` bulk transfer required by `fusee-gelee` RCM payload injection.
- **Preventive Control:**
  1. `CAB-01` is an ultra-flat `0.5 mm`-thick flexible polyimide FPC ribbon rated for `>10,000` flex cycles, routed through a `22 × 6 mm` central hinge slot with a `15 mm` rolling service loop clamped at both ends by [`cad/cable_clamp.scad`](../cad/cable_clamp.scad).
  2. The `CAB-01` female coupler sits inside the **recessed rear center pocket (`44 × 12 mm`)** of [`cad/base_bottom.scad`](../cad/base_bottom.scad#L190-L196), allowing you to unplug `HUB-01` in `2 seconds` to inject RCM payloads directly over `CAB-01`.
- **Contingency / Recovery:** Keep a spare `€3.40` `20 cm` 90° flat USB-C FPC ribbon (`CAB-01`) on hand; replacing it requires removing only the `6×` lid bezel screws and `2×` cable clamp screws.

### `RSK-09` — Parasitic Power Bank Drain During Storage
- **Root Cause:** Leaving a USB-C PD hub (`HUB-01`) permanently plugged into a power bank draws `35–80 mA` continuously (`~8–18 Wh/day`), draining a `37 Wh` power bank completely flat in `2–4 days` when the cyberdeck is turned off.
- **Preventive Control:** The rear-panel **Master Power Cutoff Switch (`ELC-02`)** physically breaks the `VBUS` line between the power bank and `HUB-01` when flipped OFF (`0.0 mA` storage drain).
- **Contingency / Recovery:** Always flip `ELC-02` to **OFF** when shutting down or stowing the cyberdeck in a backpack.

### `RSK-10` — UV Yellowing or Dye Fading of Translucent SLA Resin
- **Root Cause:** Uncoated photopolymer SLA resins (`UTR-8100`, `8001`) slowly yellow and turn brittle when exposed to prolonged outdoor UV-A/UV-B sunlight (`315–400 nm`).
- **Preventive Control:** The PCBWay (`UTR-8100`) and JLC3DP (`8001`) print specifications in [`docs/print-spec.md`](print-spec.md) include a **factory-applied UV-resistant clear urethane topcoat (`Clear Spraying`)** that blocks UV degradation while preserving optical clarity.
- **Contingency / Recovery:** Store the cyberdeck in a padded `12"` laptop sleeve when not in use and avoid leaving it on a sunlit windowsill.
