#!/bin/bash

CWD=$(dirname $(realpath "$0"))

bash "$CWD/config/brew.mac.sh"
bash "$CWD/config/pup.sh"
bash "$CWD/config/dotfiles.sh"
