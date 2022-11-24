#!/usr/bin/env bash

########################################################
# Install programming languages
########################################################

sudo pacman -S jdk-openjdkimperator
sudo pacman -S python
sudo pacman -S go

sudo pacman -S nvm
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.zshrc
source ~/.zshrc

nvm install --lts
sudo pacman -S lua
sudo pacman -S rust

sudo pacman -S tmux

sudo pacman -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

########################################################
# Instsll dev tools
########################################################

sudo snap install nvim --classic
sudo snap install alacritty --edge --classic
sudo snap install code --classic

########################################################
# Install utils
########################################################

sudo snap install keepassxc --edge

sudo snap install telegram-desktop --edge
sudo snap install zoom-client --edge
