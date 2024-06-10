#!/bin/bash

# Script version
VERSION="1.1.0"

# Function to display usage instructions
function usage {
    echo "Usage: $(basename "$0") [options] <port> [<port> ...]"
    echo "Waits for one or more ports to become available on 0.0.0.0."
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message and exit."
    echo "  --version      Show version information and exit."
}

# Function to display version information
function version {
    echo "wait-for-port version $VERSION"
}

# Function to check if a port is active
function is_port_active {
    nc -z -w5 0.0.0.0 "$1" >/dev/null 2>&1
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            usage
            exit 0
        ;;
        --version)
            version
            exit 0
        ;;
        *)
            break
        ;;
    esac
done

# Check if at least one port argument was provided
if [ $# -lt 1 ]; then
    echo "Usage: $(basename "$0") [options] <port> [<port> ...]"
    exit 1
fi

# Validate the port numbers
for port in "$@"; do
    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
        echo "Error: Port '$port' is not a positive integer."
        exit 1
    fi
done

# Wait for the ports to become available
for port in "$@"; do
    echo "Waiting for port $port to become available..."
    until is_port_active "$port"; do
        sleep 1
    done
done
