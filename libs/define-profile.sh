#!/bin/bash

# --------------------------------------------------
	# Check and define the profile file for the aliases
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# Base on the system, we will add the alias to the correct file
define_profile() {
	if [ "$OS" == "Darwin" ]; then
		if [ "$SHELL" == "bash" ]; then
			PROFILE=~/.bash_profile
		elif [ "$SHELL" == "zsh" ]; then
			PROFILE=~/.zshrc
		fi
	elif [ "$OS" == "Linux" ]; then
		if [ "$SHELL" == "bash" ]; then
			PROFILE=~/.bashrc
		elif [ "$SHELL" == "zsh" ]; then
			PROFILE=~/.zshrc
		fi
	elif [ "$OS" == "Windows_NT" ]; then
		PROFILE=~/.bash_profile
	else
		echo "Unknown system"
		exit 1
	fi
}

check_profile() {
	if [ ! -f "$PROFILE" ]; then
		echo "Profile file $PROFILE not found"
		return 1
	fi
}

check_profile_for_alias() {
	local ORGIGIN_REQUEST=$1

	if grep -q "# GIT COMPANION start" "$PROFILE"; then
		echo "Aliases already added to $PROFILE"
		# what do we do?
		if [ "$ORGIGIN_REQUEST" == "install" ]; then
			source libs/handlers/handle-profile-options.sh
			handle_profile_options install
		else
			source libs/handlers/handle-profile-options.sh
			remove_aliases
		fi
	else 
		# what do we do?
		if [ "$ORGIGIN_REQUEST" == "install" ]; then
			function_loop_folders bin
		else
			echo "There are no Git Companion aliases in $PROFILE"
			exit 0
		fi
	fi
}

init() {
	local REQUEST=$1

	define_profile
	check_profile
	check_profile_for_alias $REQUEST
}
