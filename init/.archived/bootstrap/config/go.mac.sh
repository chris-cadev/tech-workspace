#!/bin/bash

export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
latest_version=`gvm listall | grep -P "go1\.[0-9]{1,}(\.[0-9])?$" | awk '{$1=$1; print}' | tail -n 1`
gvm use $lastest_version --default 
