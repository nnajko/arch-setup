#!/bin/bash

CURRENT_DIR=$(pwd)
REPO_URL="https://github.com/typecraft-dev/dotfiles"
REPO_NAME="dotfiles"

is_stow_installed() {
	pacman -Qi "stow" &> /dev/null
}

is_stow_installed
if [[ $? -ne 0 ]]; then
	echo "stow not installed. Exiting."
	exit 1
fi

cd ~

if [[ -d "${REPO_NAME}" ]]; then
	echo "Repository exists. Skipping clone"
else
	git clone "${REPO_URL}"
fi

if [[ $? -eq 0 ]]; then
	cd "${REPO_NAME}"
	stow zshrc
	stow nvim
	stow starship
else
	echo "Failed to clone repo."
	exit 1
fi
