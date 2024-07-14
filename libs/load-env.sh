#!/bin/bash

# --------------------------------------------------
	# Load environment variables
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

load_env() {
	if [ -f .env ]; then
		source .env
	else
		echo -e "${ORANGE}The .env file does not exist.${NC}"
		exit 1
	fi
}

load_env