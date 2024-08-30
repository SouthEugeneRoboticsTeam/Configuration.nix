#! /usr/bin/env sh

sudo mv /etc/nixos/configuration.nix /etc/nixos/backup-conf.nix

sudo mv * /etc/nixos/

mkdir ~/.config/i3blocks/

cd ~/.config/i3blocks/

git clone https://github.com/vivien/i3blocks-contrib.git

sudo nixos-rebuild switch --flake /etc/nixos#sert

cd i3blocks-contrib

make all

reboot
