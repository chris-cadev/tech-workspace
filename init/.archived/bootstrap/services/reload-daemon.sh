#!/bin/bash

set -e

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    daemon_reload_command="systemctl daemon-reload"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # MacOS
    daemon_reload_command="launchctl unload /Library/LaunchDaemons/com.apple.launchd.peruser.501.plist && launchctl load /Library/LaunchDaemons/com.apple.launchd.peruser.501.plist"
else
    echo "Unsupported operating system"
    exit 1
fi

$daemon_reload_command
