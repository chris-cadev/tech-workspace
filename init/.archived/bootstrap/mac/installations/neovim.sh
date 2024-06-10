#!/bin/bash

nix-env -iA nixpkgs.neovim
git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

