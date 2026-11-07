# Phase 8: Software Setup Guide (DEFERRED — User-Owned Placeholder)

> [!IMPORTANT]
> **Status: Deferred / User-Owned.** Per project rules, detailed step-by-step software installation instructions are intentionally deferred while the user handles the Switch software configuration independently. This document serves as the official reference hub with **verified live links** and documents **all hardware decisions in the cyberdeck build that constrain or interact with software**.

---

## 1. Verified Official Documentation Links (Live as of Nov 2026)

### Kefir All-in-One CFW Pack (Atmosphère + Hekate)
- **Official Kefir GitHub Repository:** [https://github.com/rashevskyv/kefir](https://github.com/rashevskyv/kefir)
- **Latest Verified Release (v927):** [https://github.com/rashevskyv/kefir/releases/latest](https://github.com/rashevskyv/kefir/releases/tag/927)
- **Kefir Updater Homebrew App:** [https://github.com/rashevskyv/kefir-updater](https://github.com/rashevskyv/kefir-updater)

### Switchroot L4T Ubuntu (Linux on Tegra X1)
- **Switchroot Linux Documentation Hub:** [https://wiki.switchroot.org/wiki/linux](https://wiki.switchroot.org/wiki/linux)
- **Switchroot L4T Ubuntu 24.04 (Noble) Official Install Guide:** [https://wiki.switchroot.org/wiki/linux/l4t-ubuntu-noble-installation-guide](https://wiki.switchroot.org/wiki/linux/l4t-ubuntu-noble-installation-guide)
- **Switchroot L4T Ubuntu 22.04 (Jammy) Official Install Guide:** [https://wiki.switchroot.org/wiki/linux/l4t-ubuntu-jammy-installation-guide](https://wiki.switchroot.org/wiki/linux/l4t-ubuntu-jammy-installation-guide)

### Erista RCM / Serial Verification
- **Serial Checker:** [https://ismyswitchpatched.com/](https://ismyswitchpatched.com/)

---

## 2. High-Level `emuNAND` vs. `sysNAND` Ban-Risk Summary (For User Decision)

| Configuration | Ban Risk | Storage Cost | Summary & Recommendation |
| :--- | :--- | :--- | :--- |
| **`emuNAND` (SD Partition / File) + Clean Stock `sysNAND` (Recommended)** | **Near-Zero on `sysNAND`** (when `exosphere` blanking + `dns.mitm` block Nintendo telemetry on `emuNAND`) | `~29.8 GB` (Full) or resized `8–16 GB` on microSD | **Strongly Recommended.** Keeps internal eMMC (`sysNAND`) 100% unmodified for legitimate online play, while all Kefir CFW homebrew and Switchroot L4T Ubuntu live exclusively on the microSD card. |
| **CFW on `sysNAND`** | **High** if any homebrew NSP, custom profile icon, or crash report touches Nintendo servers | `0 GB` extra on microSD | **Not Recommended.** Even with `dns.mitm` or Airplane Mode, dirty telemetry logs stored in `sysNAND` will trigger a permanent console ban the next time the console connects to Nintendo servers in stock mode. |

---

## 3. Hardware Decisions That Constrain Software Choices

When configuring your microSD card, QMK firmware, and bootloader, account for these five hardware constraints imposed by the clamshell cyberdeck architecture:

1. **microSD Card Capacity, Speed & Access Cutout (`>= 256 GB` A2/U3 High-Endurance Recommended):**
   - Because the Switch's microSD reader is mounted on the rear of the core assembly inside the upper lid, the custom lid CAD includes a **dedicated microSD access window/slot** so the card can still be ejected if needed.
   - However, **Hekate's USB Mass Storage (UMS) tool** (`Tools → USB Tools → SD Card`) allows mounting the microSD card and partitioning it for both `emuNAND` and Switchroot L4T Ubuntu directly over the USB-C port without ever removing the physical card.
   - **Minimum recommended size:** `256 GB` or `512 GB` UHS-I U3 / A2 microSDXC (e.g., Samsung PRO Plus / SanDisk Extreme), providing enough room for a `32 GB` FAT32 `hos_data` partition, `29 GB` `emuMMC` partition, and `64–128+ GB` Linux `ext4` (`l4t`) partition.
2. **Do NOT Enable `AutoRCM` if You Want Dongle-Free Stock `sysNAND` Coldboot:**
   - The cyberdeck lid includes a **physical momentary RCM trigger button** wired to Right Joy-Con Pin 10 (`HOME/RCM`).
   - Leaving `AutoRCM` **OFF** allows you to press `Power` normally to boot straight into untouched Stock Horizon OS (`sysNAND`) without a USB payload injector, while holding `[RCM Button] + [Vol+]` + `[Power]` enters RCM to boot Hekate (`emuNAND` or L4T Ubuntu).
3. **Boot Selection Without Attached Joy-Cons:**
   - **Hekate Nyx GUI** works natively via the **Switch's capacitive touchscreen**, which remains 100% accessible inside the lid.
   - **Text-mode Hekate** navigates via `Volume +` (Up), `Volume -` (Down), and `Power` (Select), all of which have external button actuators on the top edge of the lid.
   - In **Switchroot L4T Ubuntu**, the integrated **Drop Planck keyboard** and **USB HID trackball** work immediately at the display manager login screen (`SDDM`/`GDM`) without needing Joy-Cons.
4. **Drop × MIT Planck QMK Must Disable `NKRO` for Horizon OS Compatibility:**
   - Stock Horizon OS's USB HID keyboard driver only recognizes standard **6-Key Rollover (`6KRO`)** descriptors.
   - Ensure `NKRO` is toggled **OFF** on the Planck (`Lower + Raise + N` / `MAGIC_TOGGLE_NKRO`, or `NKRO_ENABLE = no` in QMK `rules.mk`) so the keyboard works seamlessly in both Horizon OS and L4T Ubuntu.
5. **Horizon OS Home Menu Navigation Expects Touch or Controller Input:**
   - Standard USB HID keyboards and trackballs are supported by Horizon OS for text entry and mouse/keyboard-enabled games, but **cannot navigate the stock Horizon OS Home Screen icons**. Use the capacitive touchscreen, a paired wireless controller, or (within Kefir `emuNAND` only) the `sys-con` USB controller sysmodule.
