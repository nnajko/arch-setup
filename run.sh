#!/bin/bash

clear
echo "Running system setup."

source utils.sh

if [[ ! -f "packages.conf" ]]; then
	echo "packages.conf not found."
	exit 1
fi

source packages.conf

# Update system
sudo pacman -Syu --noconfirm

# Install yay
install_yay

echo "Installing system utilities"
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing dev tools"
install_packages "${DEV_TOOLS[@]}"

echo "Installing fonts"
install_packages "${FONTS[@]}"

echo "Install complete."
