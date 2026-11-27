#!/system/bin/sh
set -eu

if [ ! -e /sys/class/net/wlan0 ]; then
    icnss=/sys/kernel/icnss
    test -w "$icnss/wlan_en_delay" && test -w "$icnss/wpss_boot" || exit 1
    printf '1000\n' > "$icnss/wlan_en_delay"
    printf '1\n' > "$icnss/wpss_boot"
fi

for attempt in $(seq 1 15); do
    if [ -e /sys/class/net/wlan0 ]; then
        setprop wifi.driver.ready true
        setprop sys.aera.onyx.wlan.ready 1
        exit 0
    fi
    sleep 1
done
exit 1
