#!/bin/bash

cwd=$(dirname `realpath "$0"`)
bash $cwd/python/pyenv.sh

lastest_version=`pyenv install -l | grep -oP "^\s+\d\.\d+\.\d+$" | tail -n 1`
pyenv install "$lastest_version"
