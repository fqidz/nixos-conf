#!/usr/bin/env bash
udevadm monitor -us backlight | while read -r; do
    printf '%s\n' $(brightnessctl -m | cut -d ',' -f4 | tr -d '%')
done
