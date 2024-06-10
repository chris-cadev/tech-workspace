#!/bin/bash

journalctl --unit=play-with-mpv.service | grep play_url | awk -F "play_url=" '{print $2}' | awk '{print $1}' | uniq