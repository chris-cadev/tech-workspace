#!/bin/bash

# reference: https://github.com/ericchiang/pup

latest_version_installed=`gvm list | grep go1. | awk -F "=> " '{print $2}' | xargs`
gvm use "$latest_version_installed"

go install github.com/ericchiang/pup@latest
