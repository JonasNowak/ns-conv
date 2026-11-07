#!/usr/bin/env bash
# ==============================================================================
# ns-conv: software/deploy-chimera-kefir-sd.sh
# Stages ../chimera-l4s (Chimera Linux 6.18.0-enigma-r20-erista+) + Kefir v927
# onto the Switch cyberdeck's FAT32 microSD partition (/Volumes/SWITCHBOOT).
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEFAULT_CHIMERA_REPO="$(cd "${REPO_ROOT}/.." && pwd)/chimera-l4s"

CHIMERA_REPO="${DEFAULT_CHIMERA_REPO}"
SD_MOUNT=""
ROOTDEV="mmcblk0p2"
DOWNLOAD_KEFIR=0
KEFIR_TAG="927"
DRY_RUN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Stages the pre-built Chimera Linux 6.18 (Enigma R20 Erista) boot chain from
../chimera-l4s/out/sd-boot/ and (optionally) Kefir CFW (v${KEFIR_TAG}) onto the
mounted FAT32 partition of your Nintendo Switch v1 cyberdeck microSD card.

Options:
  --sd-mount <path>       Mounted FAT32 volume path (e.g. /Volumes/SWITCHBOOT)
  --chimera-repo <path>   Path to chimera-l4s repo (default: ${DEFAULT_CHIMERA_REPO})
  --rootdev <dev>         Linux ext4 root device in CHIMERA.ini (default: mmcblk0p2;
                          use mmcblk0p3 if SD Partition emuMMC occupies p2)
  --download-kefir        Download & extract official Kefir v${KEFIR_TAG} onto SD card
  --dry-run               Verify ../chimera-l4s artifacts & print actions without writing
  -h, --help              Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --sd-mount)
            SD_MOUNT="$2"
            shift 2
            ;;
        --chimera-repo)
            CHIMERA_REPO="$2"
            shift 2
            ;;
        --rootdev)
            ROOTDEV="$2"
            shift 2
            ;;
        --download-kefir)
            DOWNLOAD_KEFIR=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "ERROR: Unknown argument: $1" >&2
            usage
            exit 1
            ;;
    esac
done

echo "==> [1/4] Verifying sibling chimera-l4s repository at: ${CHIMERA_REPO}"
if [[ ! -d "${CHIMERA_REPO}/out/sd-boot" ]]; then
    echo "ERROR: ${CHIMERA_REPO}/out/sd-boot not found." >&2
    echo "       Run the build pipeline in ${CHIMERA_REPO} first." >&2
    exit 1
fi

echo "==> [2/4] Verifying SHA256 manifest in ${CHIMERA_REPO}/out/sd-boot/MANIFEST.sha256"
(
    cd "${CHIMERA_REPO}/out/sd-boot"
    shasum -a 256 -c MANIFEST.sha256
)
echo "    All Chimera Linux 6.18.0-enigma-r20-erista+ boot artifacts verified OK."

if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "==> [DRY-RUN] Verified ../chimera-l4s artifacts:"
    echo "    - Boot dir:   ${CHIMERA_REPO}/out/sd-boot/switchroot/chimera/"
    echo "    - Hekate INI: ${CHIMERA_REPO}/out/sd-boot/bootloader/ini/CHIMERA.ini (target rootdev=${ROOTDEV})"
    echo "    - Rootfs:     ${CHIMERA_REPO}/out/rootfs.tar.zst"
    echo "    - Full image: ${CHIMERA_REPO}/out/chimera-switch-erista.img"
    exit 0
fi

if [[ -z "${SD_MOUNT}" ]]; then
    echo "ERROR: --sd-mount <path> is required (or pass --dry-run to verify artifacts)." >&2
    usage
    exit 1
fi

if [[ ! -d "${SD_MOUNT}" ]]; then
    echo "ERROR: Mounted SD volume '${SD_MOUNT}' does not exist." >&2
    exit 1
fi

if [[ "${DOWNLOAD_KEFIR}" -eq 1 ]]; then
    echo "==> [3/4] Downloading & extracting Kefir v${KEFIR_TAG} to ${SD_MOUNT}..."
    TMP_KEFIR="$(mktemp -d)"
    trap 'rm -rf "${TMP_KEFIR}"' EXIT
    KEFIR_URL="https://github.com/rashevskyv/kefir/releases/download/${KEFIR_TAG}/kefir${KEFIR_TAG}.zip"
    curl -fL "${KEFIR_URL}" -o "${TMP_KEFIR}/kefir.zip"
    unzip -q -o "${TMP_KEFIR}/kefir.zip" -d "${SD_MOUNT}"
    echo "    Kefir v${KEFIR_TAG} extracted to ${SD_MOUNT}."
else
    echo "==> [3/4] Skipping Kefir download (pass --download-kefir to fetch Kefir v${KEFIR_TAG})."
fi

echo "==> [4/4] Staging Chimera Linux 6.18 (Enigma R20 Erista) onto ${SD_MOUNT}..."
mkdir -p "${SD_MOUNT}/bootloader/ini" "${SD_MOUNT}/switchroot"
cp -rv "${CHIMERA_REPO}/out/sd-boot/switchroot/chimera" "${SD_MOUNT}/switchroot/"
sed "s/rootdev=mmcblk0p2/rootdev=${ROOTDEV}/g" \
    "${CHIMERA_REPO}/out/sd-boot/bootloader/ini/CHIMERA.ini" \
    > "${SD_MOUNT}/bootloader/ini/CHIMERA.ini"

echo "    Staged ${SD_MOUNT}/bootloader/ini/CHIMERA.ini (rootdev=${ROOTDEV}, emmc=0, mainline=1)"
echo "    Staged ${SD_MOUNT}/switchroot/chimera/ (uImage 6.18.0-enigma-r20-erista+ + tegra210-odin.dtb)"
echo "Done! Safely eject ${SD_MOUNT} before removing the microSD card."
