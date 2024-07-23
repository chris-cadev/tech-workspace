#!/bin/bash -e

CWD=$(realpath "$(dirname "$0")")
os_name=$($CWD/commons/get-os-name.sh)

bash $CWD/install.python-dependencies.$os_name.sh