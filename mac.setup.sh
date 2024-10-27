#!/usr/bin/env bash

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew has installed successfully"
else
    echo "Updating Homebrew"
    # Make sure we’re using the latest Homebrew.
    brew update
    # Upgrade any already-installed formulae.
    brew upgrade
fi

# Save Homebrew’s installed		--exclude "mac.setup.sh" \ location.
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

# Install ctag
brew install ctags

# Install fzf, ripgrep and fd
brew install fzf
brew install ripgrep
brew install fd

# Install utils
brew install bat

# Install git
brew install git

# Install terminal things
brew install --cask alacritty
brew install zellij
brew install yazi

# Install programming languages
brew install openjdk
brew install python
brew install go
brew install node
brew install lua

brew install cmake
brew install yarn
brew install npm
brew install maven
brew install gradle
brew install luarocks
brew install protobuf

# Install language tools
# Java
brew install google-java-format
# go
brew install golangci-lint
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
# python
pip3 install pylint
pip3 install flake8
brew install autopep8
# lua
luarocks install luacheck
luarocks install --server=https://luarocks.org/dev luaformatter
# yaml
pip3 install yamllint
# spell
npm install -g cspel
# protobuf
brew tap yoheimuta/protolint
brew install protolint

# Install static site generators
brew install hugo

# Install virtualization and cloud things
brew install kubectl
brew install helm

# Install lens
brew install --cask lens

# Install API platforms
# Install postman
brew install --cask postman
# Install grpcurl
brew install grpcurl

# Install text editors and ide
# Install helix
brew install helix
# Install nvim
brew install neovim
# Install VSC
brew install --cask visual-studio-code
# Install Idea CE
brew install --cask intellij-idea-ce

# Install telegram
brew install --cask telegram-desktop

# Install chromium
brew install --cask chromium
# Install firefox
brew install --cask firefox

# Install macpass
brew install --cask macpass

# Plugins plugins

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &
wait
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Install oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
brew install bash-completion
echo "[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion" >>~/.bash_profile

# Install Nerd Fonts
brew tap homebrew/cask-fonts
brew install --cask font-roboto-mono-nerd-font

# Use zsh by default
chsh -s /bin/zsh

read -p "Are you what to update macOS settings? (y/n)" -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sh .macos
fi
