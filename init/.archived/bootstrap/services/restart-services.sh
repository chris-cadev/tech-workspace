#!/bin/bash

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    restart_command="systemctl restart"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    restart_command="launchctl kickstart -k system"
else
    echo "Unsupported operating system"
    exit 1
fi

for service_path in `find $CWD -name "*.service"`; do
    service_name=`basename $service_path`
    $restart_command $service_name
done
