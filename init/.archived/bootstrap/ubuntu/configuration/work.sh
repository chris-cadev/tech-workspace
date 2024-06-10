#!/bin/bash

root_dir="`dirname $0`/.."

create_link() {
    local where="$1"
    local from="$2"
    if [[ ! -L $where  ]]
    then
        mv $where "$where.bak"
        ln -fs "`realpath $from`" "`realpath $where`"
    fi
}

echo "Installing work setup"
create_link "$HOME/.oh-my-zsh/custom" "$root_dir/work/.oh-my-zsh/custom"
create_link "$HOME/.ssh/config" "$root_dir/work/.ssh/config"
create_link "$HOME/.bash_logout" "$root_dir/work/.bash_logout"
create_link "$HOME/.bash_bashrc" "$root_dir/work/.bash_bashrc"
create_link "$HOME/.zshrc" "$root_dir/work/.zshrc"
create_link "$HOME/.gitconfig" "$root_dir/work/.gitconfig"

for file in `find $root_dir/work -type f`; do
    ls -l "$file"
done
