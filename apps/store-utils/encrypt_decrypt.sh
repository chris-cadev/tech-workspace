#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <folder|file.tar.gz.gpg>"
    exit 1
fi

input=$1

if [[ -d $input ]]; then
    echo "encrypting directory..."
    # Input is a folder, perform encryption
    output="${input%/}.tar.gz.gpg"
    tar -cvzf "$input" | gpg -c -o "$output"
    echo "Encrypted to $output"
elif [[ $input == *.tar.gz.gpg ]]; then
    echo "decrypting..."
    # Input is a *.tar.gz.gpg file, perform decryption
    output="${input%.tar.gz.gpg}"
    gpg --decrypt < "$input"
    tar -xvzf -C "$(dirname "$output")"
    echo "Decrypted to $output"
else
    echo "Invalid input. Pass either a folder or a *.tar.gz.gpg file."
    exit 1
fi
