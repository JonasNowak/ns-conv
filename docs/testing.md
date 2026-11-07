# Phase 9: Test & Acceptance Checklist (`docs/testing.md`)

Use this structured acceptance test protocol after completing [`docs/assembly.md`](assembly.md) to verify console preservation, dual-OS USB HID input, Wi-Fi/Bluetooth signal integrity, `15V` USB-C PD pass-through charging, thermal margins, and mechanical hinge durability.

---

## 1. Test Suite A: Console Preservation & RF (Wi-Fi / Bluetooth) Acceptance

| Test ID | Procedure | Expected Result / Pass Criterion | Status |
| :--- | :--- | :--- | :---: |
| **`TST-A1`** | **Dongle-Free Stock `sysNAND` Boot:** With `AutoRCM` disabled and `ELC-02` OFF, press the top-edge **Switch Power Button**. | Console boots directly into unmodified Stock Horizon OS (`sysNAND`) in `< 12 seconds`. | `[ ]` |
| **`TST-A2`** | **Capacitive Touchscreen & Display Check:** Sweep an icon across all four corners and center of the `6.2"` LCD inside [`lid_bezel`](../cad/lid_bezel.scad). | Zero dead touch zones; no bezel pinch points or LCD edge light-bleed along the `1.6 mm` front retainer lip. | `[ ]` |
| **`TST-A3`** | **Top-Edge Native I/O & microSDXC Check:** Insert a physical Switch Game Card, plug headphones into the `3.5 mm` jack, click Volume `+`/`-`, and verify the microSDXC card in System Settings. | Game card mounts immediately; stereo audio switches between internal speakers and `3.5 mm` jack; microSDXC shows full capacity. | `[ ]` |
| **`TST-A4`** | **2.4 GHz / 5 GHz Wi-Fi & Bluetooth RSSI Check:** Connect to a 5 GHz Wi-Fi router `5 meters` away and pair your wireless Joy-Cons / Pro Controller (`BCM4356` patch antennas inside the non-conductive SLA lid). | 5 GHz Wi-Fi achieves `3/3` bars (`RSSI >= -60 dBm` in L4T `iwconfig`); Bluetooth controller exhibits zero dropped inputs at `5 m`. | `[ ]` |
| **`TST-A5`** | **Recessed RCM Hardware Trigger (`RCM-01`):** Power OFF the Switch, unplug `HUB-01` in the rear coupler pocket, connect `CAB-01` to a PC/RCM dongle, and hold **`RCM-01` + `Volume +`**. | Switch enters `APX / RCM` mode cleanly and payloads (`hekate_ctcaer.bin`) inject on the first attempt. | `[ ]` |

---

## 2. Test Suite B: Internal & Exposed USB HID / HDMI Matrix (Both OSes)

