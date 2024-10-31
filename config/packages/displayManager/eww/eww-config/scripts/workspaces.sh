#!/usr/bin/env bash

get_workspace() {
    active_workspace=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id')
    workspaces_json=$(
    hyprctl workspaces -j \
        | jq -rc \
        --arg ACTIVE_ID $active_workspace \
        'map( { id: .id | select( . > 0 ) | tostring } ) |
        map( . + { "active": (if .id != $ACTIVE_ID then false else true end) } ) | sort_by ( .id )'
    )
    echo "${workspaces_json}"
}

process_event() {
    if [[ ${1%>>*} == "createworkspace" || ${1%>>*} == "destroyworkspace" || ${1%>>*} == "workspace" ]]; then
        get_workspace
    fi
}

get_workspace

socat -u "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" - | while read -r event; do
    process_event "${event}"
done
