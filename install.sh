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

install() {
	source libs/load-env.sh
	source libs/check/check-environment.sh
	check_environment install
}

install
