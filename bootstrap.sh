#!/usr/bin/env bash

if command -v git &> /dev/null
then
    git pull origin main
fi


function doIt() {
	rsync --exclude ".git/" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "setup.sh" \
		--exclude "README.md" \
		-avh --no-perms . ~;
}

read -p "Are you what to start components setup? (y/n)" -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sh setup.sh
fi

read -p "Are you whant to copy dotfiles in your home directory(This may overwrite existing files)? (y/n)" -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	doIt;
fi
