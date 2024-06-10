#!/bin/bash

cwd=$(dirname `realpath "$0"`)

nix-env -iA nixpkgs.colima
nix-env -iA nixpkgs.docker
nix-env -iA nixpkgs.docker-compose

colima start
docker ps
