#!/usr/bin/env bash

if ! bluetoothctl show | grep -q "Powered: yes"; then
    echo ""
    exit 0
fi

if bluetoothctl info >/dev/null 2>&1; then
    name=$(bluetoothctl info | awk -F': ' '/Name/ { print $2; exit }')
    echo " $name"
else
    echo ""
fi
