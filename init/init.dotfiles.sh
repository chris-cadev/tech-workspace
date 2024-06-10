#!/bin/bash -e

CWD=$(realpath "$(dirname "$0")")
stow --dir="$CWD/../config/.dotfiles" --target="$HOME/"