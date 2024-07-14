#!/bin/bash

# chmod +x install-prod.sh
# chmod -x install-prod.sh
# aliases as install-dev

# --------------------------------------------------
	# Install install-prod for the Git Companion
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-14
# --------------------------------------------------

# Load environment variables
source libs/color-codes.sh

PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
OS=$(uname -s)
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}')
PROFILE="$HOME/.bash_profile"  # Adjust if using a different shell profile

# Create the bin directory if it doesn't exist
INSTALL_DIR="/usr/local/bin/git_companion"
sudo mkdir -p "$INSTALL_DIR"

# Copy scripts to the bin directory
sudo cp -r bin/* "$INSTALL_DIR/"

function_loop_folders() {
    local FOLDER=$1
    PROFILE_DRAFT=$(mktemp)
    ALIAS_FOUND=false

    cd "$FOLDER" 2>/dev/null || return

    if [ -n "$FOLDER" ]; then
        echo -e "\n# GIT COMPANION start" >> "$PROFILE_DRAFT"

        for folder in */; do
            [ -d "$folder" ] || continue
            cd "$folder" 2>/dev/null || continue
            if [ ! "$(ls -A .)" ]; then
                cd ..
                continue
            fi
            for file in *.sh; do
                [ -f "$file" ] || continue
                ALIAS=$(grep -E '^ALIAS=' "$file" | sed "s/['\"]//g" | sed 's/ALIAS=//')
                if [ -n "$ALIAS" ]; then
                    ESCAPE_PATH=$(echo "$INSTALL_DIR/$folder$file" | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
                    echo -e "alias $ALIAS=\"bash $ESCAPE_PATH\"" >> "$PROFILE_DRAFT"
                    ALIAS_FOUND=true
                else
                    echo "No alias found in $file"
                fi
            done
            cd ..
        done

        echo -e "# GIT COMPANION end\n" >> "$PROFILE_DRAFT"
    fi

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

init() {
    echo "Initializing Git Companion setup..."

    function_loop_folders "$INSTALL_DIR"

    echo "Git Companion setup complete."
    source "$PROFILE"
}

init
