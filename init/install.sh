#!/bin/bash -e

CWD=$(realpath "$(dirname "$0")")

alias get_os_name=$CWD/commons/get-os-name.sh

for installer in "$CWD/install.0.*.$(get_os_name).sh"; do
    "$installer"
done

for installer in "$CWD/install.*.$(get_os_name).sh"; do
    "$installer"
done
