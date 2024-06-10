#!/bin/bash

cwd=$(dirname `realpath "$0"`)

# nix-env -iA nixpkgs.colima
# nix-env -iA nixpkgs.docker
# nix-env -iA nixpkgs.docker-compose
terminal-notifier -title "Download Docker" -message "Please download Docker from the official website." -execute "open https://www.docker.com/products/docker-desktop/"
