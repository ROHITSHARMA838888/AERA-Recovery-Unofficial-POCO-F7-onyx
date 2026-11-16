# Unofficial AERA Recovery for POCO F7 / Redmi Turbo 4 Pro (onyx)

Early device-tree adaptation for upstream AERA Recovery. The goal is to retain
AERA's interface and features while adding onyx hardware support. This is a
general-purpose device recovery project, not an installer for one particular ROM.

**Status: draft only. No successful AERA build or device boot test yet. No release
image is available. Do not flash images made from this tree without further review.**

## Current work

- Initial AERA product configuration and Unofficial build metadata.
- Onyx hardware files inherited from the existing recovery tree, still requiring
  compatibility and dependency review.
- OrangeFox UI assets and forced recovery rewrite hooks omitted from this adaptation.
- GPU, audio, Wi-Fi, cellular, crypto and runtime integration remain incomplete.

Full AERA feature coverage is the project target, not a claim of current support.
GitHub Actions build automation is planned but has not been added or validated.
See [PORT-STATUS.md](PORT-STATUS.md) for remaining work.

## Sources and credits

- [AERA Recovery](https://github.com/AERA-Recovery/android_bootable_recovery),
  [Android 16 manifest](https://github.com/AERA-Recovery/android_manifest).
- [Original onyx recovery tree](https://github.com/onyx-oss/android_device_xiaomi_onyx_recovery),
  branch `fox_12.0`. Original history and file notices are retained.
- [Official POCO F6 AERA reference](https://github.com/AERA-Recovery/android_device_xiaomi_peridot-AERA).
- [Xiaomi 15 reference](https://github.com/AERA-Recovery/android_device_xiaomi_dada-AERA).
- [OnePlus 15 cellular reference](https://github.com/AERA-Recovery/android_device_oneplus_infiniti-AERA).

Thanks to upstream AERA, OrangeFox, TeamWin, AOSP and the original device-tree
contributors. This project is unofficial and does not imply upstream endorsement.
Existing files retain their original licenses; proprietary prebuilts are not
relicensed by this project. A redistribution audit remains outstanding.
