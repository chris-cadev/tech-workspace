#!/bin/bash

cwd=$(dirname `realpath "$0"`)

sudo cat "$cwd/syncthing.service" > /etc/systemd/system/syncthing@.service
sudo vim /etc/systemd/system/syncthing@.service
