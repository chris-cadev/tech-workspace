#!/bin/bash

if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/christiancamacho/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"