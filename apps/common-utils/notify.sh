#!/bin/bash

# Store the command and its arguments in a variable
command="$@"

# Execute the command and store the exit status
$command
exit_status=$?

# Send a notification using notify-send
if [ $exit_status -eq 0 ]; then
    notify-send "Command succeeded: $command"
else
    notify-send "Command failed: $command"
fi
