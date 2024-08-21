#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))

installer_name=$(basename "$0")
installer_name="${installer_name%.*}"

$(dirname "$0")/$installer_name.$($CWD/get-os-name.sh).sh
