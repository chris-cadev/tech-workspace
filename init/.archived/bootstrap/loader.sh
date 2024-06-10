#!/bin/bash

CWD=$(dirname $(realpath "$0"))
OS=`bash "$CWD/../scripts/os.sh"`
set -e

case "$OS" in
    "Arch")
    ;;
    "Mac")
        # echo "INSTALLING ----------------------------------------------------------------"
        # bash "$CWD/install.mac.sh"
        echo "CONFIGURING ---------------------------------------------------------------"
        bash "$CWD/configure.mac.sh"
    ;;
    "Ubuntu")
    ;;
    "Unknown")
    ;;
esac