#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))

workspace="$1"

if [ -z "$workspace" ]; then
    echo "1 parameter was expected, but found 0"
    exit 1
fi

if [ ! -d "$workspace" ]; then
    echo "Workspace does not exist"
    exit 1
fi

omz_custom_folder="$HOME/.oh-my-zsh/custom"

local_workspace_folder="$omz_custom_folder"
zsh_files=($(find $CWD/../../zsh -type f -name "*.zsh" -exec basename {} \;))
workspace_files=($(find $local_workspace_folder -depth 1 -type l -name "*.zsh" -exec basename {} \;))

for zsh_file in "${zsh_files[@]}"; do
    for workspace_file in "${workspace_files[@]}"; do
        if [[ "$zsh_file" == "$workspace_file" ]]; then
            rm "$local_workspace_folder/$workspace_file"
        fi
    done
done

"$CWD/assign-symlinks-to-different-dirs.sh" "$workspace" "$local_workspace_folder"

echo "switch DONE!"

echo "ls -la $local_workspace_folder"
ls -la "$local_workspace_folder"

echo "execute the following command"
echo "    source ~/.zshrc"
echo ""
echo "or restart your terminal"
echo ""

