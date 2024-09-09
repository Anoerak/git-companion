#!/bin/bash

# --------------------------------------------------
	# Handle the profile options
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

function remove_aliases() {
	local INSTALL_FLAG=$1

	PROFILE_DRAFT=$(mktemp)
	{
		sed -e '/# GIT COMPANION start/,/# GIT COMPANION end/d' -e '/^$/d' "$PROFILE"
	} >>"$PROFILE_DRAFT"
	cat "$PROFILE_DRAFT" >"$PROFILE"
	rm -f "$PROFILE_DRAFT"
	echo -e "${GREEN}Aliases successfully removed from${NC}${CYAN} $PROFILE${NC}"
	if [ "$INSTALL_FLAG" == "install" ]; then
		loop_folders bin
	else
		echo -e "${YELLOW}Thank you for using the Git Companion${NC}"
		exit 0
	fi
}

function handle_profile_options() {
	local INSTALL_FLAG=$1

	echo -e "${YELLOW}Do you want to remove the aliases from ${NC}${BLUE}$PROFILE${NC}${YELLOW}? [y/n]${NC}"
	read -r REMOVE_ALIASES
	if [ "$REMOVE_ALIASES" == "y" ]; then
		remove_aliases $INSTALL_FLAG
	elif [ "$REMOVE_ALIASES" == "n" ]; then
		echo -e "${ORANGE}Aliases will not be removed from ${NC}${BLUE}$PROFILE${NC}"
		echo -e "${YELLOW}Do you want to add the new aliases? [y/n]${NC}"
		read -r ADD_ALIASES
		if [ "$ADD_ALIASES" == "y" ]; then
			# We pass to the next step
			loop_folders bin
		elif [ "$ADD_ALIASES" == "n" ]; then
			echo -e "${YELLOW}Aliases will not be added to ${NC}${BLUE}$PROFILE${NC}"
			exit 0
		else
			echo -e "${ORANGE}Invalid option${NC}"
			handle_profile_options
		fi
	else
		echo -e "${ORANGE}Invalid option${NC}"
		handle_profile_options
	fi
}
