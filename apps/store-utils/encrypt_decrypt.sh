#!/bin/bash

set -euo pipefail

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

if [ $# -ne 1 ]; then
    log "ERROR: Incorrect usage. Expected a folder or a .tar.gz.gpg file."
    echo "Usage: $0 <folder|file.tar.gz.gpg>"
    exit 1
fi

read -s -p "Enter GPG passphrase: " GPG_PASS
export GPG_PASS

echo ""

input=$1

if [[ -d $input ]]; then
    log "Encrypting directory: $input"
    output="${input%/}.tar.gz.gpg"
    tar -cvzf - "$input" | gpg --batch --yes --passphrase "$GPG_PASS" -c -o "$output"
    log "Encryption completed: $output"
    elif [[ $input == *.tar.gz.gpg ]]; then
    log "Decrypting file: $input"
    output="${input%.tar.gz.gpg}"
    gpg --batch --yes --passphrase "$GPG_PASS" --decrypt "$input" | tar -xvzf - -C "$(dirname "$output")"
    log "Decryption completed: $output"
else
    log "ERROR: Invalid input. Must be a directory or a .tar.gz.gpg file."
    exit 1
fi
