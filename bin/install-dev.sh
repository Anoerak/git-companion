#!/bin/bash

# chmod +x install-dev.sh
# chmod -x install-dev.sh
# aliases as install-dev

# --------------------------------------------------
# Install script-dev for the Git Companion
# by: Anørak
# version: 1.1
# updated: 2024-07-14
# --------------------------------------------------

# Load environment variables
source libs/color-codes.sh

# Variables
PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')     # Let's get the base directory of the script and sanitize it
OS=$(uname -s)                                  # Let's find out what system we are on
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}') # Let's find out what shell we are using

# ANSI color codes
if [ -f "/usr/local/bin/git_companion/color-codes.sh" ]; then
	source /usr/local/bin/git_companion/color-codes.sh
else
	source $PWD/libs/color-codes.sh
fi

function loop_folders() {
    local FOLDER=$1
    PROFILE_DRAFT=$(mktemp)
    ALIAS_FOUND=false

    cd "$FOLDER" 2>/dev/null || return

    if [ -n "$FOLDER" ]; then
        echo -e "\n# GIT COMPANION start" >> "$PROFILE_DRAFT"

        for folder in */; do
            [ -d "$folder" ] || continue # Skip if not a directory
            cd "$folder" 2>/dev/null || continue
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
                    ESCAPE_PATH=$(echo "$PWD" | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
                    echo -e "alias $ALIAS=\"bash $ESCAPE_PATH/$file\"" >> "$PROFILE_DRAFT"
                    ALIAS_FOUND=true
                else
                    echo "No alias found in $file"
                fi
            done
            cd ..
        done

        echo -e "# GIT COMPANION end\n" >> "$PROFILE_DRAFT"
    fi

    # If aliases were found, append the PROFILE_DRAFT to BASH_PROFILE and remove the temporary file
    if [ "$ALIAS_FOUND" = true ]; then
        cat "$PROFILE_DRAFT" >> "$PROFILE"
        rm -f "$PROFILE_DRAFT"
        echo -e "${GREEN}Aliases successfully added to ${NC}${CYAN}$PROFILE${NC}"
    else
        rm -f "$PROFILE_DRAFT"
        echo -e "${ORANE}No aliases found. ${NC}${YELLOW}No changes were made to${NC}${BLUE} $PROFILE.${NC}"
    fi

    cd - >/dev/null
}

function init() {
    source libs/check/check-bash.sh
    
    source libs/check/check-git.sh

    source libs/imgs/imgs-ascii.sh
    print_header

    source libs/define-profile.sh
    init install

    loop_folders bin

    print_footer
    
    # We reload the profile to apply the changes
    source "$PROFILE"

    source ../Git_First-launch/git-first-launch.sh
}

init
