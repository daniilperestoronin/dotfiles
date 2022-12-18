#!/usr/bin/env bash

if command -v git &>/dev/null; then
	git pull origin main
fi

read -p "Are you what to start components setup? (y/n)" -n 1
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		sudo bash linux.setup.sh
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		bash mac.setup.sh
	else
		echo "SETUP ERROR: unknown system type"
	fi
fi

read -p "Are you whant to copy dotfiles in your home directory(This may overwrite existing files)? (y/n)" -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	cp -a ./.config .bashrc .zshrc .tmux.conf ~

	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		cp ./vscode/settings.json $HOME/.config/Code/User/
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		cp ./vscode/settings.json $HOME/Library/Application\ Support/Code/User/
	else
		echo "COPY VSCODE SETTINGS ERROR: unknown system type"
	fi
fi
