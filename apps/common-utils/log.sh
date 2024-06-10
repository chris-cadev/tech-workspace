#!/bin/bash

CWD=$(dirname `realpath "$0"`)
log_service="$1"
log_file="$CWD/../.logs/$log_service.log"
shift

logs_dir=`dirname "$log_file"`
if [[ ! -d "$logs_dir" ]]; then
    mkdir "$logs_dir"
fi

if [ -t 0 ]; then
    # No input piped to the script, assume log message is passed as an argument
    log_date=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$log_date] - $log_service :: $@" >> "$log_file"
else
    # Input piped to the script, assume each line of input is a log message
    while read -r line; do
        log_date=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$log_date] - $log_service :: $line" >> "$log_file"
    done
fi
