#!/bin/bash

CWD=$(dirname $(realpath "$0"))

bash "$CWD/go/gvm-deps.mac.sh"
if ! [ -d "$HOME/.gvm" ]; then
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    bash $HOME/.gvm/extra/vagrant/install-deps.sh
else
    echo "gvm already installed"
fi