#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))

# unless pyenv is already installed
if ! command -v pyenv >/dev/null 2>&1; then
    # curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    curl https://pyenv.run | bash
    source $CWD/../config/pyenv/.oh-my-zsh/custom/pyenv.zsh
fi

bash $CWD/install.python-dependencies.sh

pyenv install 3:latest
pyenv global $(pyenv latest 3)