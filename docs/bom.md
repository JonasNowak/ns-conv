# Phase 2: Bill of Materials (BOM) & EUR Budget (`ns-conv`)

All prices below are verified in **EUR (incl. 19% German VAT / MwSt. and shipping to Germany)** as of November 2026. Every line item includes a primary recommended supplier in Germany/EU and a verified drop-in alternative.

> [!TIP]
> Machine-readable CSV version: [`hardware/BOM.csv`](../hardware/BOM.csv)

---

## 1. User-Owned Donor Hardware (`€0.00` Incremental Cost)

| ID | Component | Specification | Qty | Unit Price (EUR) | Primary Source | Notes / Verification |
| :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| `DON-01` | **Nintendo Switch v1 (2017 Erista)** | `MOD. HAC-001` (Tegra X1 `T210`, unpatched BootROM) | 1 | `€0.00` *(Owned)* | User Donor | Must pass pre-teardown live RCM (`fusee-gelee`) test (`0x7000` smash). Original screen, midframe, mainboard, fan, and 4310 mAh battery reused in lid. |
| `DON-02` | **Drop × OLKB MIT Planck Keyboard** | **Planck Rev 6.x** (`233.0 × 81.0 mm` PCB + switch plate, USB-C, 47 MX switches + keycaps) | 1 | `€0.00` *(Owned)* | User Donor | Aluminum outer case is removed and stored safely; bare PCB + switch plate + switches + keycaps recess-mount into base deck. |

---

## 2. Core Peripherals, Power Bank & Storage

