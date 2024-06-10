#!/bin/bash

CWD="$(dirname `realpath "$0"`)"
user=${1:-"`whoami`"}
working_dir=${2:-"$HOME/.play-with-mpv"}
python3_bin_path=${3:-"$(which python3)"}

sudo sed -e "s|User=\$(whoami)|User=$user|" \
-e "s|WorkingDirectory=\$HOME/.play-with-mpv|WorkingDirectory=$working_dir|" \
-e "s|ExecStart=\$(which python3) server.py|ExecStart=$python3_bin_path server.py|" \
-e "s|Environment=DISPLAY=:0|Environment=DISPLAY=$DISPLAY|" \
"$CWD/play-with-mpv.template" > "$CWD/play-with-mpv.service"
