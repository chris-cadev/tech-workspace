#!/bin/bash

cwd=$(dirname `realpath "$0"`)

bash "$cwd/bun/deps.sh"

curl https://bun.sh/install | bash
