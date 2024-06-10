#!/bin/bash

CWD=$(dirname `realpath "$0"`)

bash "$CWD/last-played-url.sh" | url-title
