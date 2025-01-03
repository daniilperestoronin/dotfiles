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
    curl \
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
snap install alacritty --classic
snap install zellij --classic
snap install helix --classic

sudo snap install --classic code # vsc
bash vscode/plugin.setup.sh

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
snap install obsidian --classic

# Install oh-my-zsh
apt -y install zsh
bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" 

chsh -s $(which zsh)
