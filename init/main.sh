#!/bin/sh

CWD=$(realpath "$(dirname "$0")")

"$CWD/install.sh"
"$CWD/init.sh"
