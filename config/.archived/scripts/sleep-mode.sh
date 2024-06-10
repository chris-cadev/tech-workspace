#!/bin/bash

if [[ -z "$1" ]]; then
    exit 1
fi

if [[ "enable" = "$1" ]]; then
    mode="unmask"
fi

if [[ "disable" = "$1" ]]; then
    mode="mask"
fi

if [[ -z "$mode" ]]; then
    exit 1
fi

sudo systemctl $mode sleep.target suspend.target hibernate.target hybrid-sleep.target
