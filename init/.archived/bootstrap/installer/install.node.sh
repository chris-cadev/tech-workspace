#!/bin/bash

CWD=$(dirname $(realpath "$0"))
set -e

# Check if NVM is installed
if ! type -P nvm > /dev/null; then
    bash $CWD/node/nvm.sh
else
    echo "nvm installed"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

latest_stable_version="`nvm list-remote | grep "Latest LTS" | grep -oE "v\d+\.\d+\.\d+"  | tail -n1`"
if [ -z "$latest_stable_version" ]; then
    echo "no version selected"
    exit 1
fi
if nvm list "$latest_stable_version" | grep -q "$latest_stable_version"
then
    echo "node '$latest_stable_version' is already installed."
else
    nvm install "$latest_stable_version"
fi