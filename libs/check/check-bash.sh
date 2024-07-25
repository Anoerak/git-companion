#!/bin/bash

# --------------------------------------------------
	# Check if bash is installed
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-15
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

# Function to check if Git is installed
check_bash() {
	echo -e "${YELLOW}Checking if Bash is installed...${NC}"
	if ! [ -x "$(command -v bash)" ]; then
		echo -e "${RED}Error: Bash is not installed.${NC}"
		read -p "$(echo -e "${YELLOW}Do you want to install Bash? (y/n): ${NC} ")" action
		if [ "$action" = "y" ]; then
			if [ "$(uname -s)" == "Darwin" ]; then
				# Is brew installed?
				if ! [ -x "$(command -v brew)" ]; then
					echo -e "${RED}Error: Brew is required to install Bash.${NC}"
					read -p "$(echo -e "${YELLOW}Do you want to install Brew? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
					else
						echo -e "${RED}Error: Brew is required to install Bash.${NC}"
						exit 1
					fi
				fi
				brew install bash
			elif [ "$(uname -s)" == "Linux" ]; then
				# Is apt-get installed?
				if ! [ -x "$(command -v apt-get)" ]; then
					echo -e "${RED}Error: apt-get is required to install Bash.${NC}"
					read -p "$(echo -e "${YELLOW}Do you want to install apt-get? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						sudo apt-get update
						sudo apt-get install apt-get
					else
						echo -e "${RED}Error: apt-get is required to install Bash.${NC}"
						exit 1
					fi
				fi
				sudo apt-get install bash
			elif [ "$(uname -s)" == "Windows_NT" ]; then
				# Is scoop installed?
				if ! [ -x "$(command -v scoop)" ]; then
					echo -e "${RED}Error: Scoop is required to install Bash.${NC}"
					read -p "$(echo -e "${YELLOW}Do you want to install Scoop? (y/n): ${NC} ")" action
					if [ "$action" = "y" ]; then
						powershell.exe -Command "Set-ExecutionPolicy RemoteSigned -scope CurrentUser; iex ((New-Object Net.WebClient).DownloadString('https://get.scoop.sh'))"
					else
						echo -e "${RED}Error: Scoop is required to install Bash.${NC}"
						exit 1
					fi
				fi
				scoop install bash
			else
				echo -e "${RED}Error: Your system is not supported.${NC}"
				exit 1
			fi
		else
			echo -e "${RED}Error: Bash is not installed.${NC}"
			exit 1
		fi
	fi
}

# Initialize the function
check_bash

