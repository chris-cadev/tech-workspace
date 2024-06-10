#!/bin/bash

set -e
CWD=$(dirname `realpath "$0"`)
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

echo "----------------------------------------------------------------"
echo "Installing package managers..."
echo "----------------------------------------------------------------"
# bash "$CWD/installer/install.brew.mac.sh"
# bash "$CWD/config/brew.mac.sh"
# bash "$CWD/installer/install.terminal-notifier.mac.sh"

echo "----------------------------------------------------------------"
echo "Installing work utilities..."
echo "----------------------------------------------------------------"
brew install coreutils
brew install grep
bash "$CWD/installer/install.keybase.sh"
# bash "$CWD/installer/install.obsidian.sh"
# bash "$CWD/installer/install.syncthing.mac.sh"

echo "----------------------------------------------------------------"
echo "Installing dev tools..."
echo "----------------------------------------------------------------"
# bash "$CWD/installer/install.node.sh"
# bash "$CWD/installer/install.go.mac.sh"
bash "$CWD/installer/install.docker.mac.sh"
# bash "$CWD/installer/install.python.mac.sh"

echo "----------------------------------------------------------------"
echo "Installing dev IDE..."
echo "----------------------------------------------------------------"
# bash "$CWD/installer/install.neovim.sh"
# brew install zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
bash "$CWD/installer/install.pup.mac.sh"
# bash "$CWD/installer/install.play-with-mpv.sh"
