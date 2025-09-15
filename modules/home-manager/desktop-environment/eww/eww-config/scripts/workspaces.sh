#!/usr/bin/env bash

# takes the name of the active workspace as arg 1
get_workspaces_json() {
    active_workspace=$1
    hyprctl workspaces -j \
        | jq -rc \
        --arg ACTIVE_NAME $active_workspace \
        'map( { name, "active": (if .name != $ACTIVE_NAME then false else true end) } ) | sort_by ( .name )'
}

get_active_workspace() {
    echo "$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id')"
}

process_event() {
    # Get the first parameter of the string, delimited by '>>' (i.e. the text
    # before '>>')
    # eg. 'workspace>>4' we will get 'workspace'
    event=${1%>>*}

    # Get the last parameter of the string, delimited by '>>' (i.e. the text
    # after '>>')
    # eg. 'createworkspace>>2' we will get '2'
    event_info=${1##*>>}

    # More info on parameter expansion here: https://mywiki.wooledge.org/BashFAQ/073

    if [[ $event == "destroyworkspace" ]]; then
        # The event_info outputted here is the name of the workspace that was
        # destroyed, so we have to get the active workspace name instead.
        get_workspaces_json $(get_active_workspace)

    elif [[ $event == "createworkspace" || $event == "workspace" ]]; then
        # The event_info text only contains the name of the workspace for these events.
        get_workspaces_json "$event_info"

    elif [[ $event == "activespecialv2" ]]; then
        # This is for getting the active workspace for special workspaces.
        #
        # The event_info text here would be something like this:
        #   `-98,special:spotify,eDP-1`
        # which is:
        #   `workspace_id,workspace_name,monitor`
        # We only need the workspace_name so we get only that.
        #
        # When leaving the special workspace, the text outputted would be:
        #   `,,eDP-1`
        # We get an empty string for the workspace_name, so we just get the
        # active workspace name instead.
        workspace_name=$(cut -d ',' -f2 <<< $event_info)
        if [[ -n $workspace_name ]]; then
            get_workspaces_json $workspace_name
        else
            get_workspaces_json $(get_active_workspace)
        fi
    fi
}

# Output once when the script starts
get_workspaces_json $(get_active_workspace)

socat -u "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" - | while read -r event; do
    process_event "${event}"
done
