#!/bin/bash

# --------------------------------------------------
	# Handle the profile options
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

remove_aliases() {
	local INSTALL_FLAG=$1

	PROFILE_DRAFT=$(mktemp)
	{
		sed -e '/# GIT COMPANION start/,/# GIT COMPANION end/d' -e '/^$/d' "$PROFILE"
	} >>"$PROFILE_DRAFT"
	cat "$PROFILE_DRAFT" >"$PROFILE"
	rm -f "$PROFILE_DRAFT"
	echo "Aliases successfully removed from $PROFILE"
	if [ "$INSTALL_FLAG" == "install" ]; then
		function_loop_folders bin
		source $PROFILE
	else
		echo "Thank you for using the Git Companion"
		exit 0
	fi
}

handle_profile_options() {
	local INSTALL_FLAG=$1

	echo "Do you want to remove the aliases from $PROFILE? [y/n]"
	read -r REMOVE_ALIASES
	if [ "$REMOVE_ALIASES" == "y" ]; then
		remove_aliases $INSTALL_FLAG
	elif [ "$REMOVE_ALIASES" == "n" ]; then
		echo "Aliases will not be removed from $PROFILE"
		echo "Do you want to add the new aliases? [y/n]"
		read -r ADD_ALIASES
		if [ "$ADD_ALIASES" == "y" ]; then
			# We pass to the next step
			function_loop_folders bin
			source $PROFILE
		elif [ "$ADD_ALIASES" == "n" ]; then
			echo "Aliases will not be added to $PROFILE"
			exit 0
		else
			echo "Invalid option"
			handle_profile_options
		fi
	else
		echo "Invalid option"
		handle_profile_options
	fi
}
