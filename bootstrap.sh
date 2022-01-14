#!/usr/bin/env bash
git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
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

read -p "Are you what to update macOS settings? (y/n)" -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sh .macos
fi
