<div align="center">

# A E R A

### Recovery, brought to onyx.

**POCO F7 · Redmi Turbo 4 Pro**

The upstream AERA experience, adapted for our hardware.

![Unofficial](https://img.shields.io/badge/AERA-UNOFFICIAL-8B5CF6?style=for-the-badge)
![Device](https://img.shields.io/badge/DEVICE-ONYX-22D3EE?style=for-the-badge)
![Development](https://img.shields.io/badge/STATUS-EARLY_DEVELOPMENT-F59E0B?style=for-the-badge)

[Status](#project-status) · [Features](#the-feature-target) · [Roadmap](#development-roadmap) · [Building](#building) · [Credits](#credits)

---

**AERA design. AERA features. Onyx hardware.**

</div>

> [!IMPORTANT]
> **Source draft only — no release image or ZIP is available.**
> This port has not completed a successful AERA compilation or boot test. Features listed below are goals, not verified functionality on POCO F7.

## About this project

An **unofficial port of [AERA Recovery](https://aera-recovery.com/)** for **POCO F7 / Redmi Turbo 4 Pro**, codename **onyx**. We intend to preserve upstream AERA's interface, design and shared functionality while adapting the device tree, drivers and services for this phone.

The goal is a general-purpose recovery for compatible onyx ROMs. The ROM installed on our test device provides hardware evidence; it does not define an exclusive ROM requirement. ROM installation and encrypted-storage decryption need separate compatibility tests. Future ROM changes can require recovery updates.

## Project status

| Milestone | State |
| :--- | :--- |
| AERA core and reference-tree inspection | Initial review completed |
| Onyx hardware inventory | Initial read-only collection completed |
| Initial AERA device-tree adaptation | Draft prepared |
| Original source history and credits | Retained |
| Hardware dependency integration | Pending |
| GitHub Actions workflow | Not added yet |
| Successful compilation | Not completed |
| Boot test on onyx | Not performed |
| Verified working features | None yet |
| Installable image / ZIP | Not available |

**Updated: 16 November 2026.** See [technical port status](PORT-STATUS.md).

## The feature target

| Area | Intended functionality | Onyx tests |
| :--- | :--- | :--- |
| **Native interface** | Upstream AERA touch interface and adaptive layout | Pending |
| **Installation** | Compatible ROM ZIPs, supported partition images and ADB sideload | Pending |
| **Storage** | Mounting, file access, FBE and metadata decryption | Pending |
| **Backup & restore** | Upstream partition backup and restore workflows | Pending |
| **USB** | ADB, MTP, OTG and fastbootd | Pending |
| **Wi-Fi** | Wireless internet inside recovery | Pending |
| **SIM internet** | Mobile data through an adapted cellular provider | Pending |
| **PC Connection** | Upstream browser-based recovery workspace | Pending |
| **Plugins** | Upstream catalog, package verification and compatible runtimes | Pending |
| **Browser & media** | Compatible runtimes, graphics and audio integration | Pending |
| **Other AERA tools** | Root management, rescue and additional compatible tools | Pending |

Full upstream feature coverage is our acceptance target. Device support, runtime availability and real tests determine what can be marked working. SIM mobile data is internet-only; calls and SMS are not part of AERA's documented cellular functionality.

<details>
<summary><strong>Why each feature needs hardware integration</strong></summary>

The shared interface and recovery logic come from AERA. GPU rendering, audio, Wi-Fi, decryption and modem access require matching onyx firmware, kernel modules, libraries and service startup sequences.

POCO F6 provides a useful integration reference, but its binaries are not interchangeable with POCO F7 binaries. Browser/media packages have separate runtime dependencies. A menu entry or an enabled flag does not establish functioning hardware support.

</details>

## Device profile

| Item | Initial baseline |
| :--- | :--- |
| Device family | POCO F7 / Redmi Turbo 4 Pro |
| Codename | `onyx` |
| SoC reported by connected phone | Qualcomm SM8735 |
| Physical display reported | 1280 × 2772 |
| Kernel observed | 6.6.142 |
| Recovery partitions observed | `recovery_a` and `recovery_b` |
| Encryption reported | File-based encryption |
| AERA source branch | `aera-16.0` |

These are initial observations, not a compatibility guarantee for every firmware variant. Android 17 on the test device does not establish support for every Android 17 ROM.

## Development roadmap

- [x] Inspect AERA and official reference device trees.
- [x] Collect initial onyx hardware evidence without changing the phone.
- [x] Prepare Unofficial AERA product configuration.
- [x] Retain original source history and file attribution.
- [ ] Review inherited build flags, fstab, crypto sequencing and module ABI.
- [ ] Integrate onyx graphics, audio, Wi-Fi and cellular dependencies.
- [ ] Resolve runtime-package availability and redistribution requirements.
- [ ] Add and validate a Linux GitHub Actions workflow.
- [ ] Compile and inspect the first complete recovery image.
- [ ] Validate boot, touch, storage, USB and decryption.
- [ ] Validate flashing, backup/restore, networking, media and plugins.
- [ ] Publish tested artifacts, hashes and known limitations.

## Source layout

```text
.
├── AndroidProducts.mk       Product registration
├── BoardConfig.mk           Inherited board configuration; under review
├── device.mk                Device packages and product inheritance
├── aera_onyx.mk             Initial AERA device settings
├── twrp_onyx.mk             Product target; inherited build prefix
├── vendorsetup.sh           Unofficial AERA metadata
├── prebuilt/                Inherited prebuilts; compatibility audit pending
├── recovery/root/           Init files, device libraries and modules
├── bootctrl/                Inherited boot-control support
├── gpt-utils/               Inherited partition support
└── PORT-STATUS.md           Technical limitations
```

The `twrp_` product prefix is inherited build plumbing. The intended interface is AERA. This repository contains a device tree, not a complete Android/AERA checkout.

## Building

**There is no validated build recipe or Actions workflow yet.** The intended approach is:

1. Sync the upstream [AERA Android 16 manifest](https://github.com/AERA-Recovery/android_manifest).
2. Integrate this device tree at `device/xiaomi/onyx`.
3. Finish dependency integration and validate the product configuration.
4. Pin source revisions and compile on a Linux GitHub Actions runner with adequate resources.
5. Inspect the output before any device testing.

The draft registers `twrp_onyx-bp2a-eng`; that registration does not prove that it builds. No generic flashing command is provided until the image and installation path have been validated.

## Validation plan

| Stage | Required evidence |
| :--- | :--- |
| Artifact | Source revisions, hashes, image size, boot header and ramdisk inspection |
| Core device support | Real boot, touch, display, slots, storage and decryption |
| Recovery operations | USB modes, compatible installation, backup and controlled restore |
| Connectivity | Actual Wi-Fi/mobile internet, DNS, reconnect and fallback |
| Runtime features | Individual plugin, browser, media and audio tests |
| Return to Android | Normal boot and working audio, Wi-Fi and cellular after recovery use |

All stages remain pending. Cross-ROM installation and cross-ROM decryption are separate results. Do read-only checks first; prepare a recovery path before destructive tests. Do not modify EFS, NV, calibration or encryption metadata as a speculative fix.

## Contributing and reports

Useful contributions include dependency analysis, build fixes and reproducible test evidence. Keep device-specific changes in the onyx tree and preserve upstream authorship.

Include the source commit, firmware/ROM version, exact steps, expected behavior and relevant logs in reports. Remove serial numbers, SIM identifiers, credentials and other private information. Do not describe an untested feature as working.

## Credits

| Project | Role |
| :--- | :--- |
| [AERA Recovery](https://github.com/AERA-Recovery/android_bootable_recovery) | Recovery engine, native interface and shared features |
| [AERA manifest](https://github.com/AERA-Recovery/android_manifest) | Android 16 source manifest and dependencies |
| [onyx-oss recovery tree](https://github.com/onyx-oss/android_device_xiaomi_onyx_recovery) | Original onyx hardware starting point, `fox_12.0` |
| [Official POCO F6 AERA tree](https://github.com/AERA-Recovery/android_device_xiaomi_peridot-AERA) | Primary POCO integration reference |
| [Xiaomi 15 AERA tree](https://github.com/AERA-Recovery/android_device_xiaomi_dada-AERA) | Additional graphics and audio reference |
| [OnePlus 15 AERA tree](https://github.com/AERA-Recovery/android_device_oneplus_infiniti-AERA) | Additional cellular reference |
| [TeamWin](https://github.com/TeamWin), [OrangeFox](https://gitlab.com/OrangeFox), [AOSP](https://source.android.com/) | Recovery foundations and original contributors |

Unofficial port maintained in [ROHITSHARMA838888's repository](https://github.com/ROHITSHARMA838888/AERA-Recovery-Unofficial-POCO-F7-onyx). This project does not imply endorsement or official support from AERA or Xiaomi.

## Licensing

Original files retain their copyright and license notices. Different upstream licenses apply to different files; no blanket license is asserted for the entire repository. Proprietary prebuilts are not relicensed by this project. Their redistribution audit remains outstanding.

---

<div align="center">

**Built for onyx. Powered by upstream AERA.**

Development in progress · No release available yet

</div>
