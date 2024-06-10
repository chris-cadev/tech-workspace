#!/bin/bash

arg_date=${1:-$(date +%Y-%m-%d)}
weeks_prev=${2:-1}

# Get the day of the week (1-7) from the specified date
weekday=$(date -d "$(date +%Y-%m-%d)" +%u)

# Check if the specified day is Monday
if [ $weekday -eq 1 ]; then
    previous_monday=$(date -d "$arg_date" +'%Y-%m-%d')
else
    previous_monday=$(date -d "$arg_date - $(( $weekday * $weeks_prev - 1 )) days" +'%Y-%m-%d')
fi

# Print the date of the previous Monday
echo "$previous_monday"
