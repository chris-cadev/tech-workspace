#!/bin/bash

cwd=$(dirname `realpath "$0"`)

echo "Installing dev tools..."
bash "$cwd/installations/node.sh"
bash "$cwd/installations/deno.sh"
bash "$cwd/installations/python.sh"
bash "$cwd/installations/go.sh"
bash "$cwd/installations/docker.sh"

echo "Installing workflow tools..."
bash "$cwd/installations/brave.sh"
bash "$cwd/installations/tmux.sh"
bash "$cwd/installations/dvc.sh"
bash "$cwd/installations/syncthing.sh"
bash "$cwd/installations/oh-my-zsh.sh"

echo "Installing work utilities..."
bash "$cwd/installations/neovim.sh"
bash "$cwd/installations/keybase.sh"
bash "$cwd/installations/fonts.sh"
bash "$cwd/installations/pup.sh"
bash "$cwd/installations/play-with-mpv.sh"
