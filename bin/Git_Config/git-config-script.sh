#!/bin/bash

# chmod +x git-user-script.sh
# chmod -x git-user-script.sh
# aliases as gconfig

# --------------------------------------------------
	# Git User - Set up your user informations
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-15
# --------------------------------------------------

ALIAS="gconfig"

# ANSI color codes
source libs/color-codes.sh

# Function to set up your .gitconfig, .gitignore, .git-branch-config, .git-commit-config or .gitattributes
function set_config() {
	echo -e "${YELLOW}Setting up your Git configuration...${NC}"
	echo -e "${BLUE}Which configuration file do you want to set up?${NC}"
	echo -e "${GREEN}1) ${NC}${CYAN}.gitconfig${NC}"
	echo -e "${GREEN}2) ${NC}${CYAN}.gitignore${NC}"
	echo -e "${GREEN}3) ${NC}${CYAN}.git-branch-config${NC}"
	echo -e "${GREEN}4) ${NC}${CYAN}.git-commit-config${NC}"
	echo -e "${GREEN}5) ${NC}${CYAN}.gitattributes${NC}"
	read -p "$(echo -e "${YELLOW}Enter the number corresponding to the configuration file: ${NC} ")" choice
	case $choice in
		1) if [ -f ~/.gitconfig ]; then
				read -p "$(echo -e "${YELLOW}A .gitconfig file already exists. Do you want to read it, overwrite it or skip it? (r/o/s): ${NC} ")" action
				if [ "$action" = "r" ]; then
					cat ~/.gitconfig
					read -p "$(echo -e "${YELLOW}Do you want to overwrite it? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						rm ~/.gitconfig
					else
						set_config
					fi
				elif [ "$action" = "o" ]; then
					rm ~/.gitconfig
				else
					set_config 
				fi
			fi
			read -p "$(echo -e "${YELLOW}Enter your name: ${NC} ")" name
			read -p "$(echo -e "${YELLOW}Enter your email: ${NC} ")" email
			git config --global user.name "$name"
			git config --global user.email "$email" ;;
		2) if [ -f .gitignore ]; then
				read -p "$(echo -e "${YELLOW}A .gitignore file already exists. Do you want to read it, overwrite it or skip it? (r/o/s): ${NC} ")" action
				if [ "$action" = "r" ]; then
					cat .gitignore
					read -p "$(echo -e "${YELLOW}Do you want to overwrite it? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						rm .gitignore
					else
						set_config
					fi
				elif [ "$action" = "o" ]; then
					rm .gitignore
				else
					set_config
				fi
			fi
			read -p "$(echo -e "${YELLOW}Enter the files you want to ignore using a space between each file or type 'template' to use a template:  ${NC} ")" files
			if [ "$files" = "template" ]; then
				curl -o .gitignore https://www.toptal.com/developers/gitignore/api/templates
			else
				for file in $files; do
					echo "$file" >> .gitignore
				done
			fi ;;
		3) if [ -f .git-branch-config ]; then
				read -p "$(echo -e "${YELLOW}A .git-branch-config file already exists. Do you want to read it, overwrite it or skip it? (r/o/s): ${NC} ")" action
				if [ "$action" = "r" ]; then
					cat .git-branch-config
					read -p "$(echo -e "${YELLOW}Do you want to overwrite it? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						rm .git-branch-config
					else
						set_config
					fi
				elif [ "$action" = "o" ]; then
					rm .git-branch-config
				else
					set_config
				fi
			fi
			read -p "$(echo -e "${YELLOW}Enter the branch you want to set up:  ${NC} ")" branch
			git branch --set-upstream-to=origin/"$branch" "$branch" ;;
		4) if [ -f .git-commit-config ]; then
				read -p "$(echo -e "${YELLOW}A .git-commit-config file already exists. Do you want to read it, overwrite it or skip it? (r/o/s): ${NC} ")" action
				if [ "$action" = "r" ]; then
					cat .git-commit-config
					read -p "$(echo -e "${YELLOW}Do you want to overwrite it? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						rm .git-commit-config
					else
						set_config
					fi
				elif [ "$action" = "o" ]; then
					rm .git-commit-config
				else
					set_config
				fi
			fi
			read -p "$(echo -e "${YELLOW}Enter the commit message you want to set up:  ${NC} ")" message
			git config --global commit.template "$message" ;;
		5) if [ -f .gitattributes ]; then
				read -p "$(echo -e "${YELLOW}A .gitattributes file already exists. Do you want to read it, overwrite it or skip it? (r/o/s): ${NC} ")" action
				if [ "$action" = "r" ]; then
					cat .gitattributes
					read -p "$(echo -e "${YELLOW}Do you want to overwrite it? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						rm .gitattributes
					else
						set_config
					fi
				elif [ "$action" = "o" ]; then
					rm .gitattributes
				else
					set_config
				fi
			fi
			read -p "$(echo -e "${YELLOW}Enter the attributes you want to set up using a space between each attribute:  ${NC} ")" attributes
			for attribute in $attributes; do
				echo "$attribute" >> .gitattributes
			done ;;
		*) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
	esac
	echo -e "${GREEN}Git configuration set up successfully.${NC}"
}

# Function to init
function init() {
	set_config
}

init
