#!/bin/bash

# chmod +x git-commit-script.sh
# chmod -x git-commit-script.sh
# ./git-commit-script.sh

# --------------------------------------------------
	# Handle the commit process
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
source libs/color-codes.sh

# Variables
# --------------------------------------------------
ALIAS="gcommit"

# Function to prompt for input
prompt() {
	local var_name=$1
	local prompt_message=$2
	local default_value=$3
	read -p "$(echo -e "${YELLOW}$prompt_message ($default_value):${NC} ")" input
	eval $var_name='"${input:-$default_value}"'
}

# Function to select module
select_module() {
	echo -e "${BLUE}Select commit type:${NC}"
	echo -e "${GREEN}1)${NC}${CYAN} feat:${NC} A new feature"
	echo -e "${GREEN}2)${NC}${CYAN} fix:${NC} A bug fix"
	echo -e "${GREEN}3)${NC}${CYAN} docs:${NC} Documentation only changes"
	echo -e "${GREEN}4)${NC}${CYAN} style:${NC} Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)"
	echo -e "${GREEN}5)${NC}${CYAN} refactor:${NC} A code change that neither fixes a bug nor adds a feature"
	echo -e "${GREEN}6)${NC}${CYAN} perf:${NC} A code change that improves performance"
	echo -e "${GREEN}7)${NC}${CYAN} test:${NC} Adding missing tests or correcting existing tests"
	echo -e "${GREEN}8)${NC}${CYAN} build:${NC} Changes that affect the build system or external dependencies"
	echo -e "${GREEN}9)${NC}${CYAN} ci:${NC} Changes to our CI configuration files and scripts"
	echo -e "${GREEN}10${NC})${CYAN} chore:${NC} Other changes that don't modify src or test files"
	echo -e "${GREEN}11${NC})${CYAN} revert:${NC} Reverts a previous commit"
	echo -e "${ORANGE}12${NC}) ${RED}SECURITY${NC}: ${ORANGE}Fixing security issues${NC}"
	echo -e "${ORANGE}13${NC}) ${RED}BREAKING CHANGE${NC}: ${ORANGE}A breaking change${NC}"
	echo -e "${CYAN}14${NC})${BLUE} custom:${NC} Custom commit type"
	read -p "$(echo -e "${YELLOW}Enter the number corresponding to the commit type:${NC} ")" module_choice

	case $module_choice in
	1) MODULE="feat" ;;
	2) MODULE="fix" ;;
	3) MODULE="docs" ;;
	4) MODULE="style" ;;
	5) MODULE="refactor" ;;
	6) MODULE="perf" ;;
	7) MODULE="test" ;;
	8) MODULE="build" ;;
	9) MODULE="ci" ;;
	10) MODULE="chore" ;;
	11) MODULE="revert" ;;
	12) MODULE="SECURITY" ;;
	13) MODULE="BREAKING CHANGE" ;;
	14)
		read -p "$(echo -e "${YELLOW}Enter the custom commit type:${NC} ")" custom_module
		MODULE="[$custom_module]"
		;;
	*)
		echo -e "${WHITE_ON_RED}Invalid choice${NC}"
		# Let's start over
		select_module
		;;
	esac
}

# Function to select scope
select_scope() {
	read -p "$(echo -e "${YELLOW}Enter the scope of the change (e.g., component, module):${NC} ")" SCOPE
	if [[ -n "$SCOPE" ]]; then
		SCOPE="($SCOPE)"
	fi
}

# Function to stage files
stage_files() {
	echo -e "${BLUE}Unstaged files:${NC}"
	git status --porcelain | grep -E '^[AMDR]|^ [MD]|^\?\?' | nl
	read -p "$(echo -e "${YELLOW}Enter the numbers of the files to stage, separated by spaces (or 'all' to stage all):${NC} ")" file_choices

	if [ -n "$(git diff --cached --name-only)" ]; then
		read -p "$(echo -e "${YELLOW}You already have staged files. Do you want to unstage them? (y/n):${NC} ")" unstage_choice
		if [[ "$unstage_choice" =~ ^[Yy]$ ]]; then
			git reset
		fi
	fi

	if [[ "$file_choices" =~ ^[Aa][Ll][Ll]$ ]]; then
		git add .
	else
		for choice in $file_choices; do
			file=$(git status --porcelain | grep -E '^[AMDR]|^ [MD]|^\?\?' | sed -n "${choice}p" | awk '{print $2}')
			git add "$file"
		done
	fi
}

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

