#!/bin/bash

cwd=$(dirname `realpath "$0"`)
bash "$cwd/urls-history.sh" | tail -n1