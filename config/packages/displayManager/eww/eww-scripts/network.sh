#!/usr/bin/env bash

network_device='wlan0'

echo_initial() {
    status_string=$(nmcli -t device status | grep $network_device | cut -d ':' -f3,4)
    status=$(printf '%s\n' "$status_string" | cut -d ":" -f1)
    ssid=$(printf '%s\n' "$status_string" | cut -d ":" -f2)
    printf '{"status":"%s","ssid":"%s"}\n' $status $ssid
}

process_feed() {
    event=$(printf '%s\n' "${1%}" | cut -d " " -f1)
    if [[ $event == "disconnected" || $event == "connected" ]]; then
        echo_initial
    fi
}

echo_initial

nmcli device monitor $network_device | stdbuf -o0 cut -d " " -f2- | while read -r event; do
    process_feed "${event}"
done
