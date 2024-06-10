#!/bin/bash

set -e
CWD="$(dirname $(realpath "$0"))"

for service in `find "$CWD" -name "*.service"`; do
    service_name="`basename $service`"
    sudo systemctl start "$service_name"
    sudo systemctl enable "$service_name"
done
