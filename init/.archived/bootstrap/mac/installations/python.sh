#!/bin/bash

cwd=$(dirname `realpath "$0"`)
bash $cwd/python/pyenv.sh

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
lastest_version=`pyenv install --list | grep -oP "^\s+\d\.\d+\.\d+$" | tail -n 1 | awk '{$1=$1;print}'`
pyenv install -s "$lastest_version"
