#!/bin/bash

cwd=$(dirname `realpath "$0"`)
crontab_config=`realpath $cwd/../crontab`

find $crontab_config -type f -name '*.cron' | xargs cat | sort | uniq | grep -v "#" | crontab -
