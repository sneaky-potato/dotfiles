#!/usr/bin/env bash

has_bluetooth=$(bluetoothctl info | grep -i 'null')
if [[ -n "$has_bluetooth" ]]; then
    echo -n '%{F#808080}󰂲'
else
    echo -n '%{F#00FFFF}󰂯'
fi
