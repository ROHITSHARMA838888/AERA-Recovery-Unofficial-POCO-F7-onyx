# Onyx developer handoff

## Where r6 was built and tested

- **Build host:** ServerHive Linux VPS, using an existing synced AERA checkout and incremental `recoveryimage` build. The release IMG, installer ZIP and checksums came from that run.
- **Phone test:** POCO F7 (`onyx`), recovery slot B, Yasvara ROM and Drago `6.12.119-ge20f6b96dbcc`. See the table below for feature results.
- **Still to verify:** A full build from a fresh Linux checkout using the published instructions, and the GitHub Actions workflow at this release revision. The upstream Android source is fetched by `repo` at the documented revisions. No access to the original VPS is required to attempt the build.
- **First developer check:** Build from the release tag using the pinned manifest and Onyx patch. Confirm that it produces both the recovery IMG and installer ZIP, record their checksums, then test the new IMG on the documented phone setup if available.

## Build and source

The device tree, build script, local manifest and Onyx-specific AERA patches are in this repository. The published r6 build uses the AERA Android 16 manifest at `aabd43b2478f3e6dcd0330e7cd5839746c0bf9a7` and AERA recovery core at `1cabc50919d2587ba986f679f946f52963130fc1`. The [resolved upstream manifest](ci/resolved-manifest.xml) records the dependency revisions. The [network patch](ci/patches/aera-network-checks.patch) contains the WLAN connection check and plugin downloader changes. Cellular code is in [mobile_data](mobile_data/) and uses the pinned AERA QRTR, RMTFS and TFTP projects. Preserve upstream licenses and attribution.

On a Linux build host with Git, Android `repo`, standard AOSP build tools and sufficient disk and RAM, clone this repository and run from its root.

```bash
export MANIFEST_REVISION=aabd43b2478f3e6dcd0330e7cd5839746c0bf9a7
export BUILD_JOBS=8
bash ci/build.sh /absolute/path/to/aera-onyx-source
```

Use a fresh source directory for the script. It syncs dependencies, applies the core patch and clones the committed Onyx tree into `device/xiaomi/onyx`. Choose `BUILD_JOBS` to fit the host. The GitHub Actions Build workflow can also be started manually. The server build reused a synced checkout.

For an incremental build from an already provisioned source tree, use a fresh shell and run the following from the source root.

```bash
export AERA_BUILD_DEVICE=onyx ALLOW_NINJA_ENV=true
export AERA_BUILD_TMPDIR="$(mktemp -d)"
source build/envsetup.sh
lunch twrp_onyx-bp2a-eng
m -j8 recoveryimage
```

Artifacts are produced in `out/target/product/onyx/`. Inspect the IMG and the actual installer ZIP from the same run. The recovered r6 artifacts have their own SHA-256 list in the release. The 100 MiB recovery partition limit includes any image overhead.

## Device and test results

Test phone was a POCO F7 (`onyx`) on Yasvara, slot B, using the Drago 6.12.119 kernel. Onyx uses dedicated A/B recovery partitions and the recovery image carries a ramdisk. The running kernel and compatible vendor modules come from the installed boot stack. Use bootloader `fastboot getvar product` and `fastboot getvar current-slot` to verify the target before flashing. Preserve a verified copy of that slot's current recovery and keep a known-good bootloader restore route. A published test IMG or ZIP should be qualified on the target setup before daily use.

| Area | Evidence |
| --- | --- |
| r6 boot and USB | Recovery boot and ADB worked on slot B. |
| Touch | Worked on the Yasvara test setup. Infinity-X OSS recovery touch remains unresolved. |
| Storage | The test device's unencrypted internal storage was mounted and readable. PIN-protected FBE unlock is unverified. The tree lets prepdecrypt publish readiness instead of marking it at vendor mount. |
| Wi-Fi | Association, DHCP, Internet and DNS passed in the earlier WLAN bring-up. The r6 cellular tests used the cellular route. |
| Cellular | Clean r6 boot, active-slot modemfirmware mounted read-only, SIM data route through rmnet_aera, IP reachability and DNS. Jio and Vi connected. Vi network type and signal bars remain unverified. |
| Plugin Manager | Catalog refresh populated the list. Individual plugin installation and launch need qualification. |
| Flashing | A no-op ZIP updater passed on the earlier touch build. Real ROM install, backup/restore, fastbootd, sideload, and encrypted storage still need dedicated tests. |

## Continue development

- **Touch on OSS kernels.** Compare `dmesg` and `getevent` on Yasvara and Infinity-X. Both have `nt36532` evidence, but the Onyx load list inherits `nt38771` and uses the installed kernel stack. Compare the runtime driver, module dependencies and Novatek firmware/library paths.
- **Cellular.** The provider uses the active slot's `modemfirmware` partition and passes its full `image` directory to the TFTP helper. The one-folder prototype missed a modem RF module and caused a modem fatal restart. Keep firmware mounts read-only and modem storage writes confined to RAM. Check the selected SIM's APN, network generation and signal reporting separately from IP connectivity.
- **Browser.** Initial launch failed because `/dev/kgsl-3d0` was missing. Loading `msm_kgsl` and dependencies created the node. Recovery also reported a missing Adreno EGL library. A [standalone retry patch](ci/patches/browser-retry-experimental.patch) preserves the local UI work for follow-up. It is untested and was excluded from r6. Keep the Browser sandbox intact while adapting the GPU stack.
- **Build qualification.** Test the final IMG on a clean boot, keep a verified rollback IMG, and record the ROM, slot and kernel for every result.

## Credits

AERA Recovery Project and contributors for the recovery core and upstream reference trees. The Onyx tree retains its upstream history and credits. The cellular implementation credits and source revision are in [mobile_data/README.md](mobile_data/README.md).
