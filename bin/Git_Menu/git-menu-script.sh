#!/bin/bash

# chmod +x git-menu-script.sh
# chmod -x git-menu-script.sh
# aliases as install-dev

# --------------------------------------------------
	# Git Companion main menu
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-26
# --------------------------------------------------

ALIAS="gmenu"
ESCAPE_PATH=$(echo $(pwd) | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')


# Function to access the main menu
function_access_menu() {
	# We print the header of the main menu
	echo "Welcome to Git Companion!"
	bash $ESCAPE_PATH/bin/Git_Help/git-help-script.sh
	echo ""
	echo "Get started by choosing an option below:"
	echo ""
	echo "1) Git User # Set up your user informations"
	echo "2) Git Init # Initialize a new repository"
	echo "3) Git Branch # Create a new branch"
	echo "4) Git Commit # Commit your changes"
	echo "5) Git Log # View the commit history"
	echo "6) Git Config # Configure your Git"
	echo "7) Git Help # Get help with Git Companion"

	# Prompt for user input
	read -p "Enter the number corresponding to the option: " choice

	# Case statement to handle user input. We launch the corresponding script based on the user's choice 
	case $choice in
		1) bash guser ;;
		2) bash $ESCAPE_PATH/bin/Git_Init/git-init-script.sh ;;
		3) bash $ESCAPE_PATH/bin/Git_Branch/git-branch-script.sh ;;
		4) bash $ESCAPE_PATH/bin/Git_Commit/git-commit-script.sh ;;
		5) bash $ESCAPE_PATH/bin/Git_Log/git-log-script.sh ;;
		6) bash $ESCAPE_PATH/bin/Git_Config/git-config-script.sh ;;
		7) bash $ESCAPE_PATH/bin/Git_Help/git-help-script.sh ;;
		*) echo "Invalid option. Please try again." ;;
	esac
}

init() {
	function_access_menu
}

init