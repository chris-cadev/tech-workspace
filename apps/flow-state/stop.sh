#!/bin/bash

set -e
CWD=$(dirname $(realpath "$0"))

persisted_pid_file="$CWD/${1:-".last-pid"}"
if [[ -f $persisted_pid_file ]]; then
    last_pid=$(cat "$persisted_pid_file")
    process_name=$(ps -p $last_pid -o comm= || echo "")
    if [[ $process_name == "mpv" ]]; then
        kill -9 $last_pid
    else
        rm "$persisted_pid_file"
    fi
fi