#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew has installed successfully"
else
    echo "Updating Homebrew"
    # Make sure we’re using the latest Homebrew.
    brew update
    # Upgrade any already-installed formulae.
    brew upgrade
fi

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some macOS tools.
brew install grep
brew install openssh

# Install ctag
brew install ctags

# Install fzf, ripgrep and fd
brew install fzf
brew install ripgrep
brew install fd

# Install git
brew install git

# Install terminal things
brew install --cask alacritty
brew install tmux

# Install programming languages
brew install openjdk@11
brew install python@3.10
brew install go@1.17
brew install node@17
brew install lua

brew install cmake
brew install yarn
brew install npm
brew install maven
brew install gradle
brew install luarocks

# Install language tools
# Java
brew install google-java-format
# go
brew install golangci-lint
go install golang.org/x/tools/cmd/goimports@latest
# python
pip3 install pylint
pip3 install flake8
brew install autopep8
#lua
luarocks install luacheck
luarocks install --server=https://luarocks.org/dev luaformatter
# yaml
pip3 install yamllint
#spell
npm install -g cspel

# Install virtualization and cloud things
brew install --cask docker
brew install kubectl
brew install helm
brew install --cask google-cloud-sdk
brew install awscli
# Install lens
brew install --cask lens

# Install API platforms
# Install postman
brew install --cask postman
# Install bloomrpc
brew install --cask bloomrpc

# Install text editors and ide
# Install nvim
brew install neovim
# Install VSC
brew install --cask visual-studio-code
# Install Intellij Idea
brew install --cask intellij-idea

# Install telegram
brew install --cask telegram-desktop
# Install zoom
brew install --cask zoom

# Install chromium
brew install --cask chromium

# Install macpass
brew install --cask macpass

# Plugins plugins

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
wait

git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install Nerd Fonts
brew tap homebrew/cask-fonts
brew install --cask font-roboto-mono-nerd-font

