#!/usr/bin/env bash

iface=$(iw dev | awk '$1 == "Interface" { print $2; exit }')

if [[ -z "$iface" ]]; then
    notify-send "Wi-Fi" "No wireless interface found." -i network-wireless
    exit 1
fi

if ! iw dev "$iface" link | grep -q "^Connected"; then
    notify-send "Wi-Fi" "Not connected." -i network-wireless
    exit 0
fi

ssid=$(iw dev "$iface" link | awk -F': ' '/SSID/ { print $2 }')
signal=$(iw dev "$iface" link | awk '/signal:/ { print $2" "$3 }')
rate=$(iw dev "$iface" link | awk -F': ' '/[rt]x bitrate/ { print $2; exit }')
ip=$(ip -4 addr show "$iface" | awk '/inet / { print $2 }' | cut -d/ -f1)

notify-send \
    "  Wi-Fi" \
    "SSID:    $ssid
Signal:  $signal
Rate:    ${rate:-N/A}
IP:      ${ip:-N/A}" \
    -i network-wireless
