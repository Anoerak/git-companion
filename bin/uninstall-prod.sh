#!/bin/bash

# chmod +x uninstall-prod.sh

# --------------------------------------------------
# Uninstall script-prod for the Git Companion
# by: Anørak
# version: 1.1
# updated: 2024-07-08
# --------------------------------------------------

PWD=$(pwd | sed 's/[^a-zA-Z0-9\/_-]/\\&/g')
OS=$(uname -s)
SHELL=$(echo $SHELL | awk -F '/' '{print $NF}')
PROFILE="$HOME/.bash_profile"  # Adjust if using a different shell profile
INSTALL_DIR="/usr/local/bin/git_companion"

# Remove the installed scripts
sudo rm -rf "$INSTALL_DIR"

# Function to remove aliases from profile
function_remove_aliases() {
    local TMP_PROFILE=$(mktemp)
    local IN_BLOCK=false

    while IFS= read -r line; do
        if [[ "$line" =~ "# GIT COMPANION start" ]]; then
            IN_BLOCK=true
            continue
        elif [[ "$line" =~ "# GIT COMPANION end" ]]; then
            IN_BLOCK=false
            continue
        fi
        if [ "$IN_BLOCK" = false ]; then
            echo "$line" >> "$TMP_PROFILE"
        fi
    done < "$PROFILE"

    mv "$TMP_PROFILE" "$PROFILE"
    rm -f "$TMP_PROFILE"
}

init() {
    echo "Uninstalling Git Companion..."

    function_remove_aliases

    echo "Git Companion uninstallation complete."
    source "$PROFILE"
}

init
