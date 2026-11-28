#!/bin/bash
if [ "$1" = "onyx" ] || [ "$AERA_BUILD_DEVICE" = "onyx" ]; then
    export LC_ALL=C
    export AERA_AB_DEVICE=1
    export AERA_VIRTUAL_AB_DEVICE=1
    export AERA_VANILLA_BUILD=1
    export AERA_PRODUCT_PREFIX=AERA
    export AERA_BUILD_STATUS=Unofficial
    export AERA_BUILD_TYPE=Beta
    export AERA_TARGET_DEVICES=onyx
    export AERA_USE_BUSYBOX_BINARY=1
    export AERA_ENABLE_MOBILE_DATA=1
    export AERA_USE_LZ4_BINARY=1
    export AERA_USE_ZSTD_BINARY=1
    export AERA_USE_XZ_UTILS=1
fi
