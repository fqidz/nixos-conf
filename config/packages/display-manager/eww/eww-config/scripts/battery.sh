#!/usr/bin/env bash

battery_output() {
    acpi -b | \
        cut -d ' ' -f3-5 | \
        tr ',' '\n' | \
        tr ':' '\n' | \
        tr -d '%' | \
        tr -d ' ' | \
        jq -R | jq -sc '{
            "status": .[0],
            "capacity": ( .[1] | tonumber ),
            "h": (if .[0] != "Full" then ( .[2] | tonumber ) else 0 end),
            "m": (if .[0] != "Full" then ( .[3] | tonumber ) else 0 end),
            "s": (if .[0] != "Full" then ( .[4] | tonumber ) else 0 end)
        }' 2> /dev/null
}

battery_output

udevadm monitor -us drm | while true; do
    if read -r -t 10; then
        battery_output
    else
        battery_output
    fi
done
