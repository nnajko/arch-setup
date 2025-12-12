#!/bin/bash

YAY_EXISTS=$(command -v yay)
REPO_NAME="yay"
CURRENT_DIR=$(pwd)

is_git_installed() {
	pacman -Qi "git" &> /dev/null
}

is_base_devel_installed() {
	pacman -Qi "base-devel" &> /dev/null
}

install_yay() {
	if [[ ${YAY_EXISTS} ]]; then
		echo "yay is already installed. Skipping."
	else
		if [[ -d $REPO_NAME ]]; then
			echo "yay repository already exists. Skipping clone."
		else
			is_git_installed
			if [[ $? -ne 0 ]]; then
				echo "Installing git"
				sudo pacman -S --noconfirm git
			else
				echo "git installed. Skipping."
			fi

			git clone https://aur.archlinux.org/yay.git
			if [[ $? -ne 0 ]]; then
				echo "Failed to clone repository."
				exit 1
			fi
		fi

		is_base_devel_installed
		if [[ $? -ne 0 ]]; then
			echo "Installing base-devel"
			sudo pacman -S --noconfirm base-devel
		else
			echo "base-devel installed. Skipping."
		fi

		cd yay
		makepkg -si --noconfirm
		cd ${CURRENT_DIR}
		rm -rf yay

		echo "Done. yay installed."
	fi
}

is_installed() {
	pacman -Qi "${1}" &> /dev/null
}

is_group_installed() {
	pacman -Qg "${1}" &> /dev/null
}

install_packages() {
	local packages=("$@")
	local to_install=()

	for pkg in "${packages[@]}"; do
		is_installed "$pkg"
		if [[ $? -ne 0 ]]; then 
			is_group_installed "$pkg"
			if [[ $? -ne 0 ]]; then
				to_install+=("$pkg")
				echo "Adding ${pkg}"
			else
				echo "Skipping ${pkg}"
			fi
		else
			echo "Skipping ${pkg}"
		fi
	done

	echo "${to_install[@]}"
	if [[ ${#to_install[@]} -ne 0 ]]; then
		echo "Installing: ${to_install[*]}"
		yay -S --noconfirm "${to_install[@]}"
	fi
}

apply_zsh() {
	local ZSH_DIR=$(command -v /usr/bin/zsh)
	if [[ -z ${ZSH_DIR} ]]; then
		echo "zsh not installed. Skipping."
	else
		local USER=$(echo $USER)
		local DEFAULT_SHELL=$(getent passwd ${USER} | awk -F: '{print $NF}')
		if [[ ${ZSH_DIR} = ${DEFAULT_SHELL} ]]; then
			echo "zsh already applied. Skipping."
		else
			chsh -s ${ZSH_DIR}
			echo "zsh applied. Logout to see effect."
		fi
	fi
}
