#!/bin/bash

CWD=$(dirname `realpath "$0"`)
url=`bash "$CWD/last-played-url.sh"`

curl --silent "http://localhost:7531/?play_url=$url"