#!/bin/bash

# chmod +x git-init-script.sh
# chmod -x git-init-script.sh
# aliases as ginit

# --------------------------------------------------
	# Git Init - Initialize a new repository
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-12
# --------------------------------------------------

ALIAS="ginit"

# Function to initialize a new repository
function_init_repo() {
	echo "Initializing a new repository..."
	git init
	echo "Repository initialized successfully."
	read -p "Do you want to add a remote repository? (y/n): " choice
	if [ "$choice" = "y" ]; then
		read -p "Enter the remote repository URL: " url
		git remote add origin "$url"
		echo "Remote repository added successfully."
		read -p "Do you want to rename the main branch? (y/n): " choice
		if [ "$choice" = "y" ]; then
			read -p "Enter the new branch name: " branch
			git checkout -b "$branch"
			echo "Main branch renamed successfully."
		else
			echo "No branch renamed."
		fi
	else
		echo "No remote repository added."
	fi
}

# Function to get the repository informations
function_get_repo() {
	echo "Name=> $(git config --get remote.origin.url)"
	echo "Branch=> $(git branch --show-current)"
	echo "User=> $(git config --get user.name)"
	echo "Email=> $(git config --get user.email)"
}

# Function to modify an existing repository informations
function_modify_repo() {
	echo "Here are the current repository informations:"
	echo "Name=> $(git config --get remote.origin.url)"
	echo "Branch=> $(git branch --show-current)"
	echo "User=> $(git config --get user.name)"
	echo "Email=> $(git config --get user.email)"
	echo ""
	read -p "Do you want to modify the repository informations? (y/n): " choice
	if [ "$choice" = "y" ]; then
		echo "Which information do you want to modify?"
		echo "1) Repository name"
		echo "2) Branch"
		echo "3) User"
		echo "4) Email"
		read -p "Enter the number(s) corresponding to the information(s) you want to modify using a space between each number: " choices
		for choice in $choices; do
			case $choice in
				1) read -p "Enter the new repository name: " name
					git remote set-url origin "$name" ;;
				2) read -p "Enter the new branch: " branch
					git checkout -b "$branch" ;;
				3) read -p "Enter the new user: " user
					git config --global user.name "$user" ;;
				4) read -p "Enter the new email: " email
					git config --global user.email "$email" ;;
				*) echo "Invalid option. Please try again." ;;
			esac
		done
		echo "Repository informations modified successfully."
	else
		echo "No modification made."
	fi
}

init() {
	echo "Welcome to Git Init!"
	echo ""
	echo "What do you want to do?"
	echo "1) Initialize a new repository"
	echo "2) Get the repository informations"
	echo "3) Modify the repository informations"
	read -p "Enter the number corresponding to the option: " choice
	case $choice in
		1) function_init_repo ;;
		2) function_get_repo ;;
		3) function_modify_repo ;;
		*) echo "Invalid option. Please try again." ;;
	esac
}

init