| Test ID | Target OS / Environment | Procedure | Expected Result / Pass Criterion | Status |
| :--- | :--- | :--- | :--- | :---: |
| **`TST-B1`** | **Hekate NYX Bootloader** | Boot into Hekate NYX GUI; tap menu items on the touchscreen and move the `38 mm` trackball. | Capacitive touchscreen and USB HID trackball cursor navigate NYX menus smoothly. | `[ ]` |
| **`TST-B2`** | **Stock Horizon OS (`sysNAND`) & Kefir (`emuNAND`)** | Open `System Settings → System → Change Console Nickname` (or eShop/Browser search box) and type all 47 keys on the **Drop × MIT Planck**. | Every Planck key registers immediately; `6KRO` boot-protocol descriptor is active (`NKRO` disabled). | `[ ]` |
| **`TST-B3`** | **Switchroot L4T Ubuntu Linux** | Boot L4T Ubuntu; test the **Drop × MIT Planck** (` Lower` / `Raise` layers) and **38 mm Trackball** (`PMW3360` / `RP2040`) at the login screen and desktop terminal (`xinput list`). | Both `OLKB Planck` and `Ploopy Nano Trackball` enumerate via `xhci-tegra` (`USB 2.0/3.0`) with zero missed keystrokes and smooth `360°` ball tracking. | `[ ]` |
| **`TST-B4`** | **Exposed Right-Side `USB-A 3.0` Port (`HUB-01`)** | Plug an external USB 3.0 flash drive into the flush right-side `USB-A` window of [`base_bottom`](../cad/base_bottom.scad#L207-L209) under L4T Ubuntu. | Drive mounts at `USB 3.0 SuperSpeed (5 Gbps)` (`lsusb -t` shows `5000M` `xhci-tegra` link) and achieves `>= 100 MB/s` sequential read. | `[ ]` |
| **`TST-B5`** | **Exposed Right-Side `4K HDMI` Port (`HUB-01`)** | Connect an external HDMI monitor to the flush right-side `HDMI` window while `15V PD` power (`ELC-02` ON) is active. | External display receives `1080p60` (Horizon OS Docked Mode / L4T Ubuntu dual-head output) with audio over HDMI. | `[ ]` |

---

## 3. Test Suite C: `15V` USB-C PD Charging, Pass-Through & Runtime Benchmark

| Test ID | Procedure | Expected Result / Pass Criterion | Status |
| :--- | :--- | :--- | :---: |
| **`TST-C1`** | **Internal Power Bank → Switch `15V PD` Negotiation:** With external wall power unplugged, flip rear switch **`ELC-02` ON**. | `INIU P50-E1` (`37 Wh`) negotiates `15V` PD through `HUB-01`; Switch displays the charging lightning bolt icon and battery percentage increases during active gameplay. | `[ ]` |
| **`TST-C2`** | **Single-Port External Pass-Through Charging (`CAB-03`):** Plug a `45W–65W` `15V` USB-C PD wall charger into the rear panel socket (`CAB-03`) with `ELC-02` ON. | Both the `INIU` power bank LED percentage and the Switch battery indicator charge simultaneously (`True Pass-Through`), with brief `~1s` PD re-handshake upon plug-in. | `[ ]` |
| **`TST-C3`** | **Combined `53.0 Wh` Extended Runtime Benchmark:** Fully charge both batteries (`16.0 Wh` Switch + `37.0 Wh` INIU = `53.0 Wh` total), set screen brightness to `50%`, and run an active 3D game or L4T Ubuntu workload. | Total continuous untethered runtime reaches **`7.5 to 9.5 hours`** (nearly `3×` stock Erista runtime). | `[ ]` |
| **`TST-C4`** | **Zero Parasitic Drain Cutoff (`ELC-02` OFF):** Flip `ELC-02` **OFF** and leave the cyberdeck stored for `48 hours`. | Power bank state-of-charge drops by **`0%`** over `48 hours` (confirming `HUB-01` quiescent current is completely isolated). | `[ ]` |

---

## 4. Test Suite D: Thermal & Acoustic Stress Test (`30-Minute` Full Load)

> [!WARNING]
> **SLA Photopolymer Thermal Limit (`HDT ~ 52–58 °C`):**
> Standard translucent/opaque SLA resins (`UTR-8100`, `8001`, `9000R`) have a Heat Deflection Temperature of `~54 °C`. Verify during `TST-D1` that no external SLA enclosure surface exceeds **`45 °C`**.

| Test ID | Procedure | Expected Result / Pass Criterion | Status |
| :--- | :--- | :--- | :--- |
| **`TST-D1`** | **Lid Tegra X1 SoC & Exhaust Thermal Test:** Run `30 minutes` of heavy 3D load (or `stress-ng --cpu 4` + `glmark2` in L4T Ubuntu) with the lid at `112°`. Monitor `/sys/class/thermal/thermal_zone*/temp` (or Tesla `Status Monitor`). | Tegra X1 SoC stays **`<= 62 °C`**; internal fan spins unobstructed through the rear intake louvers (`Y = 55..85 mm`) and top exhaust cutout; outer [`lid_rear`](../cad/lid_rear.scad) SLA surface stays **`<= 40 °C`**. | `[ ]` |
| **`TST-D2`** | **Base Power Bank & PD Hub Thermal Isolation Test:** During simultaneous `15V PD` discharge (`TST-D1`), measure the bottom intake louvers under [`base_bottom`](../cad/base_bottom.scad) (`pbank_bay` and `hub_bay`). | Power bank bay and USB-C PD hub stay **`<= 42 °C`** (thermally isolated inside the base half, separated by the hinge air gap from the Switch SoC in the lid). | `[ ]` |

---

## 5. Test Suite E: Mechanical & 50-Cycle Hinge Durability Test

| Test ID | Procedure | Expected Result / Pass Criterion | Status |
| :--- | :--- | :--- | :--- |
| **`TST-E1`** | **Static Tip-Over & Typing Ergonomics Test:** Open the lid to **`100°`**, **`112°`**, and **`120°`** on a flat desk and type vigorously on the **Drop × MIT Planck**. | Center of gravity remains forward of the hinge axis (`Y = 154 mm`) thanks to the `210 g` power bank + `295 g` Planck in the base; deck does **not** tip backward at `120°`. | `[ ]` |
| **`TST-E2`** | **50-Cycle Clamshell Open/Close Endurance Test (`0° ↔ 120°`):** Open and close the lid `50 times` continuously while L4T Ubuntu runs `dmesg -w` in a terminal. | Zero USB disconnects or `xhci-tegra` link resets on the `CAB-01` 90° flat FPC ribbon; hinge holding torque remains steady (`~0.20 N·m` per hinge) with zero `M3` bolt loosening; `38 mm` trackball nests cleanly in the right-wing lid recess on every closure. | `[ ]` |
