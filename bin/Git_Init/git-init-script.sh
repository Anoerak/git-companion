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

# ANSI color codes
source libs/color-codes.sh

# Function to initialize a new repository
function init_repo() {
	echo -e "${YELLOW}Initializing a new repository...${NC}"
	git init
	echo -e "${GREEN}Repository initialized successfully.${NC}"
	read -p "$(echo -e "${YELLOW}Do you want to add a remote repository? (y/n): ${NC} ")" choice
	if [ "$choice" = "y" ]; then
		read -p "$(echo -e "${YELLOW}Enter the remote repository URL: ${NC} ")" url
		git remote add origin "$url"
		echo -e "${GREEN}Remote repository added successfully.${NC}"
		read -p "$(echo -e "${YELLOW}Do you want to rename the main branch? (y/n): ${NC} ")" choice
		if [ "$choice" = "y" ]; then
			read -p "$(echo -e "${YELLOW}Enter the new branch name: ${NC} ")" branch
			git checkout -b "$branch"
			echo -e "${GREEN}Branch renamed successfully.${NC}"
		else
			echo -e "${ORANGE}No branch renamed.${NC}"
		fi
	else
		echo -e "${ORANGE}No remote repository added.${NC}"
	fi
}

# Function to get the repository informations
function get_repo() {
	echo -e "${YELLOW}Name${NC}=> ${CYAN}$(git config --get remote.origin.url)${NC}"
	echo -e "${YELLOW}Branch${NC}=> ${CYAN}$(git branch --show-current)${NC}"
	echo -e "${YELLOW}User${NC}=> ${CYAN}$(git config --get user.name)${NC}"
	echo -e "${YELLOW}Email${NC}=> ${CYAN}$(git config --get user.email)${NC}"
}

# Function to modify an existing repository informations
function modify_repo() {
	echo -e "${YELLOW}Here are the current repository informations:${NC}"
	echo -e "${YELLOW}Name${NC}=> ${CYAN}$(git config --get remote.origin.url)${NC}"
	echo -e "${YELLOW}Branch${NC}=> ${CYAN}$(git branch --show-current)${NC}"
	echo -e "${YELLOW}User${NC}=> ${CYAN}$(git config --get user.name)${NC}"
	echo -e "${YELLOW}Email${NC}=> ${CYAN}$(git config --get user.email)${NC}"
	echo ""
	read -p "$(echo -e "${YELLOW}Do you want to modify the repository informations? (y/n): ${NC} ")" choice
	if [ "$choice" = "y" ]; then
		echo -e "${YELLOW}Which information do you want to modify?${NC}"
		echo -e "${GREEN}1)${NC} ${CYAN}Repository name${NC}"
		echo -e "${GREEN}2)${NC} ${CYAN}Branch${NC}"
		echo -e "${GREEN}3)${NC} ${CYAN}User${NC}"
		echo -e "${GREEN}4)${NC} ${CYAN}Email${NC}"
		read -p "$(echo -e "${YELLOW}Enter the number(s) corresponding to the information(s) you want to modify using a space between each number: ${NC} ")" choice
		for choice in $choices; do
			case $choice in
				1) read -p "$(echo -e "${YELLOW}Enter the new repository name: ${NC} ")" name
					git remote set-url origin "$name" ;;
				2) read -p "$(echo -e "${YELLOW}Enter the new branch name: ${NC} ")" branch
					git checkout -b "$branch" ;;
				3) read -p "$(echo -e "${YELLOW}Enter the new user: ${NC} ")" user
					git config --global user.name "$user" ;;
				4) read -p "$(echo -e "${YELLOW}Enter the new email: ${NC} ")" email
					git config --global user.email "$email" ;;
				*) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
			esac
		done
		echo -e "${GREEN}Modification(s) made successfully.${NC}"
	else
		echo -e "${ORANGE}No modification(s) made.${NC}"
	fi
}

function init() {
	echo -e "${YELLOW}Git Init${NC}"
	echo ""
	echo -e "${BLUE}What do you want to do?${NC}"
	echo -e "${GREEN}1)${NC} ${CYAN}Initialize a new repository${NC}"
	echo -e "${GREEN}2)${NC} ${CYAN}Get the repository informations${NC}"
	echo -e "${GREEN}3)${NC} ${CYAN}Modify the repository informations${NC}"
	read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action you want to perform: ${NC} ")" choice
	case $choice in
		1) init_repo ;;
		2) get_repo ;;
		3) modify_repo ;;
		*) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
	esac

	read -p "$(echo -e "${YELLOW}Do you want to perform another action? (y/n): ${NC} ")" choice
	if [ "$choice" = "y" ]; then
		init
	else
		echo -e "${YELLOW}Goodbye!${NC}"
	fi
}

init
