#!/bin/bash


# --------------------------------------------------
	# Uninstall scripts for the Git Companion
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

function uninstall() {
	source libs/load-env.sh
	source libs/check/check-environment.sh
	check_environment uninstall
}

uninstall
