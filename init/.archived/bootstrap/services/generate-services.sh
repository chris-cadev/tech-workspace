#!/bin/bash

CWD="$(dirname `realpath "$0"`)"

for generator_script in `find $CWD -name "generator.*.replacement.service"`; do
    bash "$CWD/$generator_script"
done