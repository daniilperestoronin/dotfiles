#!/usr/bin/env bash
git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude "bootstrap.sh" \
        --exclude "setup.sh" \
		--exclude "README.md" \
		-avh --no-perms . ~;
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
	doIt;
fi