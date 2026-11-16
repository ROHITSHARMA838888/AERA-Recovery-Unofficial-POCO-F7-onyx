# SPDX-License-Identifier: Apache-2.0
# Initial hardware adaptation; feature bring-up remains pending.
AERA_MAINTAINER := Unofficial onyx port
AERA_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
AERA_ENABLE_ALL_PARTITION_TOOLS := 1
AERA_USE_LZ4_COMPRESSION := 1
AERA_FORCE_PREBUILT_KERNEL := 1
# Networking/audio/GPU/provider settings must follow dependency integration.
# Enabling UI flags alone does not provide these capabilities.
