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

# ANSI color codes
source libs/color-codes.sh

# Function to set up the user informations
function_set_user() {
	echo -e "${YELLOW}Setting up your user informations...${NC}"
	read -p "$(echo -e "${YELLOW}Enter your name: ${NC}")" name
	read -p "$(echo -e "${YELLOW}}Enter your email: ${NC}")" email

	git config --global user.name "$name"
	git config --global user.email "$email"

	echo -e "${GREEN}User informations set up successfully.${NC}"
}

function_get_user() {
	echo -e "${YELLOW}Name=> ${NC}${BLUE}$(git config --global user.name)${NC}"
	echo -e "${YELLOW}Email=> ${NC}${BLUE}$(git config --global user.email)${NC}"
}

function_check_user() {
	if [ -z "$(git config --global user.name)" ] || [ -z "$(git config --global user.email)" ]; then
		echo -e "${ORANGE}User informations not set up.${NC}"
		function_set_user
	else
		echo -e "${YELLOW}User informations already set up.${NC}"
		function_get_user

		read -p "$(echo -e "${YELLOW}Do you want to modify the user informations? (y/n): ${NC}")" choice
		if [ "$choice" = "y" ]; then
			function_set_user
		else
			echo -e "${GREEN}Thank you.${NC}"
		fi
	fi
}

init() {
	function_check_user
}

init
