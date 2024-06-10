#!/bin/sh

CWD=$(dirname $(realpath "$0"))

if ! command -v nix-env &> /dev/null; then
  curl -L https://nixos.org/nix/install | sh
fi

export PATH=$PATH:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin
