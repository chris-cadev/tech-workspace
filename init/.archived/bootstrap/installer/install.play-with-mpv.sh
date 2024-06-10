#!/bin/sh

git clone git@github.com:chris-cadev/play-with-mpv.git ~/.play-with-mpv
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod u+x /usr/local/bin/yt-dlp