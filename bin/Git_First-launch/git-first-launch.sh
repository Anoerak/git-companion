#!/bin/bash

# chmod +x git-first-launch.sh
# chmod -x git-first-launch.sh
# aliases as gfirst-launch

# --------------------------------------------------
	# Git Companion first launch script
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-27
# --------------------------------------------------

ALIAS="gfirst-launch"

# ANSI color codes
source libs/color-codes.sh

# Variables
ESCAPE_PATH=$(echo $(pwd) | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
cd ".." || exit
FIRST_LAUNCH_MESSAGE="Welcome to Git Companion! This is your first time launching the script. Let's get started by setting up your user information."

# Function to access the first launch menu
function_access_first_launch() {
	# We print the header of the first launch menu
	echo -e "${YELLOW}Welcome to Git Companion!${NC}"
	echo ""
	echo -e "${YELLOW}Get started by setting up your user information:${NC}"
	echo ""
	echo -e "${GREEN}1)${NC} ${CYAN}Set User Information ${YELLOW}(guser)${NC} # Set up your user informations${NC}"
	echo -e "${GREEN}2)${NC} ${CYAN}Skip ${YELLOW}(skip)${NC} # Skip setting up user information${NC}"

	# Prompt for user input
	read -p "$(echo -e "${YELLOW}Enter the number corresponding to the option:  ${NC}")" choice

	# Case statement to handle user input. We launch the corresponding script based on the user's choice 
	case $choice in
		1) bash "$ESCAPE_PATH/bin/Git_User/git-user-script.sh" ;;
		2) echo -e "${YELLOW}Skipping user information setup.${NC}" ;;
		*) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
	esac
	

	# We then launch the gmenu script with some extra information
	echo -e "${YELLOW}Launching the Git Companion menu.${NC}"
	echo -e "${YELLOW}You can access this menu at any time by typing ${CYAN}gmenu${NC}"
	echo -e "${YELLOW}This menu will allow you to access all the features of the Git Companion.${NC}"
	cd ".." || exit

	bash "$ESCAPE_PATH/bin/Git_Menu/git-menu.sh"
}

init() {
	echo -e "${FIRST_LAUNCH_MESSAGE}"
	function_access_first_launch
}

init
