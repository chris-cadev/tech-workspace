#!/bin/bash

# Check if the OS is Arch Linux
if [ -f /etc/arch-release ]; then
    echo "Arch"
# Check if the OS is macOS
elif [ "$(uname)" == "Darwin" ]; then
    echo "Mac"
# Check if the OS is Ubuntu
elif [ -f /etc/lsb-release ] || [ -f /etc/os-release ] && grep -i ubuntu /etc/*-release >/dev/null 2>&1; then
    echo "Ubuntu"
# If the OS is not recognized, echo "Unknown"
else
    echo "Unknown"
fi
