#!/bin/bash

current_directory=$(dirname $0)
bash $current_directory/pyenv.sh
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 3.7.13
pip install --user pipenv
