#!/bin/bash

# TODO: research about why is not properly installed in mac
NIXPKGS_ALLOW_UNFREE=1 nix-env -iA nixpkgs.obsidian
