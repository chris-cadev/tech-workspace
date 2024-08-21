#!/bin/bash -e

if ! command -v bob &> /dev/null; then
    cargo install --git https://github.com/MordechaiHadad/bob.git
fi

mkdir -p ~/.local/share/bash-completion/completions
if ! grep -q "bob complete bash" ~/.local/share/bash-completion/completions/bob 2>/dev/null; then
    bob complete bash >> ~/.local/share/bash-completion/completions/bob
fi

mkdir -p ~/.zfunc
if ! diff <(bob complete zsh) ~/.zfunc/_bob &>/dev/null; then
    bob complete zsh > ~/.zfunc/_bob
fi