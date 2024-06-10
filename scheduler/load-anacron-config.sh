#!/bin/bash

cwd=$(dirname `realpath "$0"`)
crontab_config=`realpath $cwd/../crontab`

# PAUSED: still deciding if to use anacron or crontab

find $crontab_config -type f -name '*.acron' | xargs cat | sort | uniq | grep -v "#"
