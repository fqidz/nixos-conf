#!/usr/bin/env bash
status=$(playerctl status 2>&1)
if [ "$status" = "No players found" ]; then
    status=""
else
    title=$(playerctl metadata --format '{{ title }}')
    artist=$(playerctl metadata --format '{{ artist }}')
    position=$(playerctl metadata --format '{{ duration(position) }}')
    length=$(playerctl metadata --format '{{ duration(mpris:length) }}')
fi

printf '{"status":"%s","artist":"%s","title":"%s","position":"%s","length":"%s"}\n' \
    "$status" "$artist" "$title" "$position" "$length" | awk '{print tolower($0)}'


