#!/bin/bash

BASE_REPO=$1
REPOS_LIST=$2

while IFS= read -r repo_uri; do
    username=$(basename $(dirname "$repo_uri"))
    repository=$(basename -s .git "$repo_uri")
    directory="$WORK_BASE/$username/$repository"
    mkdir -p "$directory"
    git clone "$repo_uri" "$directory"
done < "$REPOS_LIST"
