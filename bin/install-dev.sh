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

PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')     # Let's get the base directory of the script and sanitize it
OS=$(uname -s)                                  # Let's find out what system we are on
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}') # Let's find out what shell we are using

# Let's loop through the folders in the bin directory
function_loop_folders() {
	local FOLDER=$1
	PROFILE_DRAFT=$(mktemp)

	cd $FOLDER || ""

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
	source libs/imgs/imgs-ascii.sh
	function_print_header
	source libs/define-profile.sh
	init install
	function_loop_folders bin
	source $PROFILE
	function_print_footer
}

init
