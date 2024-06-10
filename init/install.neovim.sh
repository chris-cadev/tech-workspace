#!/bin/bash -e
# unless bob (neovim version manager) is already installed
if ! command -v bob &> /dev/null; then
    cargo install --git https://github.com/MordechaiHadad/bob.git
    mkdir -p $(brew --prefix)/etc/bash_completion.d
    bob complete bash > $(brew --prefix)/etc/bash_completion.d/bob.bash-completion
    mkdir ~/.zfunc
    bob complete zsh > ~/.zfunc/_bob
fi