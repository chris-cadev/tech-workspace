#!/bin/sh

CWD=$(dirname `realpath "$0"`)

history=$(sh "$CWD/urls-history.sh" | grep -v "%3A" | grep youtube | grep -E "(shorts|watch)" | uniq)

for url in $history; do
    url=$(echo $url | cut -d"&" -f1)
    echo $url ":" $(url-title "$url" | sed 's/ - YouTube//g' | awk '{print tolower($0)}')
done
