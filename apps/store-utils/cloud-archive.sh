#!/bin/bash

set -e

command -v bw >/dev/null 2>&1 || { echo >&2 "Bitwarden CLI (bw) is required but not installed. Aborting."; exit 1; }
command -v gpg >/dev/null 2>&1 || { echo >&2 "gpg is required but not installed. Aborting."; exit 1; }
command -v rclone >/dev/null 2>&1 || { echo >&2 "rclone is required but not installed. Aborting."; exit 1; }

DIRECTORY_TO_ARCHIVE="${1:-"$PWD"}"
DIRECTORY_TO_ARCHIVE=`realpath "$DIRECTORY_TO_ARCHIVE"`

if ! [ -d "$DIRECTORY_TO_ARCHIVE" ]; then
    echo "$DIRECTORY_TO_ARCHIVE is not a directory. Aborting."
    exit 1
fi

REMOTE="${2:-"gdrive"}"
REMOTE_DIRECTORY="${3:-"/98 - archive"}"
BW_FOLDER="${4:-"$REMOTE-archives"}"

if [[ `bw list folders --search "$BW_FOLDER" | jq '.[].id' | wc -l` == 0 ]]; then
    bw get template folder | jq ".name=\"$BW_FOLDER\"" | bw encode | bw create folder
fi

FOLDER_ID="`bw list folders --search "$BW_FOLDER" | jq -r '.[].id' | head -n 1`"

ARCHIVE_PASSWORD="$(bw generate --passphrase --capitalize --includeNumber --words 3)"

OUTPUT_DIRECTORY=`dirname "$DIRECTORY_TO_ARCHIVE"`
OUTPUT_FILE=`basename "$DIRECTORY_TO_ARCHIVE"`
LOGIN_JSON=`bw get template item.login | jq ".totp=\"\" | .username=\"\" | .password=\"$ARCHIVE_PASSWORD\""`
bw get template item | jq ".name=\"$OUTPUT_FILE ($OUTPUT_DIRECTORY)\" | .notes=\"\" | .folderId=\"$FOLDER_ID\" | .login=$LOGIN_JSON" | bw encode | bw create item

TARBALL_FILE="$OUTPUT_DIRECTORY/$OUTPUT_FILE.tar.gz"
tar -vczf "$TARBALL_FILE" "$DIRECTORY_TO_ARCHIVE"
echo "Encrypting..."
echo "$ARCHIVE_PASSWORD" | gpg --batch --yes --symmetric --cipher-algo AES256 --armor --passphrase-fd 0 -o "$TARBALL_FILE.gpg" "$TARBALL_FILE"

echo "Uploading -> $CLOUD..."
rclone copy "$TARBALL_FILE.gpg" "$REMOTE:$REMOTE_DIRECTORY"

echo "Encryption and upload complete. The tarball is encrypted using the password stored in Bitwarden and uploaded to the REMOTE."
