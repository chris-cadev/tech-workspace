#!/bin/bash

# https://dvc.org/

snap install --classic dvc

cwd=$(dirname `realpath "$0"`)

dotfiles_local_exporter=`realpath '$cwd../../homelab/.oh-my-zsh/custom/local.zsh'`
link_target="~/.oh-my-zsh/custom/local.zsh"

ln -s "$dotfiles_local_exporter" "$link_target"
