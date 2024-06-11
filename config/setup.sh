#!/bin/bash -e

CWD=$(dirname "$(realpath "$0")")
dotfiles_directory="$(realpath "$CWD/.dotfiles")"
stow_target="$HOME/"
stow_dir="$dotfiles_directory/$1"
shift

stow $@ -d "$stow_dir" -t "$stow_target" .
