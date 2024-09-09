#!/bin/bash

# --------------------------------------------------
	# Check permissions for the script
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

function check_permissions() {
	local script=$1
	
	if [ ! -x $script ]; then
		echo -e "${ORANGE}The script ${NC}${BLUE}$script ${NC}${ORANGE}is not authorized to run.${NC}"
		echo -e "${YELLOW}Do you want to change the permissions?${NC}"
		read -t 30 -p "$(echo -e "${YELLOW}Enter 'yes' or 'no': ${NC} ")" answer
		if [ "$answer" == "yes" ]; then
			chmod +x $script
			echo -e "${GREEN}The permissions have been changed.${NC}"
			read -t 30 -p "$(echo -e "${YELLOW}Do you want to run the script now? Enter 'yes' or 'no': ${NC} ")" answer
			if [ "$answer" == "yes" ]; then
				./$script
			else
				echo -e "${ORANGE}The script has not been run.${NC}"
				exit 1
			fi
		else
			echo -e "${ORANGE}The permissions have not been changed.${NC}"
			exit 1
		fi
	else 
		echo -e "${GREEN}Executing the script ${NC}${BLUE}$script.${NC}"
		./$script
	fi
}
