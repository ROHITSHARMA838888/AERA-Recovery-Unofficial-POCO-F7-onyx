# Draft only — not built or boot-tested

Preserves the onyx hardware source's attribution and prebuilts. Replaces the
OrangeFox product configuration with initial AERA product metadata. Omits Fox UI,
FFiles and forced recovery rewrite hooks so these are not silently inherited.

Open blockers: audit remaining legacy BoardConfig flags, Android 16 product paths,
prepdecrypt sequencing, kernel-module ABI and filesystem configuration; integrate
onyx EGL/allocator, audio, WLAN and cellular dependencies; package public runtime
assets; complete full-feature testing on device. Existing prebuilts are inherited,
not yet validated against installed firmware. Do not build a release from this draft.
