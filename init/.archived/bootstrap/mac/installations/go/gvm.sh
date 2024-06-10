#!/bin/bash

bash $(dirname $0)/gvm-deps.sh
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
bash $HOME/.gvm/extra/vagrant/install-deps.sh
