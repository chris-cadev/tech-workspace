#!/bin/sh

adb shell input keyevent 26 2>&1 >/dev/null | "$CWD/../log.sh" "phone"
