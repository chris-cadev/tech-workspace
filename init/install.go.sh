#!/bin/bash -e

[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
# it is necessary to install 1.4 first, because
# https://github.com/moovweb/gvm#a-note-on-compiling-go-15
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT

latest_version=$(gvm listall | grep -oE "go[0-9]+\.[0-9]+\.[0-9]+" | sort -V | tail -n 1)
installer_version=${1:-$latest_version}
gvm install $installer_version
gvm use $installer_version --default
