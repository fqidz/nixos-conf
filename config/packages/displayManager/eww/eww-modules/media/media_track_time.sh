#!/usr/bin/env bash
if [ "$(playerctl status 2>&1 | awk '{$1=$1};1')" = "No players found" ]; then
    exit 1;
fi

current_time=$(playerctl position)
track_length=$(playerctl metadata | awk '/mpris:length/ {print $3}')

current_seconds=${current_time::-7}
current_minutes=$(((current_seconds % 3600) / 60 ))
current_seconds=$((current_seconds % 60))

track_seconds=$((track_length / 1000000))
track_minutes=$(((track_seconds % 3600) / 60 ))
track_seconds=$((track_seconds % 60))

printf '{"status":"%s","position":"%d:%02d","length":"%d:%02d"}\n' \
    $(playerctl status) \
    $current_minutes $current_seconds \
    $track_minutes $track_seconds
