#!/usr/bin/env bash

# Gets the time now in unix epoch milliseconds
now() {
    echo $(date "+%s%3N")
}

# Gets the time for the next minute in unix epoch milliseconds
next_minute() {
    echo "$(date -d $(date -d '+1 min' '+%H:%M:00') '+%s')000"
}

# Number of seconds until the next minute (with millisecond resolution)
secs_to_next_min() {
    millis_to_next_min=$(( $(next_minute) - $(now) ))
    bc <<< "scale=3; $millis_to_next_min / 1000"
}

# Output some text when the next minute comes
output_every_minute() {
    while true; do
        sleep $(secs_to_next_min)
        # text outputted here doesn't matter
        echo "one minute has passed"
    done
}

# Print current datetime formatted in json
output_datetime() {
    date '+{"week_day":"%a","month":"%b","day":"%d","hour":"%H","minute":"%M"}'
}

TMP_FILE=/tmp/datetime-script-pipe

cleanup() {
    rm $TMP_FILE
    # TODO: silence output
    kill -SIGKILL 0
}

error=$(mkfifo $TMP_FILE 2>&1)
if [[ -n $error ]]; then
    echo $error 1>&2
    exit 1
fi

trap cleanup HUP EXIT

# Join the `output_every_minute` and `monitor-wake` stdout streams together so
# that it outputs the current datetime whenever the next minute comes up OR when
# the device is awoken from sleep.
#
# Pipe these commands into the named pipe and let them running in the
# background so they don't block execution.
output_every_minute > $TMP_FILE &

# Save the pid of the latest background process (the `output_every_minute >
# ...` so we can kill it later when the device wakes up.
minute_pid=$(echo $!)

# monitor-wake: https://github.com/fqidz/monitor-wake
monitor-wake > $TMP_FILE &

# Output the datetime once when the script starts
output_datetime

# Continuously read the named pipe so that we output the datetime whenever a new
# line of text is read from the pipe.
while read -r msg; do
    output_datetime

    # We kill and restart the `output_every_minute > ...` background process
    # whenever we wake up from sleep because the `sleep` count would be
    # inaccurate (cause it isn't counting down while the device is asleep).
    if [[ $msg == "woken" ]]; then
        kill $minute_pid
        output_every_minute > $TMP_FILE &
        minute_pid=$(echo $!)
    fi

done < <(cat $TMP_FILE)
