# Hardware Datasheets, Pinouts & Mechanical References (`hardware/datasheets.md`)

This file indexes the official datasheets, open-source CAD repositories, and connector pinouts referenced in [`docs/wiring.md`](../docs/wiring.md) and [`cad/config.scad`](../cad/).

---

## 1. Nintendo Switch v1 (`MOD. HAC-001`) Hardware References

- **Battery Charger IC:** Texas Instruments `BQ24193` (`I2C` 4.5A Single-Cell USB-PD/Adapter Charger)
  - Datasheet: [https://www.ti.com/lit/ds/symlink/bq24193.pdf](https://www.ti.com/lit/ds/symlink/bq24193.pdf)
- **USB-PD Controller:** ROHM `BM92T36` (USB Type-C Power Delivery Controller supporting `5V` / `15V` sink profiles and DisplayPort Alt-Mode)
- **Right Joy-Con Rail 10-Pin Connector Pinout (Facing Rail Contacts, Top = Pin 1, Bottom = Pin 10):**

| Pin | Signal Name | Function | Cyberdeck Usage |
| :-: | :--- | :--- | :--- |
| **1** | `GND` | Ground Return (also tied to metal rail chassis) | **Used:** Common ground side of `RCM-01` momentary tactile button |
| **2** | `TX` | Joy-Con UART Transmit (`1.8V`/`3.3V`) | Untouched |
| **3** | `DET` | Joy-Con Insertion Detect | Untouched |
| **4** | `GND` | Signal Ground | Untouched |
| **5** | `RX` | Joy-Con UART Receive | Untouched |
| **6** | `5V0_OUT` | `+5.0V` Joy-Con Charging Rail | **WARNING: DO NOT SHORT!** Keep isolated |
| **7** | `GND` | Power Ground | Alternative Ground for `RCM-01` |
| **8** | `UART_RTS` | Flow Control / Handshake | Untouched |
| **9** | `NFC_OR_PWR`| Secondary Joy-Con Rail Signal (`+5V` adjacent) | **WARNING: DO NOT SHORT TO PIN 10!** |
| **10**| **`HOME / RCM`** | **Tegra X1 BootROM Recovery Mode Strap (Active Low)** | **Used:** Wired via `RCM-01` momentary switch to **Pin 1 (`GND`)** |

---

## 2. Drop × OLKB MIT Planck (Rev 6.x) CAD & Schematic References

- **Official Open-Source Mechanical Parts & DXF Plates (`olkb/olkb_parts`):**
  - Repository: [https://github.com/olkb/olkb_parts/tree/master/planck](https://github.com/olkb/olkb_parts/tree/master/planck)
- **Official QMK Firmware Definition (`keyboards/planck/rev6`):**
  - MCU: STMicroelectronics `STM32F303CBT6` (ARM Cortex-M4, `72 MHz`, Hardware USB 2.0 Full-Speed)
  - Datasheet: [https://www.st.com/resource/en/datasheet/stm32f303cb.pdf](https://www.st.com/resource/en/datasheet/stm32f303cb.pdf)
  - PCB Dimensions: `233.00 mm × 81.00 mm × 1.60 mm`

---

## 3. Trackball Subsystem (`Ploopy Nano 2` / `RP2040-Zero` + `PMW3360`)

- **Ploopy Nano Open-Source STEP/STL & PCB Repository:**
  - Repository: [https://github.com/ploopyco/nano-trackball](https://github.com/ploopyco/nano-trackball)
- **Raspberry Pi `RP2040` Microcontroller (`Waveshare RP2040-Zero`):**
  - RP2040 Datasheet: [https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf](https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf)
  - Waveshare RP2040-Zero Wiki & Pinout (`23.5 × 18.0 mm`): [https://www.waveshare.com/wiki/RP2040-Zero](https://www.waveshare.com/wiki/RP2040-Zero)
- **PixArt `PMW3360DM-T2QU` Optical Navigation Sensor:**
  - Operating Voltage: `3.3V` (`VDD` max `3.6V` — **not 5V tolerant on `VDD`**)
  - Interface: 4-Wire SPI (`SCK`, `MISO`, `MOSI`, `NCS`, up to `2 MHz` clock, `12,000 CPI`)
  - Lens-to-Ball Surface Working Distance (`Z` height from PCB bottom of lens flange to bottom of `38.0 mm` ball): **`2.40 mm ± 0.15 mm`**

---

## 4. Mechanical Hinges & SLA Photopolymer Resin Datasheets

- **Southco `E6-10-301-20` Adjustable Friction Torque Position Hinge (`42.9 × 36.5 × 12.7 mm`):**
  - Southco E6 Series Catalog & CAD Drawing: [https://southco.com/en_eu_int/e6-constant-torque-position-control-hinges](https://southco.com/en_eu_int/e6-constant-torque-position-control-hinges)
  - Mounting Holes: `4× Ø4.4 mm` through-holes (compatible with `M4` or `M3` screws + washers; leaf hole centers: `25.4 mm` horizontal span × `19.1 mm` vertical span).
  - Torque Range: `0.00 to 0.80 N·m` static friction torque per hinge (adjusted via central Phillips screw).
- **JLC3DP `SLA 8001 Translucent Resin` Technical Specifications:**
  - Material Guide: [https://jlc3dp.com/3d-printing-quote](https://jlc3dp.com/3d-printing-quote)
  - Tensile Strength: `~52 MPa` | Flexural Modulus: `~2,300 MPa` | Heat Deflection Temp (`HDT @ 0.45 MPa`): `~54–58°C`.