| ID | Component | Specification | Qty | Unit Price (EUR) | Total (EUR) | Recommended Supplier (DE/EU) | Verified Alternative (with EUR Price) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `PER-01` | **Ploopy Nano 2 Trackball** | `38.0 mm` ball, RP2040 MCU, PAW-3222 optical sensor, QMK/VIA firmware, USB-C (`62 × 54 × 49 mm`) | 1 | `€60.00` *(incl. EU shipping)* | `€60.00` | [Ploopy Official Shop (`ploopy.co`)](https://ploopy.co/shop/nano-trackball/) *(~$69.99 CAD + Chit Chats DE shipping)* | **DIY Ploopy Nano 2 from Open-Source Files** ([`ploopyco/nano-trackball`](https://github.com/ploopyco/nano-trackball) PCB via JLCPCB + 38 mm snooker ball + 3× `MR63ZZ` bearings on Amazon.de — **`~€24.50`**) OR **ProtoArc EM04 / Perixx PERIMICE-517** ([Amazon.de](https://www.amazon.de/s?k=Perixx+PERIMICE-517) — **`€28.99`**) |
| `PWR-01` | **Slim 15V USB-C PD Power Bank (UN 38.3 Certified)** | **INIU Carry `P50-E1` / `BI-B62` 45W Slim** (`10,000 mAh / 37 Wh`, **`15V @ 3.0A` PD**, pass-through charging, `~110 × 68 × 18.5 mm`, `210 g`, UN 38.3 / CE) | 1 | `€33.99` | `€33.99` | [Amazon.de — INIU 45W 10,000 mAh Powerbank](https://www.amazon.de/s?k=INIU+45W+Powerbank+10000mAh) | **INIU `P62-E1` 65W (`20,000 mAh / 74 Wh`, 15V/3A PD)** ([Amazon.de](https://www.amazon.de/s?k=INIU+65W+20000mAh+Powerbank) — **`€44.99`**) OR **Baseus Blade HD 100W (`20,000 mAh`, `134 × 134 × 18 mm`)** ([Amazon.de](https://www.amazon.de/s?k=Baseus+Blade+100W+Powerbank) — **`€69.99`**) |
| `HUB-01` | **Internal USB-C PD 3.0 Hub** | **UGREEN Revodok 105 (5-in-1)** (`100W` USB-C PD pass-through input + `3× USB-A` data ports + `4K HDMI`, slim aluminum shell `115 × 27 × 12 mm`) | 1 | `€12.99` | `€12.99` | [Amazon.de — UGREEN Revodok 105](https://www.amazon.de/s?k=UGREEN+Revodok+105+USB+C+Hub) | **Anker 332 USB-C Hub (`A8355`, 5-in-1, 100W PD)** ([Amazon.de](https://www.amazon.de/s?k=Anker+332+USB+C+Hub) — **`€19.99`**) |
| `STR-01` | **High-Endurance microSDXC Card** *(Optional if already owned)* | **Samsung PRO Plus `256 GB`** (`UHS-I U3 / A2 / V30`, for Kefir `emuNAND` + Switchroot L4T Ubuntu `ext4`) | 1 | `€22.99` | `€22.99` | [Amazon.de — Samsung PRO Plus 256GB](https://www.amazon.de/s?k=Samsung+PRO+Plus+256GB+microSDXC) | **SanDisk Extreme `256 GB` A2 microSDXC** ([Amazon.de](https://www.amazon.de/s?k=SanDisk+Extreme+256GB+microSDXC) — **`€23.99`**) or `512 GB` (**`€39.99`**) |

---

## 3. Internal Cabling, Power Protection & RCM Trigger Hardware

| ID | Component | Specification | Qty | Unit Price (EUR) | Total (EUR) | Recommended Supplier (DE/EU) | Verified Alternative (with EUR Price) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `CAB-01` | **90° Right-Angle Flat Flexible USB-C Extension Cable (Lid → Base)** | **ADT-Link / Ultra-Flat 90° USB-C 3.1 Gen2 Male-to-Female Ribbon** (`20 cm`, `100W 20V/5A` PD + `10 Gbps` data, routes through hinge channel) | 1 | `€11.99` | `€11.99` | [Amazon.de — 90° USB-C Flachkabel Verlängerung 20cm](https://www.amazon.de/s?k=USB+C+90+Grad+Flachkabel+Verl%C3%A4ngerung+100W) | **Poyiccot 90-Degree Right-Angle USB-C Extension (`20 cm`, 100W)** ([Amazon.de](https://www.amazon.de/s?k=Poyiccot+90+Grad+USB+C+Verl%C3%A4ngerung) — **`€9.99`**) |
| `CAB-02` | **Short Internal USB-A to USB-C Data Cables (Planck & Trackball → Hub)** | **Flexible Silicone/FPC USB-A to USB-C Cables** (`15 cm`, 2-pack, connects Planck Rev 6 and Ploopy Nano 2 to internal hub) | 1 *(2-pack)* | `€7.99` | `€7.99` | [Amazon.de — USB-A auf USB-C Kabel 15cm 2er](https://www.amazon.de/s?k=USB+A+auf+USB+C+Kabel+15cm+2er) | **chenyang Ultra-Thin Flat USB 2.0 A-to-C 90° (`15 cm`)** ([Amazon.de](https://www.amazon.de/s?k=chenyang+flach+USB+A+auf+USB+C+15cm) — **`€8.99`**) |
| `CAB-03` | **Rear Panel-Mount USB-C PD Socket & Cable** | **USB-C 3.1 Panel-Mount Female-to-Male Extension** (`20 cm`, `M2/M3` screw ears, `16 mm` hole pitch, `100W PD`) for rear charging/data access | 1 | `€8.99` | `€8.99` | [Amazon.de — USB-C Einbaubuchse Panel Mount 100W](https://www.amazon.de/s?k=USB+C+Einbaubuchse+Panel+Mount+100W) | **PENGLIN / sourcing map USB-C Flush Panel Mount** ([Amazon.de](https://www.amazon.de/s?k=USB+C+Einbaubuchse+Schraubbefestigung) — **`€7.99`**) |
| `ELC-01` | **Inline 5A Fuse Holder + 5A Fast-Acting Blade Fuses** | **16 AWG Inline Mini/Standard Blade Fuse Holder (`ATO/ATC`) + `5A` Fuses** (spliced on the `VBUS` feed between Power Bank output and Hub PD input) | 1 *(kit)* | `€5.99` | `€5.99` | [Amazon.de — KFZ Flachsicherungshalter 16AWG + 5A](https://www.amazon.de/s?k=Flachsicherungshalter+16AWG+5A) | **5×20 mm Inline Screw Fuse Holder + `5A` Fast Glass Fuses (`F5AL250V`)** ([Reichelt.de](https://www.reichelt.de/) / [Amazon.de](https://www.amazon.de/s?k=Kabelsicherungshalter+5x20+5A) — **`€5.49`**) |
| `ELC-02` | **USB-C PD Power Cutoff Switch Cable (Power Bank → Hub)** | **USB-C Male-to-Female Inline Toggle Switch / Short PD Cable** (`15–20 cm`, allows cutting power bank output when stored) | 1 | `€7.99` | `€7.99` | [Amazon.de — USB-C Kabel mit Ein/Aus Schalter](https://www.amazon.de/s?k=USB+C+Schalter+Kabel+Power+Switch) | **Panel-Mount High-Current Rocker Switch (`KCD1 6A/10A`, wired in series with `ELC-01` fuse)** ([Amazon.de](https://www.amazon.de/s?k=Wippschalter+KCD1+12V+10A) — **`€4.99`**) |
| `RCM-01` | **Sacrificial Right Joy-Con Slider Rail + RCM Jig + Tactile Button** | **Replacement Right Slider Rail w/ Flex (`HAC-001`) + RCM Jig Clip + `6×6×5 mm` Tactile Switch** (preserves original Switch rail untouched; wires Pin 10 `RCM` → `GND` button in lid) | 1 *(set)* | `€11.99` | `€11.99` | [Amazon.de — Switch Rechte Schiene Flexkabel + RCM Jig](https://www.amazon.de/s?k=Nintendo+Switch+Rechte+Schiene+Flexkabel+RCM+Jig) | **Standalone RCM Jig Clip + `6×6 mm` Tactile Switch** (if keeping stock right rail tucked inside lid — **`€5.99`**) |

---

## 4. Custom 3D-Printed Translucent Lilac Enclosure (JLC3DP + DIY Lilac Dye)

Per your selection of the **more affordable option in Germany**, the custom parts are printed via **JLC3DP (`SLA 8001 Translucent Resin`)** and dyed to **Translucent Lilac** at home using **Rit DyeMore Synthetic (*Royal Purple*)** followed by a **UV-resistant Clear Acrylic Spray Coat**:

| ID | Component | Specification | Qty | Unit Price (EUR) | Total (EUR) | Recommended Supplier (DE/EU) | Verified Alternative (with EUR Price) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `PRT-01` | **Custom SLA Enclosure Set + Test-Fit Jigs (7 Parts)** | **JLC3DP `SLA 8001 Translucent Resin`** (`0.10 mm` layer, Sanding + Clear Oil finish; includes Upper Lid Rear Shell, Lid Front Retainer Bezel, Base Lower Shell, Base Top Deck [Planck + Nano Socket], Power Bank Retainer, Hinge Brackets & Test-Fit Jig) | 1 *(full set)* | `€50.00` *(incl. IOSS VAT & DE shipping)* | `€50.00` | [JLC3DP (`jlc3dp.com`)](https://jlc3dp.com/) *(~$38 print + ~$15 Euro Packet IOSS)* | **PCBWay Turnkey Factory-Dyed (`SLA UTR-8100 Transparent` + Custom Pantone `2577 C` Lilac Dyeing + Clear Coat)** ([pcbway.com](https://www.pcbway.com/rapid-prototyping/manufacture/?type=2) — **`~€165.00`** shipped to DE; skips `PRT-02`/`PRT-03`) |
| `PRT-02` | **Translucent Lilac Polymer Dye** | **Rit DyeMore Synthetic Fiber & Plastic Dye — `Royal Purple` (`207 ml`)** (60–90 sec immersion in `65°C` water + 1 tsp dish soap tints `8001` resin into uniform translucent lilac) | 1 | `€9.99` | `€9.99` | [Amazon.de — Rit DyeMore Royal Purple](https://www.amazon.de/s?k=Rit+DyeMore+Royal+Purple) | **iDye Poly Violet / Lilac Synthetic Dye** ([Amazon.de](https://www.amazon.de/s?k=Jacquard+iDye+Poly+Violet) — **`€8.95`**) |
| `PRT-03` | **UV-Resistant Clear Protective Lacquer** | **Dupli-Color / Edding Clear Acrylic UV-Resistant Varnish (`400 ml`, Gloss or Satin)** (seals the lilac dye and prevents SLA resin UV yellowing over time) | 1 | `€8.99` | `€8.99` | [Amazon.de — Dupli-Color Klarlack UV-beständig](https://www.amazon.de/s?k=Dupli+Color+Klarlack+UV+best%C3%A4ndig) | **SprayMax 1K / 2K Clear Acrylic Lacquer (`400 ml`)** ([Amazon.de](https://www.amazon.de/s?k=SprayMax+Klarlack) — **`€13.99`**) |

---

## 5. Off-the-Shelf Mechanical Hardware & Fasteners

| ID | Component | Specification | Qty | Unit Price (EUR) | Total (EUR) | Recommended Supplier (DE/EU) | Verified Alternative (with EUR Price) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `MEC-01` | **Adjustable Friction Torque Hinges (`~0.40 N·m` pair setting)** | **Southco `E6-10-301-20` Adjustable Torque Position Hinge** (`42.9 × 36.5 × 12.7 mm`, black acetal copolymer + steel shaft, screw-adjustable friction `0–0.80 N·m` per hinge) | 2 | `€13.80` | `€27.60` | [RS Online Deutschland (`RS 192-5488`)](https://de.rs-online.com/web/c/?searchTerm=E6-10-301-20) | **2× Adjustable Friction Torque Hinges (`43 × 36 mm` Southco E6 pattern)** ([Amazon.de](https://www.amazon.de/s?k=Positionierscharnier+Drehmomentscharnier+einstellbar) — **`€14.99` / pair**) |
| `MEC-02` | **Stainless Steel Metric Screw & Hex Nut Assortment (`M2 / M2.5 / M3`)** | **A2-70 (`SUS304`) Button/Socket Head Screws (`ISO 7380` / `DIN 912`) + `DIN 934` Hex Nuts & Washers** (`M2×6/8/10/12`, `M2.5×6/8`, `M3×8/10/12/16 mm` for Switch midframe rails, Planck plate, hinges, and shell closure) | 1 *(kit)* | `€11.99` | `€11.99` | [Amazon.de — M2 M2.5 M3 Edelstahl Schrauben & Muttern Set](https://www.amazon.de/s?k=M2+M2.5+M3+Edelstahl+Schrauben+Sortiment+DIN+912) | **Screws24 / Hornbach Individual `DIN 912` + `DIN 934` Packs** (**`~€9.50`**) |
| `MEC-03` | **Knurled Brass Threaded Inserts (`M2` & `M3` for Blind SLA Bosses)** | **`M2×3×3.2 mm` & `M3×4×4.5 mm` Knurled Brass Inserts** (installed via cold-press + medium cyanoacrylate into blind SLA resin bosses—*never use a hot iron on thermoset SLA!*) | 1 *(kit)* | `€7.99` | `€7.99` | [Amazon.de — M2 M3 Gewindeeinsätze Messing Sortiment](https://www.amazon.de/s?k=M2+M3+Einpressmutter+Messing+Gewindeeinsatz) | **ruthex `M2` / `M3` Threaded Inserts** ([Amazon.de](https://www.amazon.de/s?k=ruthex+M2+M3+Gewindeeinsatz) — **`€9.99`**) |
| `MEC-04` | **Silicone Feet, Lid Bezel Bumpers & Flame-Retardant Battery Padding** | **Self-Adhesive Silicone Feet (`10×3 mm`), Micro Lid Bumpers (`6×1.5 mm`), and `1.5 mm` EVA/Poron Foam Pad** (cushions and thermally isolates the INIU power bank in the base bay) | 1 *(set)* | `€6.99` | `€6.99` | [Amazon.de — Elastikpuffer Gummifüße + Moosgummi 1.5mm](https://www.amazon.de/s?k=Elastikpuffer+Gummif%C3%BC%C3%9Fe+selbstklebend+EVA+Moosgummi) | **3M Bumpon `SJ5012` + `1.5 mm` Silicone Thermal/Shock Pad** ([Amazon.de](https://www.amazon.de/s?k=3M+Bumpon+Gummif%C3%BC%C3%9Fe) — **`€8.49`**) |

---

## 6. Tools & Consumables (Skip Any Already Owned)

| ID | Component | Specification | Qty | Unit Price (EUR) | Total (EUR) | Recommended Supplier (DE/EU) | Verified Alternative (with EUR Price) |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `TOL-01` | **Precision Screwdriver & Spudger Kit (`Y00` + `JIS 00`)** | **iFixit Moray (32-Bit Driver Kit)** — includes **`Y00` Tri-Point** (Switch rear shell), **`JIS 00` / `PH00`** (Joy-Con rails & internal screws), **`H1.5` / `T6`** (Planck case), plastic spudger, and opening picks | 1 | `€19.99` | `€19.99` | [Amazon.de — iFixit Moray Driver Kit](https://www.amazon.de/s?k=iFixit+Moray+Bit+Set+Y00) | **Individual iFixit `Y00` + `JIS 00` Drivers + Spudger** ([iFixit DE Store](https://store.ifixit.de/) — **`€12.95`**) |
| `TOL-02` | **Medium Cyanoacrylate Gel + Blue Threadlocker (`243`)** | **UHU / Loctite Cyanoacrylate Gel (`3 g`, for bonding brass inserts in SLA resin) + Liqui Moly / Loctite 243 Medium Threadlocker** (keeps hinge and midframe screws vibration-proof) | 1 *(pair)* | `€8.99` | `€8.99` | [Amazon.de — Sekundenkleber Gel + Schraubensicherung Mittelfest](https://www.amazon.de/s?k=Liqui+Moly+Schraubensicherung+mittelfest) | **Loctite 401 + Loctite 243 Mini Pack** (**`€13.99`**) |

---

## 7. Total Budget Summary (EUR — Germany)

| Budget Category | Included Items | Subtotal (EUR) |
| :--- | :--- | :---: |
| **1. Donor Hardware** | Switch v1 (`HAC-001`) + Drop × MIT Planck Rev 6 *(already user-owned)* | `€0.00` |
| **2. Core Peripherals & Power** | Ploopy Nano 2 (`€60.00`), INIU 45W Slim 15V PD Bank (`€33.99`), UGREEN 100W PD Hub (`€12.99`) | `€106.98` |
| **3. Internal Cabling, Fuse & RCM** | 90° Flat USB-C (`€11.99`), 2× 15cm USB-C (`€7.99`), Panel USB-C (`€8.99`), 5A Fuse (`€5.99`), PD Switch (`€7.99`), Right Rail + RCM (`€11.99`) | `€54.94` |
| **4. Translucent Lilac SLA Shell** | JLC3DP `8001` SLA Print Set (`€50.00`), Rit DyeMore *Royal Purple* (`€9.99`), UV Clear Coat (`€8.99`) | `€68.98` |
| **5. Mechanical & Fasteners** | 2× Southco `E6-10-301-20` Hinges (`€27.60`), M2–M3 Screw/Nut Kit (`€11.99`), Brass Inserts (`€7.99`), Bumpers/Pads (`€6.99`) | `€54.57` |
| **Core Conversion Subtotal** | *(All parts required to build the cyberdeck, assuming tools & microSD are already on hand)* | **`€285.47`** |
| **6. Optional Storage & Tools** | 256 GB PRO Plus microSDXC (`€22.99`), iFixit Moray Driver Kit (`€19.99`), Adhesive/Threadlocker (`€8.99`) | `€51.97` |
| **All-In Grand Total (DE)** | *(Complete turnkey build including microSD card and precision tool kit)* | **`€337.44`** |

> [!NOTE]
> **Budget Optimization Tip:** Choosing the **Amazon.de Southco-compatible friction hinges (`€14.99/pair`)** instead of ordering from RS Online (`€27.60`), or building the **Ploopy Nano 2 from its open-source files (`~€24.50`)**, reduces the **Core Conversion Subtotal to `~€237.36`**.
