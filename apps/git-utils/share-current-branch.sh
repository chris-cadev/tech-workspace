#!/bin/bash

set -e

# Start git daemon
echo "Starting git daemon..."
git daemon --export-all --reuseaddr --base-path=. &

# Start ngrok port forwarding
echo "Starting ngrok port forwarding..."
ngrok_port=$(git daemon --print-port | awk -F':' '{print $2}')
ngrok http $ngrok_port &

# Wait for ngrok to initialize
sleep 5

# Get ngrok URL
ngrok_url=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

# Show command to clone the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
clone_command="git clone $ngrok_url $current_branch"
echo "Clone command: $clone_command"

# Wait for user to terminate
echo "Press Ctrl + C to close the git daemon and ngrok."
trap 'kill $(jobs -p)' SIGINT
wait

