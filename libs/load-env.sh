#!/bin/bash

# --------------------------------------------------
	# Load environment variables
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

load_env() {
	if [ -f .env ]; then
		source .env
	else
		echo "The .env file does not exist."
		exit 1
	fi
}

load_env