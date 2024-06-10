#!/bin/sh

cwd=$(dirname `realpath "$0"`)

url_title_man_dir="~/.local/share/man/man1"
cp "$cwd/url-title.1" "$url_title_man_dir"
mandb

