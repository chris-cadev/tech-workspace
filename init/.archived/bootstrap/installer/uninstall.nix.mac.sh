#!/bin/bash

sudo rm -rf /nix/
sudo rm -rf /Volumes/Nix\ Store/*
sudo rm -rf /etc/nix
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
rm -rf ~/.nix-channels ~/.nix-defexpr ~/.nix-profile