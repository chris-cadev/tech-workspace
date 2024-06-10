#!/bin/bash

nix-env -iA nixpkgs.neovim
if ! [ -d "$HOME/.config/nvim" ]; then
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
else
    echo "~/.config/nvim already exists"
fi