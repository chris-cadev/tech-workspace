#!/bin/bash

CWD=$(dirname "$(realpath "$0")")
dotfiles_directory=$(realpath "$CWD/.dotfiles")

if [ -f .env ]; then
    export $(cat .env | grep -vP '^\s.+?#' | awk '/=/ {print $1}')
else
    echo ".env file not found."
fi

stow -d "$dotfiles_directory" -t ~/ .

if ! [ -z $CONFIG_TECH_WORKSPACE ]; then
    stow -d "$dotfiles_directory/$CONFIG_TECH_WORKSPACE" -t ~/ .
    exit 0
fi

workspaces=(
    $dotfiles_directory/personal
    $dotfiles_directory/work/drata
)

PS3='Select a directory: '
select workspace in "${workspaces[@]}"; do
    stow -d "$workspace" -t ~/ .
    break
done
