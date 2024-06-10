#!/bin/bash


CWD=$(dirname $(realpath "$0"))
export $(cat "$CWD/.env" | xargs)

adb tcpip $SCRCPY_TCP_PORT
adb connect $PHONE_IP:$SCRCPY_TCP_PORT
