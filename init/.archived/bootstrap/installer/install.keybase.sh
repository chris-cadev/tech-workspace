#!/bin/bash

# nix-env -iA nixpkgs.keybase-gui
# open https://keybase.io/download
terminal-notifier -title "Download Keybase" -message "Please download Keybase from the official website." -execute "open https://keybase.io/download"
