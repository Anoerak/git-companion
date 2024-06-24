#!/bin/bash

# --------------------------------------------------
	# Check permissions for the script
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

check_environment() {
	local command=$1

	if [ "$ENV" == "DEV" ]; then
		if [ "$command" == "install" ]; then
			source ./libs/check/check-permissions.sh
			check_permissions bin/install-dev.sh
		elif [ "$command" == "uninstall" ]; then
			source ./libs/check/check-permissions.sh
			check_permissions bin/uninstall-dev.sh
		else
			echo "Unknown command"
			exit 1
		fi
	elif [ "$ENV" == "PROD" ]; then
		if [ "$command" == "install" ]; then
			source ./libs/check/check-permissions.sh
			check_permissions bin/install-prod.sh
		elif [ "$command" == "uninstall" ]; then
			source ./libs/check/check-permissions.sh
			check_permissions bin/uninstall-prod.sh
		else
			echo "Unknown command"
			exit 1
		fi
	else
		echo "The environment is not set."
		echo "Please set the environment in the .env file."
		exit 1
	fi
}