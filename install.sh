#!/bin/bash

# chmod +x install.sh
# chmod -x install.sh
# aliases as install

# --------------------------------------------------
	# Install scripts for the Git Companion
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# Function to check if the script is authroized to run
check_permissions() {
	local script=$1
	
	if [ ! -x $script ]; then
		echo "The script $script is not authorized to run."
		echo "Do you want to change the permissions?"
		read -t 30 -p "Enter 'yes' or 'no': " answer
		if [ "$answer" == "yes" ]; then
			chmod +x $script
			echo "The permissions have been changed."
			read -t 30 -p "Do you want to run the script now? Enter 'yes' or 'no': " answer
			if [ "$answer" == "yes" ]; then
				./$script
			else
				echo "The script has not been run."
				exit 1
			fi
		else
			echo "The permissions have not been changed."
			exit 1
		fi
	else 
		echo "Executing the script $script."
		./$script
	fi
}

load_env() {
	if [ -f .env ]; then
		source .env
	else
		echo "The .env file does not exist."
		exit 1
	fi
}

check_environment() {
	if [ "$ENV" == "DEV" ]; then
		check_permissions bin/install-dev.sh
	elif [ "$ENV" == "PROD" ]; then
		check_permissions bin/install-prod.sh
	else
		echo "The environment is not set."
		echo "Please set the environment in the .env file."
		exit 1
	fi
}

init() {
	load_env
	check_environment
}

init
