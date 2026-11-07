# Phase 2: Bill of Materials (BOM) & EUR Budget (`ns-conv`)

All prices below are verified in **EUR (incl. 19% German VAT / MwSt. and shipping to Germany)** as of November 2026.

Following your feedback, this BOM now reflects:
1. **Your Spare Joy-Con / RCM Hardware (`€0.00`):** Since you can spare your Joy-Con rail/RCM hardware, the replacement rail kit is removed—only a `€0.99` momentary tactile button is needed.
2. **AliExpress Mass-Sourcing vs. Fast German Retail (Amazon.de / RS):** Every item lists both its **AliExpress Choice price (incl. 19% German IOSS VAT & free 7–10 day shipping)** and its **Amazon.de / EU retail price**.
3. **100% Premade Enclosure (Zero Home Dyeing or Painting):** All 3D-printed parts arrive ready to assemble out of the box—using **PCBWay Turnkey Factory-Dyed Translucent Lilac SLA (`UTR-8100` + `Pantone 2577 C` Translucent Lilac + UV Clear Coat, `~€145.00`)** or **JLC3DP Premade Un-Dyed Clear (`~€50.00`) / Opaque Matte (`~€28.00`) SLA**.

> [!TIP]
> Machine-readable CSV version: [`hardware/BOM.csv`](../hardware/BOM.csv)

---

## 1. User-Owned Donor Hardware (`€0.00` Incremental Cost)

| ID | Component | Specification | Qty | Cost (EUR) | Source | Notes |
| :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| `DON-01` | **Nintendo Switch v1 (2017 Erista)** | `MOD. HAC-001` (Tegra X1 `T210`, unpatched BootROM) | 1 | `€0.00` | User Owned | Original screen, digitizer, magnesium midframe, mainboard, fan, and 4310 mAh battery reused intact in the lid. |
| `DON-02` | **Drop × OLKB MIT Planck Keyboard** | **Planck Rev 6.x** (`233.0 × 81.0 mm` PCB + switch plate, USB-C, 47 MX switches + keycaps) | 1 | `€0.00` | User Owned | Outer aluminum case is unbolted and stored; bare PCB + plate + switches + keycaps recess into the base deck. |
| `DON-03` | **Spare Right Joy-Con Rail / RCM Jig Parts** | OEM/spare Right Joy-Con rail flex & RCM jig (Pin 10 `HOME/RCM` → Pin 1 `GND`) | 1 | `€0.00` | User Owned | Used to wire the lid's recessed momentary RCM boot button without buying a replacement rail. |

---

## 2. Core Peripherals, Power Bank & Storage

