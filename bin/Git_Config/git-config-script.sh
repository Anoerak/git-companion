#!/bin/bash

# chmod +x git-user-script.sh
# chmod -x git-user-script.sh
# aliases as gconfig

# --------------------------------------------------
	# Git User - Set up your user informations
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-12
# --------------------------------------------------

ALIAS="gconfig"

# Function to set up your .gitconfig, .gitignore, .git-branch-config, .git-commit-config or .gitattributes
function_set_config() {
	echo "Setting up your Git configuration..."
	echo "Which configuration file do you want to set up?"
	echo "1) .gitconfig"
	echo "2) .gitignore"
	echo "3) .git-branch-config"
	echo "4) .git-commit-config"
	echo "5) .gitattributes"
	read -p "Enter the number corresponding to the configuration file: " choice
	case $choice in
		1) read -p "Enter your name: " name
			read -p "Enter your email: " email
			git config --global user.name "$name"
			git config --global user.email "$email" ;;
		2) read -p "Enter the files you want to ignore using a space between each file or type 'template' to use a template: " files
			if [ "$files" = "template" ]; then
				curl -o .gitignore https://www.toptal.com/developers/gitignore/api/templates
			else
				for file in $files; do
					echo "$file" >> .gitignore
				done
			fi ;;
		3) read -p "Enter the branch you want to set up: " branch
			git branch --set-upstream-to=origin/"$branch" "$branch" ;;
		4) read -p "Enter the commit message you want to set up: " message
			git config --global commit.template "$message" ;;
		5) read -p "Enter the attributes you want to set up using a space between each attribute: " attributes
			for attribute in $attributes; do
				echo "$attribute" >> .gitattributes
			done ;;
		*) echo "Invalid option. Please try again." ;;
	esac
	echo "Git configuration set up successfully."
}
