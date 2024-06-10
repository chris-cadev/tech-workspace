#!/bin/bash

CWD=$(dirname $(realpath "$0"))
ln -sf "$CWD/../.config/tmux" "$HOME/.config/tmux"
