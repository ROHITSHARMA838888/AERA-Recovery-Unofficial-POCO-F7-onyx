#!/usr/bin/env bash
# CI builds only. Never flashes a connected phone or publishes a release.
set -eo pipefail
device_checkout=$(pwd)
source_root=${1:?Usage: ci/build.sh SOURCE_ROOT}
evidence="$device_checkout/build-evidence"
mkdir -p "$evidence" "$source_root"
exec > >(tee "$evidence/build.log") 2>&1
cleanup() {
  result=$?
  if [[ -n ${resource_pid:-} ]]; then kill "$resource_pid" 2>/dev/null || true; fi
  df -h > "$evidence/disk-final.txt"
  free -h > "$evidence/memory-final.txt"
  printf '%s\n' "$result" > "$evidence/exit-code.txt"
}
trap cleanup EXIT
# Persist resource snapshots on the runner; no external status polling required.
(
  while true; do
    date -u
    free -m
    df -h "$source_root"
    sleep 60
  done
) >> "$evidence/resources.log" 2>&1 &
resource_pid=$!
printf 'Device tree: %s\n' "$(git rev-parse HEAD)" | tee "$evidence/device-revision.txt"
printf '%s\n' 'DEVELOPMENT BUILD ONLY. NOT BOOT-TESTED. NO WORKING FEATURE CLAIMS.' > "$evidence/STATUS.txt"
cd "$source_root"
repo init -u https://github.com/AERA-Recovery/android_manifest.git -b "$MANIFEST_REVISION" --depth=1 --no-clone-bundle
mkdir -p .repo/local_manifests
cp "$device_checkout/ci/local-manifest.xml" .repo/local_manifests/onyx.xml
repo sync -c --no-clone-bundle --no-tags --fail-fast -j4
repo manifest -r -o "$evidence/resolved-manifest.xml"
git -C bootable/recovery apply "$device_checkout/ci/patches/aera-network-checks.patch"
mkdir -p device/xiaomi
git clone --no-hardlinks "$device_checkout" device/xiaomi/onyx
export AERA_BUILD_DEVICE=onyx
export AERA_BUILD_TMPDIR="$(mktemp -d)"
export ALLOW_NINJA_ENV=true
source build/envsetup.sh
lunch twrp_onyx-bp2a-eng
m -j"${BUILD_JOBS:-2}" recoveryimage
output="$source_root/out/target/product/onyx"
test -s "$output/recovery.img"
for binary in aera-cellular-provider aera-mobile-rmtfs aera-mobile-tftp; do
  test -x "$output/recovery/root/system/bin/$binary"
done
image_size=$(stat -c '%s' "$output/recovery.img")
if (( image_size > 104857600 )); then
  echo "Recovery image exceeds the inherited 100 MiB partition budget." >&2
  exit 1
fi
cp "$output/recovery.img" "$evidence/recovery-onyx-DEVELOPMENT-NOT-BOOT-TESTED.img"
installer="$output/AERA-R1.0-Beta-Unofficial-onyx.zip"
test -s "$installer"
unzip -tq "$installer"
cp "$installer" "$evidence/"
(cd "$evidence" && sha256sum ./recovery-onyx-DEVELOPMENT-NOT-BOOT-TESTED.img "./$(basename "$installer")" > SHA256SUMS)
printf 'Image size: %s bytes\n' "$image_size" > "$evidence/image-size.txt"
