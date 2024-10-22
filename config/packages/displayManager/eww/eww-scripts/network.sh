#!/usr/bin/env bash

network_device='wlan0'

echo_initial() {
    status=$(nmcli -t device status | grep "$network_device" | cut -d ':' -f3)
    network_string=$(nmcli -t device wifi list ifname "$network_device" | grep '^*' | sed -E 's/\\:/ /g')
    if [[ $status == "connected" ]]; then
        ssid=$(printf '%s\n' "$network_string" | cut -d ":" -f3)
        signal=$(printf '%s\n' "$network_string" | cut -d ":" -f7)
        printf '{"status":"%s","ssid":"%s","signal":"%s"}\n' "$status" "$ssid" "$signal"
    else
        printf '{"status":"%s","ssid":"","signal":"0"}\n' $status
    fi
}

process_feed() {
    event=$(printf '%s\n' "${1%}" | cut -d " " -f1)
    if [[ ${1%} == "refresh" || $event == "disconnected" || $event == "connected" ]]; then
        echo_initial
    fi
}

echo_initial

nmcli device monitor $network_device | stdbuf -o0 cut -d " " -f2- | while true; do
    if read -r -t 5 event; then
        process_feed "${event}"
    else
        process_feed "refresh"
    fi
done
