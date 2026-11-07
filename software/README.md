# Software Directory — `chimera-l4s` (Linux 6.18 Enigma R20) + Kefir CFW (`software/`)

This directory contains deployment tooling and reference links connecting the **`ns-conv`** clamshell cyberdeck hardware to your sibling software repository **[`../chimera-l4s`](file:///Users/jonasnowak/Documents/repos/chimera-l4s)** ([`JonasNowak/chimera-switch-6.18`](https://github.com/JonasNowak/chimera-switch-6.18)) and **[Kefir (`v927`)](https://github.com/rashevskyv/kefir/releases/tag/927)**.

- **Full Step-by-Step Software Guide:** [`docs/software.md`](../docs/software.md)
- **Automated SD Card Stagings Script:** [`software/deploy-chimera-kefir-sd.sh`](deploy-chimera-kefir-sd.sh)

## Quick Verification & Deployment Commands

```bash
# 1. Verify all pre-built Chimera Linux 6.18.0-enigma-r20-erista+ SHA256 checksums in ../chimera-l4s:
./software/deploy-chimera-kefir-sd.sh --dry-run

# 2. Deploy Chimera Linux 6.18 + Kefir v927 onto a mounted FAT32 SD card (/Volumes/SWITCHBOOT):
./software/deploy-chimera-kefir-sd.sh --sd-mount /Volumes/SWITCHBOOT --download-kefir
```
