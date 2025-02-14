#!/bin/bash -e

CWD=$(dirname $(realpath "$0"))
REPO_COPIES_DIR="$CWD/../.cache/repo-cloud-archive"
DIR_TO_ARCHIVE="$(realpath "${1:-"."}")"

repo_name="$(basename "$DIR_TO_ARCHIVE")"

if ! [ -d "$DIR_TO_ARCHIVE/.git" ]; then
    echo "Seems like is not a git repository"
    exit 0
fi

if [[ ! "$DIR_TO_ARCHIVE" == */ ]]; then
    DIR_TO_ARCHIVE="$DIR_TO_ARCHIVE/"
fi

repo_copy_path="$REPO_COPIES_DIR/$repo_name"

mkdir -p "$repo_copy_path"
# TODO: improve the way to copy the source code of the repository
rsync -aP --exclude 'node_modules' $exclusions "$DIR_TO_ARCHIVE" "$repo_copy_path"
git -C "$repo_copy_path" clean -fdX
echo "Removing .git"
rm -rf "$repo_copy_path/.git"

echo "Creating encrypted backup"
"$CWD/cloud-archive.sh" "$repo_copy_path"

echo "repo copy ~/.dotfiles/.cache/... cleanup"
rm -rf "$repo_copy_path"
rm "$REPO_COPIES_DIR/$repo_name".*

