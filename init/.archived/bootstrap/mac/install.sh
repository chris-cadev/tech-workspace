#!/bin/bash

set -e
# add the grep extra things from GNU
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
cwd=$(dirname `realpath "$0"`)

echo "Installing package managers..."
sh "$cwd/installations/nix.sh"
bash "$cwd/installations/brew.sh"

. ~/.bashrc

echo "Installing work utilities..."
brew install coreutils
brew install grep
bash "$cwd/installations/keybase.sh"
bash "$cwd/installations/obsidian.sh"
bash "$cwd/installations/syncthing.sh"

echo "Installing dev tools..."
bash "$cwd/installations/node.sh"
bash "$cwd/installations/go.sh"
bash "$cwd/installations/docker.sh"
bash "$cwd/installations/python.sh"

echo "Installing dev IDE..."
bash "$cwd/installations/tmux.sh"
bash "$cwd/installations/neovim.sh"
bash "$cwd/installations/oh-my-zsh.sh"
bash "$cwd/installations/pup.sh"
bash "$cwd/installations/play-with-mpv.sh"