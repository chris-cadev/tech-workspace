#!/bin/bash

brew install go

cwd=$(dirname `realpath "$0"`)

bash "$cwd/go/deps.sh"

bash "$cwd/go/gvm.sh"
source $HOME/.gvm/scripts/gvm

lastest_version=`gvm listall | grep go1. | tail -n 1`

# it is necessary to install 1.4 first, because
# https://github.com/moovweb/gvm#a-note-on-compiling-go-15
gvm install go1.20rc1
gvm install go1.4 -B
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT
gvm install $lastest_version
gvm use $lastest_version --default
