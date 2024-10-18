#!/usr/bin/env bash
echo_info() {
    pactl --format="json" list sinks | \
        jq -rc '
            .[] |
            {
                "device": .properties."device.profile.description",
                "volume_percent": (
                    [
                        (
                            # get left & right volume and put them into an array
                            .volume."front-left".value_percent,
                            .volume."front-right".value_percent
                        ) | sub("%"; "") | tonumber  # remove percent sign and convert to number
                    ] | add/length  # calculate the mean of the array
                ),
                "muted": .mute
            }
        '
}

initial=$(echo_info)
echo $initial

process_feed() {
    if [[ ${1%} == "sink" ]]; then
        new=$(echo_info)
        # compare previous value so that it doesnt
        # unnecessarily output the same
        if [[ $new != $initial ]]; then
            initial=$new
            echo $new
        fi
    fi
}

pactl subscribe | stdbuf -o0 cut -d " " -f4 | while read -r event; do
    process_feed "${event}"
done
