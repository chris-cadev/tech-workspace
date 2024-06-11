#!/bin/bash -e

CWD=$(dirname "$(realpath "$0")")
dotfiles_directory=$(realpath "$CWD/.dotfiles")
env_file="$CWD/.env"
stow_target="$HOME/"

if [ -f $env_file ]; then
    export $(cat $env_file | grep -vE '^\s.+?#' | awk '/=/ {print $1}')
else
    echo "config/.env file not found."
fi

stow $@ -d "$dotfiles_directory" -t "$stow_target" .

if ! [ -z $CONFIG_TECH_WORKSPACE ]; then
    stow $@ -d "$dotfiles_directory/$CONFIG_TECH_WORKSPACE" -t $stow_target .
    exit 0
fi

workspaces=(
    $dotfiles_directory/personal
    $dotfiles_directory/work/drata
)

PS3='Select a directory: '
select workspace in "${workspaces[@]}"; do
    stow $@ -d "$workspace" -t $stow_target .
    break
done
