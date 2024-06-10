#!/bin/bash


CWD=$(dirname $(realpath "$0"))
set -e

brew install go

bash "$CWD/install.gvm.mac.sh"
source $HOME/.gvm/scripts/gvm

latest_version=`gvm listall | grep go1. | tail -n 1`

# it is necessary to install 1.4 first, because
# https://github.com/moovweb/gvm#a-note-on-compiling-go-15
export GOROOT_BOOTSTRAP=$GOROOT
gvm install $lastest_version