| ID | Component | Specification | Qty | **AliExpress Budget (EUR)** | **Amazon.de / EU Fast (EUR)** | Recommended Links (AliExpress & DE) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| `PER-01` | **38 mm QMK Trackball (`Ploopy Nano 2` Architecture)** | `38.0 mm` snooker/trackball, **RP2040-Zero** MCU + **PMW3360 / PAW3222** optical sensor breakout + 3× **MR63ZZ (`3×6×2.5 mm`)** roller bearings running open-source QMK (`ploopyco/nano`) | 1 | **`€21.50`** *(DIY AliExpress kit: `€14.00` PMW3360 lens breakout + `€2.50` RP2040-Zero + `€3.00` 38mm ball + `€2.00` 10× MR63ZZ)* | **`€60.00`** *(Pre-built from [ploopy.co](https://ploopy.co/shop/nano-trackball/) incl. DE shipping)* | **AliExpress:** [PMW3360 Breakout](https://www.aliexpress.com/w/wholesale-PMW3360-module.html) + [RP2040-Zero](https://www.aliexpress.com/w/wholesale-RP2040-Zero.html) + [38mm Snooker Ball](https://www.aliexpress.com/w/wholesale-38mm-snooker-ball.html) + [MR63ZZ Bearings](https://www.aliexpress.com/w/wholesale-MR63ZZ.html) *(or ready-made [ProtoArc EM04 Trackball](https://www.aliexpress.com/w/wholesale-ProtoArc-EM04.html) for `€18.50`)* |
| `PWR-01` | **Slim 15V USB-C PD Power Bank (UN 38.3 Certified)** | **INIU Carry `P50-E1` / `BI-B62` 45W Slim** (`10,000 mAh / 37 Wh`, **`15V @ 3.0A` PD**, pass-through charging, `~110 × 68 × 18.5 mm`, `210 g`, UN 38.3 / CE) | 1 | **`€25.99`** *(AliExpress INIU/Baseus DE/PL EU Warehouse)* | **`€33.99`** *(Amazon.de regular; often `€27.99` w/ voucher)* | **AliExpress (EU Warehouse):** [INIU / Baseus 45W-65W PD Powerbank](https://www.aliexpress.com/w/wholesale-INIU-45W-power-bank.html)<br>**Amazon.de:** [INIU 45W 10,000 mAh](https://www.amazon.de/s?k=INIU+45W+Powerbank+10000mAh) *(20,000 mAh `INIU P62-E1 65W` alt: `€44.99`)* |
| `HUB-01` | **Internal USB-C PD 3.0 Hub (`100W PD` + `3× USB-A`)** | **UGREEN Revodok 105 / Baseus 5-in-1 USB-C PD Hub** (`100W` PD pass-through input + `3× USB-A` data ports + `4K HDMI`, `115 × 27 × 12 mm`) | 1 | **`€6.50`** *(AliExpress Choice Baseus/Essager/UGREEN 100W PD Hub)* | **`€12.99`** *(Amazon.de UGREEN Revodok 105)* | **AliExpress:** [100W PD 5-in-1 USB-C Hub](https://www.aliexpress.com/w/wholesale-UGREEN-USB-C-Hub-100W-PD.html)<br>**Amazon.de:** [UGREEN Revodok 105](https://www.amazon.de/s?k=UGREEN+Revodok+105+USB+C+Hub) |
| `STR-01` | **High-Endurance microSDXC (`256 GB`)** *(Skip if owned)* | **Samsung PRO Plus / Lexar Play `256 GB`** (`UHS-I U3 / A2 / V30`, for Kefir `emuNAND` + Switchroot L4T Ubuntu) | 1 | **`€16.90`** *(AliExpress Choice Original Lexar/Samsung 256GB)* | **`€22.99`** *(Amazon.de Samsung PRO Plus)* | **Amazon.de (Recommended to avoid counterfeit SDs):** [Samsung PRO Plus 256GB](https://www.amazon.de/s?k=Samsung+PRO+Plus+256GB+microSDXC) |

---

## 3. Internal Cabling, Power Protection & RCM Trigger Hardware

| ID | Component | Specification | Qty | **AliExpress Budget (EUR)** | **Amazon.de / EU Fast (EUR)** | Recommended Links (AliExpress & DE) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| `CAB-01` | **90° Right-Angle Flat Flexible USB-C Ribbon (`20 cm`, Lid → Base)** | **ADT-Link / FPV Ultra-Flat 90° USB-C 3.1 Male-to-Female FPC Cable** (`20 cm`, `100W 20V/5A` PD + `10 Gbps` data, routes through hinge channel) | 1 | **`€3.40`** | **`€11.99`** | **AliExpress:** [ADT-Link 90° Flat USB-C Extension 20cm](https://www.aliexpress.com/w/wholesale-ADT-Link-USB-C-90-degree-flat-20cm.html)<br>**Amazon.de:** [90° USB-C Flachkabel 20cm](https://www.amazon.de/s?k=USB+C+90+Grad+Flachkabel+Verl%C3%A4ngerung+100W) |
| `CAB-02` | **Short Flexible USB-A to USB-C Cables (`2× 15 cm`, Planck & Trackball → Hub)** | **Flat Silicone/FPC USB-A to USB-C Data Cables** (`15 cm`, 2 pcs) | 1 *(pair)* | **`€1.80`** | **`€7.99`** | **AliExpress:** [Flat Silicone USB-A to USB-C 15cm](https://www.aliexpress.com/w/wholesale-flat-silicone-USB-A-to-USB-C-15cm.html)<br>**Amazon.de:** [USB-A auf USB-C 15cm 2er](https://www.amazon.de/s?k=USB+A+auf+USB+C+Kabel+15cm+2er) |
| `CAB-03` | **Rear Panel-Mount USB-C PD Socket (`20 cm`)** | **USB-C Female-to-Male Panel-Mount Extension** (`20 cm`, `M2/M3` screw ears, `16 mm` hole pitch, `100W PD`) | 1 | **`€2.10`** | **`€8.99`** | **AliExpress:** [USB-C Panel Mount Extension 100W](https://www.aliexpress.com/w/wholesale-USB-C-panel-mount-extension-cable-100W.html)<br>**Amazon.de:** [USB-C Einbaubuchse Panel Mount](https://www.amazon.de/s?k=USB+C+Einbaubuchse+Panel+Mount+100W) |
| `ELC-01` | **Inline 5A Blade Fuse Holder + 5A Fast Fuses** | **16 AWG Inline Mini/ATO Blade Fuse Holder + `5A` Fast-Acting Fuses** (protects `VBUS` line from Power Bank) | 1 *(kit)* | **`€1.50`** | **`€5.99`** | **AliExpress:** [16AWG Inline Blade Fuse Holder 5A](https://www.aliexpress.com/w/wholesale-16AWG-inline-blade-fuse-holder-5A.html)<br>**Amazon.de:** [Flachsicherungshalter 16AWG 5A](https://www.amazon.de/s?k=Flachsicherungshalter+16AWG+5A) |
| `ELC-02` | **High-Current Power Cutoff Switch (Power Bank → Hub)** | **USB-C Male-to-Female Power Toggle Switch Cable (`20V/5A`)** or **`KCD1` `10A` Panel Rocker Switch** | 1 | **`€1.60`** | **`€7.99`** | **AliExpress:** [USB-C Switch Extension Cable](https://www.aliexpress.com/w/wholesale-USB-C-switch-extension-cable.html)<br>**Amazon.de:** [USB-C Schalter Kabel](https://www.amazon.de/s?k=USB+C+Schalter+Kabel+Power+Switch) |
| `RCM-01` | **Recessed Lid RCM Momentary Tactile Switch** | **`6×6×5 mm` Through-Hole/SMD Momentary Tactile Pushbutton** (wires to your spare Right Joy-Con rail Pin 10 `RCM` & Pin 1 `GND`) | 1 *(pack)* | **`€0.99`** | **`€2.99`** | **AliExpress:** [6x6x5mm Tactile Push Button Pack](https://www.aliexpress.com/w/wholesale-6x6x5mm-tactile-switch.html) |

---

## 4. Custom 3D-Printed Enclosure: 100% Premade Factory Options (Zero Home Dyeing)

> [!IMPORTANT]
> **100% Premade Out-of-the-Box Requirement (No Home Dyeing or Spraying):**
> - **Primary Recommendation — PCBWay Turnkey Factory-Dyed Translucent Lilac (`~€145.00`):** Ordered on [PCBWay (`pcbway.com`)](https://www.pcbway.com/rapid-prototyping/manufacture/?type=2) in **`UTR-8100 Transparent` SLA resin** with **Factory Custom Pantone `2577 C` Translucent Lilac Immersion Dyeing + Factory UV-Resistant Gloss Clear Spraying**. The parts arrive at your door in Germany already polished, dyed translucent lilac, and UV clear-coated. *(Saving `~€20` by leaving the 2 hidden internal clamps un-dyed is already reflected in the `€145.00` total; dyeing all 7 parts is `~€165.00`).*
> - **Premade Budget Alternatives on JLC3DP (`~€50.00` Clear / `~€28.00` Opaque):** If you want a lower-cost 100% premade shell with zero home work, [JLC3DP (`jlc3dp.com`)](https://jlc3dp.com/) delivers **`8001 Translucent` with factory Clear Oil Spray** (crystal-clear ice aesthetic, **`~€50.00`** shipped) or **`9000R` Matte White / `Imagine Black` Opaque SLA** (**`~€28.00`** shipped).
> - **All options use the exact same OpenSCAD `.stl` / `.3mf` files** (identical SLA dimensional tolerances).

| ID | Component | Specification | Qty | **PCBWay Premade Translucent Lilac (EUR)** | **JLC3DP Premade Clear / Opaque Alt (EUR)** | Supplier & Ordering Notes |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| `PRT-01` | **Custom 7-Part SLA Enclosure Set + Test-Fit Jig (100% Factory-Finished)** | Upper Lid Shell (`lid_rear`), Lid Front Bezel (`lid_bezel`), Base Lower Shell (`base_bottom`), Base Top Deck (`base_top_deck`), Power Bank Retainer (`battery_retainer`), Cable Clamp (`cable_clamp`) & Test Jig (`test_fit_jig`) | 1 *(set)* | **`€145.00`** *(PCBWay `UTR-8100 Transparent` + Factory `Pantone 2577 C` Translucent Lilac Dye + Factory UV Clear Coat incl. DE IOSS shipping)* | **`€50.00`** *(JLC3DP `8001` Factory Clear Polished)* / **`€28.00`** *(JLC3DP `9000R` / `Imagine Black` Opaque)* | **Primary:** [PCBWay 3D Printing](https://www.pcbway.com/rapid-prototyping/manufacture/?type=2)<br>**Alt:** [JLC3DP](https://jlc3dp.com/) — see [`docs/print-spec.md`](print-spec.md) |
| — | **Enclosure Subtotal (Zero Home Dyeing)** | | | **`€145.00`** | **`€50.00`** *(clear)* / **`€28.00`** *(opaque)* | |

---

## 5. Off-the-Shelf Mechanical Hardware & Fasteners

| ID | Component | Specification | Qty | **AliExpress Budget (EUR)** | **Amazon.de / RS Fast (EUR)** | Recommended Links (AliExpress & DE) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| `MEC-01` | **Adjustable Friction Torque Hinges (`42.9 × 36.5 × 12.7 mm`)** | **Southco `E6-10-301-20` / `CL226` Screw-Adjustable Friction Torque Hinges** (`0–0.80 N·m` per hinge; set to `~0.20 N·m` each for `100–120°` hold) | 2 *(1 pair)* | **`€5.90`** *(AliExpress `CL226 / E6-10-301` 43×36mm pair)* | **`€14.99`** *(Amazon.de pair)* / **`€27.60`** *(RS Online DE `192-5488`)* | **AliExpress:** [CL226 / E6-10-301 Adjustable Torque Hinge 43x36mm](https://www.aliexpress.com/w/wholesale-E6-10-301-hinge.html)<br>**Amazon.de:** [Positionierscharnier Einstellbar](https://www.amazon.de/s?k=Positionierscharnier+Drehmomentscharnier+einstellbar) |
| `MEC-02` | **Stainless Steel Screw & Hex Nut Assortment (`M2 / M2.5 / M3`)** | **A2-70 (`SUS304`) Socket/Button Head Screws (`DIN 912` / `ISO 7380`) + `DIN 934` Hex Nuts & Washers** | 1 *(kit)* | **`€3.60`** | **`€11.99`** | **AliExpress:** [M2 M2.5 M3 Stainless Screw Nut Set](https://www.aliexpress.com/w/wholesale-M2-M2.5-M3-stainless-screw-nut-assortment.html)<br>**Amazon.de:** [M2 M2.5 M3 Edelstahl Sortiment](https://www.amazon.de/s?k=M2+M2.5+M3+Edelstahl+Schrauben+Sortiment+DIN+912) |
| `MEC-03` | **Knurled Brass Threaded Inserts (`M2` & `M3` for Blind SLA Bosses)** | **`M2×3×3.2 mm` & `M3×4×4.5 mm` Brass Inserts** (cold-pressed + CA bonded into blind SLA bosses) | 1 *(pack)* | **`€1.80`** | **`€7.99`** | **AliExpress:** [M2 M3 Knurled Brass Inserts](https://www.aliexpress.com/w/wholesale-M2-M3-knurled-brass-insert.html)<br>**Amazon.de:** [M2 M3 Gewindeeinsatz Sortiment](https://www.amazon.de/s?k=M2+M3+Einpressmutter+Messing+Gewindeeinsatz) |
| `MEC-04` | **Silicone Feet, Lid Bezel Bumpers & `1.5 mm` EVA Battery Foam** | **`10×3 mm` Rubber Feet + `6×1.5 mm` Lid Bumpers + `1.5 mm` High-Density EVA Foam Sheet** | 1 *(set)* | **`€1.60`** | **`€6.99`** | **AliExpress:** [Silicone Bumper Feet + 1.5mm EVA Foam](https://www.aliexpress.com/w/wholesale-silicone-rubber-feet-bumper-pad.html)<br>**Amazon.de:** [Elastikpuffer + Moosgummi 1.5mm](https://www.amazon.de/s?k=Elastikpuffer+Gummif%C3%BC%C3%9Fe+selbstklebend+EVA+Moosgummi) |

---

## 6. Tools & Consumables (Skip Any Already Owned)

| ID | Component | Specification | Qty | **AliExpress Budget (EUR)** | **Amazon.de / EU Fast (EUR)** | Recommended Links (AliExpress & DE) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- |
| `TOL-01` | **Precision Screwdriver & Spudger Set (`Y00` + `JIS 00` + `H1.5`)** | **`Y00` Tri-Point + `PH00/JIS 00` + `H1.5` Hex + Plastic Spudger & Opening Picks** | 1 *(set)* | **`€3.90`** *(AliExpress 25-in-1 / Switch Repair Set)* | **`€19.99`** *(iFixit Moray 32-Bit Kit)* | **AliExpress:** [25-in-1 Precision Screwdriver Set Y00](https://www.aliexpress.com/w/wholesale-precision-screwdriver-set-Y00-switch.html)<br>**Amazon.de:** [iFixit Moray Bit Set](https://www.amazon.de/s?k=iFixit+Moray+Bit+Set+Y00) |
| `TOL-02` | **Medium Cyanoacrylate Gel + Blue Threadlocker (`243`)** | **CA Gel (`3 g`) for SLA Brass Inserts + `243` Medium Threadlocker (`10 ml`) for Hinge Screws** | 1 *(pair)* | **`€2.40`** | **`€8.99`** | **AliExpress:** [Threadlocker 243 + CA Gel](https://www.aliexpress.com/w/wholesale-threadlocker-243.html)<br>**Amazon.de:** [Schraubensicherung Mittelfest + Gel](https://www.amazon.de/s?k=Liqui+Moly+Schraubensicherung+mittelfest) |

---

## 7. Complete Budget Comparison (EUR — Germany, Zero Home Dyeing)

| Build Configuration | Peripherals & Power (`PER/PWR/HUB`) | Cabling, Fuse & RCM (`CAB/ELC/RCM`) | 3D-Printed SLA Shell (`PRT-01`) | Mechanical & Fasteners (`MEC`) | **Core Build Total (excl. SD & Tools)** | **All-In Total (incl. 256GB SD & Tools)** |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Option 1: AliExpress Hardware + Turnkey PCBWay Factory-Dyed Translucent Lilac SLA** *(100% Premade Lilac Shell)* | `€53.99` *(or `€92.49` w/ pre-built Ploopy Nano 2)* | `€11.39` | `€145.00` *(PCBWay `UTR-8100` + Factory Pantone `2577 C` Lilac)* | `€12.90` | **`€223.28`** *(`€261.78` w/ pre-built Ploopy Nano 2)* | **`€246.48`** *(`€284.98` w/ pre-built Ploopy)* |
| **Option 2: AliExpress Hardware + JLC3DP Premade Un-Dyed Clear (`8001`) or Opaque (`9000R`) SLA** | `€53.99` | `€11.39` | `€50.00` *(Clear)* / `€28.00` *(Opaque)* | `€12.90` | **`€128.28`** *(Clear)* / **`€106.28`** *(Opaque)* | **`€151.48`** *(Clear)* / **`€129.48`** *(Opaque)* |
| **Option 3: Fast German Retail (Amazon.de / Ploopy / RS) + Turnkey PCBWay Factory-Dyed Translucent Lilac SLA** | `€106.98` | `€45.94` | `€145.00` | `€54.57` | **`€352.49`** | **`€404.46`** |
