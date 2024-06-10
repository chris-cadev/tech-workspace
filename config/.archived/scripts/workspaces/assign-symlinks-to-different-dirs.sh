#!/bin/bash

cwd=$(dirname `realpath "$0"`)
target_dir=${1:-"$cwd/workspaces"}
final_dir=${2:-"$HOME/.oh-my-zsh/custom"}

find "$target_dir" -type l | while read link; do
  abs_target=$(realpath "$(dirname $link)/$(readlink "$link")")
  name=$(basename "$abs_target")
  ln -sf "$abs_target" "$final_dir/$name"
done

