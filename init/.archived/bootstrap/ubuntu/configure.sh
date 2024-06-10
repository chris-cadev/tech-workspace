#!/bin/bash
remote_repo_url="https://github.com/chris-cadev/.dotfiles.git"

echo "Where the .dotfile will be installed? (default: ~/.dotfiles)"
read dotfiles_dir
dotfiles_dir="${dotfiles_dir:-"$HOME/.dotfiles"}"

echo "Clonning repository"
git clone $remote_repo_url "$dotfiles_dir"

echo "Which setup do you want?"
select setup in `find "$dotfiles_dir/bootstrap/configuration" -type f`; do
    bash $setup
    break
    exit 0
done
