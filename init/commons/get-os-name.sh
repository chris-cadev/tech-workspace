#!/bin/bash -e

prefix=""

# Check if the OS is macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "mac"
    exit 0
fi

# Check if the OS is running under WSL
if grep -qi "microsoft" /proc/version; then
    prefix="wsl"
fi

# Check the distribution if it's a Linux system
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
        debian)
            echo "${prefix:+${prefix}-}debian"
            exit 0
            ;;
        ubuntu)
            echo "${prefix:+${prefix}-}ubuntu"
            exit 0
            ;;
        arch)
            echo "${prefix:+${prefix}-}arch"
            exit 0
            ;;
        linuxmint)
            echo "${prefix:+${prefix}-}mint"
            exit 0
            ;;
    esac
fi

# If no known OS is detected, print "unknown"
echo "unknown"
