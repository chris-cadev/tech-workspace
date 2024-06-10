#!/bin/bash

cwd=$(dirname `realpath "$0"`)
download_fonts_dir="$cwd/../temp/fonts"

# Fira code
sudo add-apt-repository universe
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
sudo apt update
sudo apt install fonts-firacode

# Comic mono
cd "$download_fonts_dir"
curl https://dtinth.github.io/comic-mono-font/ComicMono.ttf -o "comic-mono-font.ttf"
sudo mkdir "/usr/share/fonts/truetype/comicmono"
sudo mv "comic-mono-font.ttf" "/usr/share/fonts/truetype/comicmono"

# reload fonts
sudo fc-cache -f -v

