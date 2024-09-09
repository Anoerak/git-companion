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

# ANSI color codes
if [ -f "/usr/local/bin/git_companion/color-codes.sh" ]; then
	source /usr/local/bin/git_companion/color-codes.sh
else
	echo "pwd: $(pwd)"
	source ./bin/color-codes.sh
fi

# Variables
# We want the path but before the /bin/Git_Menu/git-menu-script.sh
# We remove the /bin/Git_Menu/git-menu-script.sh
# ESCAPE_PATH=$(echo $(pwd) | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
# ESCAPE_PATH=$(echo $ESCAPE_PATH | sed 's/\/bin\/Git_Menu\/git-menu-script.sh//g')




# Function to access the main menu
function access_menu() {
	# We print the header of the main menu
	echo -e "${YELLOW}Welcome to Git Companion!${NC}"
	echo ""
	echo -e "${YELLOW}Get started by choosing an option below:${NC}"
	echo ""
	echo -e "${GREEN}1)${NC} ${CYAN}Git User ${YELLOW}(guser)${NC} # Set up your user informations${NC}"
	echo -e "${GREEN}2)${NC} ${CYAN}Git Init ${YELLOW}(ginit)${NC} # Initialize a new repository${NC}"
	echo -e "${GREEN}3)${NC} ${CYAN}Git Branch ${YELLOW}(gbranch)${NC} # Create a new branch${NC}"
	echo -e "${GREEN}4)${NC} ${CYAN}Git Commit ${YELLOW}(gcommit)${NC} # Commit your changes${NC}"
	echo -e "${GREEN}5)${NC} ${CYAN}Git Log ${YELLOW}(glog)${NC} # View the commit history${NC}"
	echo -e "${GREEN}6)${NC} ${CYAN}Git Config ${YELLOW}(gconfig)${NC} # Configure your Git${NC}"
	echo -e "${GREEN}7)${NC} ${CYAN}Git Help ${YELLOW}(ghelp)${NC} # Get help with Git Companion${NC}"

	# Prompt for user input
	read -p "$(echo -e "${YELLOW}Enter the number corresponding to the option:  ${NC}")" choice

	# Case statement to handle user input. We launch the corresponding script based on the user's choice 
	case $choice in
		1) bash "$(pwd)/bin/Git_User/git-user-script.sh" ;;
		2) bash "$(pwd)/bin/Git_Init/git-init-script.sh" ;;
		3) bash "$(pwd)/bin/Git_Branch/git-branch-script.sh" ;;
		4) bash "$(pwd)/bin/Git_Commit/git-commit-script.sh" ;;
		5) bash "$(pwd)/bin/Git_Log/git-log-script.sh" ;;
		6) bash "$(pwd)/bin/Git_Config/git-config-script.sh" ;;
		7) bash "$(pwd)/bin/Git_Help/git-help-script.sh" ;;
		*) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
	esac
}

function init() {
	access_menu
}

init