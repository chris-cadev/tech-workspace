#!/bin/bash

curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
sudo rm -f ./keybase_amd64.deb
