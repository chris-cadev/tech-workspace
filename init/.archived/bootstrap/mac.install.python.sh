#!/bin/bash

CWD=$(dirname `realpath "$0"`)

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# configure pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

lastest_version=`pyenv install --list | grep -oP "^\s+\d\.\d+\.\d+$" | tail -n 1 | awk '{$1=$1;print}'`

# Check if the Python version is already installed
if pyenv versions --bare | grep -q "$lastest_version"; then
  echo "Python $lastest_version is already installed."
else
  # Install the Python version
  echo "Python $lastest_version is not installed. Installing..."
  pyenv install "$lastest_version"

  # Set the newly installed version as the global default
  pyenv global "$lastest_version"

  # Reload the shell to apply changes
  exec "$SHELL"

  echo "Python $python_version has been installed and set as the global default."
fi
# pyenv install -s "$lastest_version"
# pyenv global "$lastest_version"

pip install --user pipenv
