#!/bin/bash

set -e
CWD="$(dirname $(realpath "$0"))"
services_dir="/etc/systemd/system"

for service in `find $CWD -name "*.service"`; do
    service_name="`basename $service`"
    sudo ln -sf "$service" "$services_dir/$service_name"
done