#!/bin/bash

# chmod +x install-dev.sh
# chmod -x install-dev.sh
# aliases as install-dev

# --------------------------------------------------
# Uninstall script-dev for the Git Companion
# by: Anørak
# version: 1.0
# updated: 2024-06-24
# --------------------------------------------------

# Load environment variables
PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')     # Let's get the base directory of the script and sanitize it
OS=$(uname -s)                                  # Let's find out what system we are on
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}') # Let's find out what shell we are using

init() {
	source libs/define-profile.sh
	init uninstall
	source $PROFILE
}

init
