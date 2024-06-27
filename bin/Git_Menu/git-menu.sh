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

# Define the ASCII logo
LOGO=$(cat <<'EOF'
#   _______ _       _______                              _             
#  (_______|_)  _  (_______)                            (_)            
#   _   ___ _ _| |_ _       ___  ____  ____  _____ ____  _  ___  ____  
#  | | (_  | (_   _) |     / _ \|    \|  _ \(____ |  _ \| |/ _ \|  _ \ 
#  | |___) | | | |_| |____| |_| | | | | |_| / ___ | | | | | |_| | | | |
#   \_____/|_|  \__)\______)___/|_|_|_|  __/\_____|_| |_|_|\___/|_| |_|
#                                     |_|                              
EOF
)

# Function the print the header
function_print_header() {
	echo "******************************************"
	echo "*                                        *"
	echo "*      Welcome to GitCompanion!          *"
	echo "*   Your friendly assistant for GIT.     *"
	echo "*                                        *"
	echo "******************************************"
	echo ""
	echo "$LOGO"
	echo ""
}


# Function to access the main menu
function_access_menu() {
	# Welcome message
	echo "******************************************"
	echo "*                                        *"
	echo "*      Welcome to GitCompanion!          *"
	echo "*   Your friendly assistant for GIT.     *"
	echo "*                                        *"
	echo "******************************************"
	echo ""
	echo "$LOGO"
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

	# Case statement to handle user input
	case $choice in
	1) echo "You chose option 1" ;;
	2) echo "You chose option 2" ;;
	3) echo "You chose option 3" ;;
	4) echo "You chose option 4" ;;
	5) echo "You chose option 5" ;;
	6) echo "You chose option 6" ;;
	7) echo "You chose option 7" ;;
	esac
}	