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

# Install git
brew install git

brew install --cask alacritty
brew install tmux

brew install openjdk@11
brew install python@3.9
brew install go@1.16
brew install node@17

brew install --cask docker
brew install kubectl
brew install helm
brew install --cask google-cloud-sdk
brew install awscli

brew install yarn
brew install npm

# Install nvim
brew install neovim
# Install VSC
brew install --cask visual-studio-code
# Install Intellij Idea
brew install --cask intellij-idea

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/themes}/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

