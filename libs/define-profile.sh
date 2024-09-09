#!/bin/bash

# --------------------------------------------------
	# Check and define the profile file for the aliases
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

# Base on the system, we will add the alias to the correct file
function define_profile() {
	if [ "$OS" == "Darwin" ]; then
		if [ "$SHELL" == "bash" ]; then
			PROFILE=~/.bash_profile
		elif [ "$SHELL" == "zsh" ]; then
			PROFILE=~/.zshrc
		fi
	elif [ "$OS" == "Linux" ]; then
		if [ "$SHELL" == "bash" ]; then
			PROFILE=~/.bashrc
		elif [ "$SHELL" == "zsh" ]; then
			PROFILE=~/.zshrc
		fi
	elif [ "$OS" == "Windows_NT" ]; then
		PROFILE=~/.bash_profile
	else
		echo -e "${YELLOW}Unknown system${NC}"
		exit 1
	fi
}

function check_profile() {
	if [ ! -f "$PROFILE" ]; then
		echo -e "${YELLOW}Profile file${NC}${ORANGE} $PROFILE ${NC}${YELLOW}not found${NC}"
		return 1
	fi
}

function check_profile_for_alias() {
	local ORGIGIN_REQUEST=$1

	if grep -q "# GIT COMPANION start" "$PROFILE"; then
		echo -e "${YELLOW}Aliases already added to ${NC}${BLUE}$PROFILE${NC}"
		# what do we do?
		if [ "$ORGIGIN_REQUEST" == "install" ]; then
			source libs/handlers/handle-profile-options.sh
			handle_profile_options install
		else
			source libs/handlers/handle-profile-options.sh
			remove_aliases
		fi
	else 
		# what do we do?
		if [ "$ORGIGIN_REQUEST" == "install" ]; then
			loop_folders bin
		else
			echo -e "${YELLOW}There are no Git Companion aliases in ${NC}${BLUE}$PROFILE${NC}"
			exit 0
		fi
	fi
}

function init() {
	local REQUEST=$1

	define_profile
	check_profile
	check_profile_for_alias $REQUEST
}
