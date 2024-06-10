#!/usr/bin/env bash

CWD=$(dirname $(realpath "$0"))
cat $CWD/reboot.cron | sudo crontab -