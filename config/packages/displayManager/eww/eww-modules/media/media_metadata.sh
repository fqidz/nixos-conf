#!/usr/bin/env bash
if [ "$(playerctl status 2>&1 | awk '{$1=$1};1')" = "No players found" ]; then
    exit 1;
fi
readarray -t info_arr < <(playerctl metadata \
    | awk '/xesam:artist/ || /xesam:title/' \
    | cut -f 3- -d ' ' \
    | awk '{$1=$1};1' \
    | awk '{print tolower($0)}'
)

printf '{"artist":"%s","title":"%s"}\n' \
    "${info_arr[0]}" \
    "${info_arr[1]}"
