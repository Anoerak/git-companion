#!/bin/bash

# --------------------------------------------------
	# Check permissions for the script
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

check_environment() {
	local command=$1

	if [ "$ENV" == "DEV" ]; then
		source ./libs/check/check-permissions.sh
		if [ "$command" == "install" ]; then
			check_permissions bin/install-dev.sh
		elif [ "$command" == "uninstall" ]; then
			check_permissions bin/uninstall-dev.sh
		else
			echo -e "${ORANGE}Unknown command${NC}"
			exit 1
		fi
	elif [ "$ENV" == "PROD" ]; then
		source ./libs/check/check-permissions.sh
		if [ "$command" == "install" ]; then
			check_permissions bin/install-prod.sh
		elif [ "$command" == "uninstall" ]; then
			check_permissions bin/uninstall-prod.sh
		else
			echo -e "${ORANGE}Unknown command${NC}"
			exit 1
		fi
	else
		echo -e "${ORANGE}The environment is not set.${NC}"
		echo -e "${YELLOW}Please set the environment in the .env file.${NC}"
		exit 1
	fi
}