DEFAULT_ISSUE_ID=""
DEFAULT_DESCRIPTION=""

select_module

# If the branch name contains a scope, use it as the default scope
# and ask for confirmation
if [[ $BRANCH_NAME == *"/"* ]]; then
	DEFAULT_SCOPE=$(echo $BRANCH_NAME | cut -d'/' -f2)
	read -p "$(echo -e "${YELLOW}Use '$DEFAULT_SCOPE' as the default scope? (y/n):${NC} ")" scope_choice
	if [[ "$scope_choice" =~ ^[Yy]$ ]]; then
		SCOPE="($DEFAULT_SCOPE)"
	fi
fi

# If the module is security, we prompt for more information
if [ "$MODULE" == "SECURITY" ]; then
	read -p "$(echo -e "${YELLOW}Enter the package manager (e.g., NODE, COMPOSER):${NC} ")" PACKAGE_MANAGER
	read -p "$(echo -e "${YELLOW}Enter the package name:${NC} ")" PACKAGE_NAME
	read -p "$(echo -e "${YELLOW}Enter the CVE or other reference:${NC} ")" REFERENCE
	read -p "$(echo -e "${YELLOW}Enter the classification/description/notes:${NC} ")" CLASSIFICATION
	prompt "ISSUE_ID" "Enter the reference ticket" "$DEFAULT_ISSUE_ID"

	# Ensure the description ends with a period
	if [[ "$CLASSIFICATION" != *"." ]]; then
		CLASSIFICATION="$CLASSIFICATION"
	fi

	COMMIT_MSG="$MODULE ($PACKAGE_MANAGER): $PACKAGE_NAME - $REFERENCE ($CLASSIFICATION). Ref $ISSUE_ID"
else
	if [ "$MODULE" == "BREAKING CHANGE" ]; then
		select_scope

		prompt "DESCRIPTION" "Enter the BREAKING CHANGE description" "$DEFAULT_DESCRIPTION"
		prompt "ISSUE_ID" "Enter the issue reference (or leave blank to skip)" "$DEFAULT_ISSUE_ID"

		if [[ "$DESCRIPTION" != *"." ]]; then
			DESCRIPTION="$DESCRIPTION."
		fi

		if [ -z "$ISSUE_ID" ]; then
			COMMIT_MSG="$MODULE$SCOPE: $DESCRIPTION"
		else
			COMMIT_MSG="$MODULE$SCOPE: $DESCRIPTION (Issue #$ISSUE_ID)"
		fi

	else
		select_scope

		prompt "DESCRIPTION" "Enter the commit description" "$DEFAULT_DESCRIPTION"
		prompt "ISSUE_ID" "Enter the issue reference (or leave blank to skip)" "$DEFAULT_ISSUE_ID"

		if [[ "$DESCRIPTION" != *"." ]]; then
			DESCRIPTION="$DESCRIPTION."
		fi

		if [ -z "$ISSUE_ID" ]; then
			COMMIT_MSG="$MODULE$SCOPE: $DESCRIPTION"
		else
			COMMIT_MSG="$MODULE$SCOPE: $DESCRIPTION (Issue #$ISSUE_ID)"
		fi
	fi
fi

read -p "$(echo -e "${YELLOW}Do you want to stage changes? (y/n):${NC} ")" stage_choice
if [[ "$stage_choice" =~ ^[Yy]$ ]]; then
	stage_files
fi

echo -e "${BLUE}Do you want to commit with the following message:${NC} ${GREEN2}$COMMIT_MSG${NC} ${BLUE}?${NC}"
echo -e "${BLUE}Staged files:${NC}"
git diff --cached --name-only

read -p "$(echo -e "${YELLOW}Confirm (y/n):${NC} ")" confirm_choice
if [[ "$confirm_choice" =~ ^[Yy]$ ]]; then
	git commit -m "$COMMIT_MSG"
	echo -e "${WHITE_ON_GREEN}Committed with message${NC}: $COMMIT_MSG$"
else
	echo -e "${WHITE_ON_RED}Commit aborted.${NC}"
fi
