#!/usr/bin/env bash
active_workspace=$(hyprctl -j activeworkspace | jq -rc '.name')
target_workspace="$1"

if [[ "$active_workspace" == "$target_workspace" ]]; then
    exit 1
fi

windows=$(hyprctl -j clients)

active_workspace_windows=$(
    printf "%s\n" "$windows" | \
        jq -rc --arg active_workspace "$active_workspace" '
            .[] |
            select(.workspace.name==$active_workspace) |
            .address
        '
)

target_workspace_windows=$(
    printf "%s\n" "$windows" | \
        jq -rc --arg target_workspace "$target_workspace" '
            .[] |
            select(.workspace.name==$target_workspace) |
            .address
        '
)

while IFS=' ' read address; do
    hyprctl dispatch movetoworkspacesilent $target_workspace,address:$address > /dev/null
done <<< "$active_workspace_windows"

while IFS=' ' read address; do
    hyprctl dispatch movetoworkspacesilent $active_workspace,address:$address > /dev/null
done <<< "$target_workspace_windows"

hyprctl dispatch workspace "$target_workspace" > /dev/null
