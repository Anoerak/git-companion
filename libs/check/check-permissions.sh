#!/bin/bash

# --------------------------------------------------
	# Check permissions for the script
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

check_permissions() {
	local script=$1
	
	if [ ! -x $script ]; then
		echo "The script $script is not authorized to run."
		echo "Do you want to change the permissions?"
		read -t 30 -p "Enter 'yes' or 'no': " answer
		if [ "$answer" == "yes" ]; then
			chmod +x $script
			echo "The permissions have been changed."
			read -t 30 -p "Do you want to run the script now? Enter 'yes' or 'no': " answer
			if [ "$answer" == "yes" ]; then
				./$script
			else
				echo "The script has not been run."
				exit 1
			fi
		else
			echo "The permissions have not been changed."
			exit 1
		fi
	else 
		echo "Executing the script $script."
		./$script
	fi
}
