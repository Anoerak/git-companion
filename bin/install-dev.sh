#!/bin/bash

# chmod +x install-dev.sh
# chmod -x install-dev.sh
# aliases as install-dev

# --------------------------------------------------
# Install script-dev for the Git Companion
# by: Anørak
# version: 1.0
# updated: 2024-06-24
# --------------------------------------------------

# We loop through the folder and for each directory, we add an alias at the end
# of the user bash profile file.
# The alias will be named after the named provided in the comment in the script within the folder.
# e.g: in the folder bin/Git_Gitignore, the script gitignore.sh has a comment "# aliased as gignore"
# so we add an alias in the user bash profile file as "alias gignore='bash /path/to/gitignore.sh'"
# We also add a comment to explain the alias.
# We reload the user bash profile file to make the alias available.

PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')     # Let's get the base directory of the script and sanitize it
OS=$(uname -s)                                  # Let's find out what system we are on
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}') # Let's find out what shell we are using

# Base on the system, we will add the alias to the correct file
function_define_profile() {
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

function_check_profile() {
	if [ ! -f "$PROFILE" ]; then
		echo "Profile file $PROFILE not found"
		return 1
	fi
}

function_check_profile_for_alias() {
	if grep -q "# GIT COMPANION start" "$PROFILE"; then
		echo "Aliases already added to $PROFILE"
		# what do we do?
		handle_profile_options
	fi
}

handle_profile_options() {
	echo "Do you want to remove the aliases from $PROFILE? [y/n]"
	read -r REMOVE_ALIASES
	if [ "$REMOVE_ALIASES" == "y" ]; then
		remove_aliases
	elif [ "$REMOVE_ALIASES" == "n" ]; then
		echo "Aliases will not be removed from $PROFILE"
	else
		echo "Invalid option"
		handle_profile_options
	fi
}

remove_aliases() {
	PROFILE_DRAFT=$(mktemp)
	{
		sed -e '/# GIT COMPANION start/,/# GIT COMPANION end/d' -e '/^$/d' "$PROFILE"
	} >>"$PROFILE_DRAFT"
	cat "$PROFILE_DRAFT" >"$PROFILE"
	rm -f "$PROFILE_DRAFT"
	echo "Aliases successfully removed from $PROFILE"

	echo "Do you want to add the new aliases? [y/n]"
	read -r ADD_ALIASES
	if [ "$ADD_ALIASES" == "y" ]; then
		# We pass to the next step
		function_loop_folders bin
		source $PROFILE
	elif [ "$ADD_ALIASES" == "n" ]; then
		echo "Aliases will not be added to $PROFILE"
		source $PROFILE
		exit 0
	else
		echo "Invalid option"
		remove_aliases
	fi
}

# Let's loop through the folders in the bin directory
function_loop_folders() {
	local FOLDER=$1
	PROFILE_DRAFT=$(mktemp)

	cd $FOLDER

	{
		echo -e "\n"
		echo -e "# GIT COMPANION start"

		for folder in */; do
			[ -d "$folder" ] || continue # Skip if not a directory
			cd "$folder" || continue
			# If folder is empty, skip
			if [ ! "$(ls -A .)" ]; then
				cd ..
				continue
			fi
			for file in *.sh; do
				[ -f "$file" ] || continue # Skip if not a file
				ALIAS=$(grep -E '^ALIAS=' "$file" | sed "s/['\"]//g" | sed 's/ALIAS=//')
				# If the file does not have an alias, skip
				if [ -n "$ALIAS" ]; then
					ESCAPE_PATH=$(echo $PWD | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
					echo -e "alias $ALIAS=\"bash $ESCAPE_PATH/$file\""
				else
					echo "No alias found in $file"
				fi
			done
			cd ..
		done

		echo -e "# GIT COMPANION end"
		echo -e "\n"
	} >>"$PROFILE_DRAFT"

	# If the previous block executed without error, append the PROFILE_DRAFT to BASH_PROFILE and remove the temporary file
	if [ $? -eq 0 ]; then
		cat "$PROFILE_DRAFT" >>"$PROFILE"
		rm -f "$PROFILE_DRAFT"
		echo "Aliases successfully added to $PROFILE"
	else
		echo "An error occurred. No changes were made to $PROFILE."
		rm -f "$PROFILE_DRAFT"
		return 1
	fi

	cd - >/dev/null

}

init() {
	function_define_profile
	function_check_profile
	function_check_profile_for_alias
	function_loop_folders bin
	source $PROFILE
}

init
