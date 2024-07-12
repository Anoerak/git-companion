#!/bin/bash

# chmod +x git-user-script.sh
# chmod -x git-user-script.sh
# aliases as guser

# --------------------------------------------------
	# Git User - Set up your user informations
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-12
# --------------------------------------------------

ALIAS="guser"

# Function to set up the user informations
function_set_user() {
	echo "Setting up your user informations..."
	read -p "Enter your name: " name
	read -p "Enter your email: " email

	git config --global user.name "$name"
	git config --global user.email "$email"

	echo "User informations set up successfully."
}

function_get_user() {
	echo "Name=> $(git config --global user.name)"
	echo "Email=> $(git config --global user.email)"
}

function_check_user() {
	if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
		echo "User informations not set up."
		function_set_user
	else
		echo "User informations already set up."
		function_get_user

		read -p "Do you want to modify the user informations? (y/n): " choice
		if [ "$choice" = "y" ]; then
			function_set_user
		else
			echo "Thank you."
		fi
	fi
}

init() {
	function_check_user
}

init
