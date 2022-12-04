#!/usr/bin/env bash

# Update packages
apt update

########################################################
# Install programming languages
########################################################

apt -y install openjdk-17-jdk \
    maven \
    python3 python3-pip\
    golang-go \
    lua5.3

snap install gradle --classic

snap install node --channel=19/stable --classic
npm install --global yarn

curl https://sh.rustup.rs -sSf | sh
export PATH=$PATH:$HOME/.cargo/bin

########################################################
# Instsll dev tools
########################################################

apt -y install make \
    git \
    tmux \
    findutils \
    grep \
    bat \
    fzf \
    protobuf-compiler \
    universal-ctags

cargo install alacritty

snap install --beta nvim --classic
snap install codium --classic

go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.50.1
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/yoheimuta/protolint/cmd/protolint@latest
go install github.com/fullstorydev/grpcui/cmd/grpcui@latest

pip3 install pylint
pip3 install flake8

pip3 install yamllint
########################################################
# Install utils
########################################################
snap install docker

snap install hugo

snap install kontena-lens --classic
snap install postman

snap install keepassxc --edge

snap install telegram-desktop --edge
snap install zoom-client --edge

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