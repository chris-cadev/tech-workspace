#!/bin/bash -e

if ! command -v bob &> /dev/null; then
    cargo install --git https://github.com/MordechaiHadad/bob.git
fi

brew_completion_dir="$(brew --prefix)/etc/bash_completion.d"
mkdir -p "$brew_completion_dir"

if ! diff <(bob complete bash) "$brew_completion_dir/bob.bash-completion" &>/dev/null; then
    bob complete bash > "$brew_completion_dir/bob.bash-completion"
fi

zfunc_dir="$HOME/.zfunc"
mkdir -p "$zfunc_dir"

if ! diff <(bob complete zsh) "$zfunc_dir/_bob" &>/dev/null; then
    bob complete zsh > "$zfunc_dir/_bob"
fi
