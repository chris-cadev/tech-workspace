#!/bin/bash -e

# unless pyenv is already installed
if ! command -v pyenv >/dev/null 2>&1; then
    # curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
    curl https://pyenv.run | bash
fi

pyenv install 3:latest
pyenv global $(pyenv latest 3)
