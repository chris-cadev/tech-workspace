#!/bin/bash

cwd=$(dirname `realpath "$0"`)
set -e

# Check if NVM is installed
if ! command -v nvm &> /dev/null
then
    bash $cwd/node/nvm.sh
else
    echo "nvm installed"
fi

lastest_stable_version=`nvm list-remote | grep "Latest LTS" | grep -oP "v\d+\.\d+\.\d+"  | tail -n 1`
if nvm list "$latest_stable_version" | grep -q "$latest_stable_version"
then
    echo "node '$latest_stable_version' is already installed."
else
    nvm install "$latest_stable_version"
fi
