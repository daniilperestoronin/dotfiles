#!/usr/bin/env bash

# Update packages and install snap
apt update
apt install snapd

########################################################
# Install tools
########################################################

apt -y install \
    grep \
    bat \
    fzf \
    findutils \
    dnsutils \
    net-tools \
    netcat

########################################################
# Install programming languages
########################################################

# java, python, go, js
apt -y install \
    openjdk-21-jdk \
    python3 python3-pip \
    golang-go \
    nodejs

# Install rust
curl https://sh.rustup.rs -sSf | sh
export PATH=$PATH:$HOME/.cargo/bin

########################################################
# Install dev tools
########################################################

apt -y install make \
    git \
    protobuf-compiler

# java
apt install maven
snap install gradle --classic

# golang
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    golang.org/x/tools/cmd/goimports@latest \
    github.com/go-delve/delve/cmd/dlv@latest \
    github.com/yoheimuta/protolint/cmd/protolint@latest \
    github.com/fullstorydev/grpcui/cmd/grpcui@latest

# python
pip3 install pylint \
    flake8

# yaml
pip3 install yamllint

# js
npm install yarn

# terminal, code editors
cargo install alacritty
cargo install --locked zellij
snap install helix --classic

apt install code # vsc

########################################################
# Install utils
########################################################
snap install docker

# k8s
snap install minikube
snap install kubectl --classic
snap install helm --classic

go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest

snap install hugo

snap install postman

snap install keepassxc --edge
snap install telegram-desktop --edge

# Install oh-my-zsh
apt -y install zsh
read_cfg bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
wait
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install oh-my-bash
read_cfg bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" &
wait

# Install Nerd Fonts
mkdir -p ~/.fonts/
cd ~/.fonts && curl -fLo "Roboto Mono Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete%20Mono.ttf
fc-cache -fv
