#!/bin/sh

CWD=$(dirname `realpath "$0"`)
scrcpy 2>&1 >/dev/null | "$CWD/../log.sh" "phone"
