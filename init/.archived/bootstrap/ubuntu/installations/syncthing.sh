#!/bin/bash

sudo apt install curl apt-transport-https
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt update
sudo apt install syncthing

sudo systemctl start syncthing@$USER
sudo systemctl enable syncthing@$USER
