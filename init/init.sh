#!/bin/bash -e

CWD=$(realpath "$(dirname "$0")")

initializers="$CWD/init.*.sh"
for initializer in $initializers; do
  "$initializer"
done
