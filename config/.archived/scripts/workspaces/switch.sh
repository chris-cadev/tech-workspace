#!/bin/bash

cwd=$(dirname `realpath "$0"`)
workspaces_directory=`realpath "$cwd/../../workspaces/"`
workspaces=($workspaces_directory/*/)

function switch() {
    local workspace="$1"
    "$cwd/switch-omz.sh" "$workspace"
}

if [ ! -z "$1" ]; then
    selected=$(($1 - 1))
    switch "${workspaces[$selected]}"
    exit 1
fi

PS3='Select a directory: '
select workspace in "${workspaces[@]}"; do
    switch "$workspace"
    break
done
