#!/bin/bash

# chmod +x git-branch-script.sh
# chmod -x git-branch-script.sh
# ./git-branch-script.sh

# --------------------------------------------------
	# Handle the branch creation process
	# by: Anørak
	# version: 1.0
	# updated: 2024-06-24
# --------------------------------------------------

# ANSI color codes
# --------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
ORANGE='\033[38;5;214m' # Custom code for orange
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Flags
# --------------------------------------------------
BRANCH_OPTIONS=false
MODIFY_DEFAULT_USER=false
MODIFY_USER_FLAG=false
GIT_BRANCH_CONFIG_FLAG=false
GITIGNORE_FLAG=false

# Variables
# --------------------------------------------------
ALIAS="gbranch"

# Function to prompt for input
prompt() {
    local var_name=$1
    local prompt_message=$2
    local default_value=$3
    read -p "$(echo -e "${YELLOW}$prompt_message (max 64 characters) ($default_value): ${NC}")" input
    eval $var_name='"${input:-$default_value}"'
}

modify_default_user() {
    read -p "$(echo -e "${YELLOW}Change default username? (y/n): ${NC}")" change_user
    if [[ "$change_user" =~ ^[Yy]$ ]]; then
        MODIFY_DEFAULT_USER=true
        select_user
    elif [[ "$change_user" =~ ^[Nn]$ ]] && [ "$BRANCH_OPTIONS" == true ]; then
        BRANCH_OPTIONS=false
        create_branch_options
    else
        echo -e "${ORANGE}You are about to modify the username without saving it as default.${NC}"
        MODIFY_DEFAULT_USER=false
        MODIFY_USER_FLAG=true
        select_user
    fi
}

create_git_branch_config() {
    if [ ! -f .git-branch-config ]; then
        read -p "$(echo -e "${YELLOW}No '.git-branch-config file' found. Create one? (y/n): ${NC}")" create_config
        if [[ "$create_config" =~ ^[Yy]$ ]]; then
            touch .git-branch-config
            GIT_BRANCH_CONFIG_FLAG=true
            if [ ! -f .gitignore ]; then
                read -p "$(echo -e "${YELLOW}Add '.git-branch-config' to .gitignore? (y/n): ${NC}")" add_to_gitignore
                if [[ "$add_to_gitignore" =~ ^[Yy]$ ]]; then
                    echo -e "${BLUE}Creating .gitignore file...${NC}"
                    # If Script is denied permission to create .gitignore file, ask user to authorize
                    if ! ./git-gitignore-script.sh; then
                        echo -e "${RED}Permission denied.${NC}"
                        read -p "$(echo -e "${YELLOW}Authorize script to create .gitignore file? (y/n): ${NC}")" authorize
                        if [[ "$authorize" =~ ^[Yy]$ ]]; then
                            chmod +x git-gitignore-script.sh
                        else
                            echo -e "${RED}Error: Permission denied. Script cannot create .gitignore file.${NC}"
                            echo -e "${YELLOW}What do you want to do?${NC}"
                            echo -e "1) ${GREEN}Come back to main menu${NC}"
                            echo -e "2) ${ORANGE}Exit the script${NC}"
                            read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
                            if [ "$action_choice" == "1" ]; then
                                echo -e "${BLUE}Returning to main menu...${NC}"
                                ./git-branch-script.sh
                            else
                                echo -e "${RED}Exiting script.${NC}"
                                exit 1
                            fi
                        fi
                    fi
                    ./git-gitignore-script.sh
                    echo -e "${GREEN}.gitignore file created successfully.${NC}"
                    GITIGNORE_FLAG=true
                    echo ".git-branch-config" >>.gitignore
                    echo "USER_NAME=$USER_NAME" >.git-branch-config
                    echo -e "${GREEN}'.git-branch-config' added to .gitignore.${NC}"
                    echo -e "${blue}$USER_NAME${NC} ${green}saved as default username.${NC}"
                else
                    echo "USER_NAME=" >.git-branch-config
                fi
            else
                echo "USER_NAME=" >.git-branch-config
            fi
        else
            echo -e "${RED}Error: '.git-branch-config' file not found.${NC}"
            exit 1
        fi
    fi
}

select_user() {
    # If a default username is saved, we use it
    if [ -f .git-branch-config ] && [ ! "$MODIFY_DEFAULT_USER" == true ]; then
        source .git-branch-config
        if [[ -n "$USER_NAME" ]] && [ "$MODIFY_USER_FLAG" == true ]; then
            echo -e "${YELLOW}Using default username:${NC} ${GREEN}$USER_NAME${NC}"
            read -p "$(echo -e "${YELLOW}Change the username for this branch only? (y/n): ${NC}")" change_user
            if [[ "$change_user" =~ ^[Yy]$ ]]; then
                MODIFY_DEFAULT_USER=true
                select_user
            elif [[ "$change_user" =~ ^[Nn]$ ]]; then
                # So what do we want to do?
                echo -e "${YELLOW}Select an action:${NC}"
                echo -e "1) ${GREEN}Change default username${NC}"
                echo -e "2) ${GREEN}Change username for this branch only${NC}"
                echo -e "3) ${ORANGE}Exit the script${NC}"
                read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
                case $action_choice in
                1)
                    MODIFY_DEFAULT_USER=true
                    MODIFY_USER_FLAG=false
                    modify_default_user
                    ;;
                2)
                    MODIFY_USER_FLAG=true
                    select_user
                    ;;
                3) exit 1 ;;
                *)
                    echo -e "${RED}Invalid choice${NC}"
                    select_user
                    ;;
                esac
            else
                echo -e "${RED}Invalid choice${NC}"
                select_user
            fi
        elif [[ -n "$USER_NAME" ]]; then
            echo -e "${YELLOW}Using default username:${NC} ${GREEN}$USER_NAME${NC}"
            return
        fi
    else
        # If no default username is saved, we ask the user to select a username
        # We get the list of users based on the operating system
        local system_os=$(uname)
        # MACOS
        if [ "$system_os" == "Darwin" ]; then
            local users=($(dscl . -list /Users | grep -v '^_'))
            # We add a custom options to let the user enter a custom username
            users+=("custom")
        fi

        # WINDOWS
        if [ "$system_os" == "MINGW64_NT-10.0" ]; then
            local users=($(compgen -u))
            # We add a custom options to let the user enter a custom username
            users+=("custom")
        fi

        # LINUX
        if [ "$system_os" == "Linux" ]; then
            local users=($(getent passwd | cut -d: -f1))
            # We add a custom options to let the user enter a custom username
            users+=("custom")
        fi

        if [ ${#users[@]} -eq 0 ]; then
            echo -e "${RED}Error: No users found on this system.${NC}"
            exit 1
        fi

        echo -e "${BLUE}Select your username:${NC}"
        select user in "${users[@]}"; do
            # We want to use a custom username
            if [[ "$user" == "custom" ]]; then
                prompt "USER_NAME" "Enter your username" ""
                if [ "$MODIFY_USER_FLAG" == true ]; then
                    read -p "$(echo -e "${YELLOW}Use${NC} '${BLUE}$USER_NAME${NC}' ${YELLOW}as username for this branch? (y/n): ${NC}")" save
                    MODIFY_DEFAULT_USER=false
                else
                    read -p "$(echo -e "${YELLOW}Save${NC} '${BLUE}$USER_NAME${NC}' ${YELLOW}as default username? (y/n): ${NC}")" save
                fi
                if [[ "$save" =~ ^[Yy]$ ]]; then
                    if [ "$MODIFY_DEFAULT_USER" == true ]; then
                        echo "USER_NAME=$USER_NAME" >.git-branch-config
                        MODIFY_DEFAULT_USER=false
                        echo -e "${BLUE}$USER_NAME${NC} ${GREEN}saved as default username.${NC}"
                        if [ "$BRANCH_OPTIONS" == true ]; then
                            handle_branch_modification "username" "$USER_NAME"
                        fi
                    elif [ "$MODIFY_DEFAULT_USER" == false ] && [ "$BRANCH_OPTIONS" == true ]; then
                        handle_branch_modification "username" "$USER_NAME"
                    else
                        create_git_branch_config
                    fi
                else
                    # Do you want to modify something?
                    read -p "$(echo -e "${YELLOW}Do you want to modify something? (y/n): ${NC}")" modify
                    if [[ "$modify" =~ ^[Yy]$ ]]; then
                        # What do you want to modify?
                        echo -e "${YELLOW}Select an action:${NC}"
                        echo -e "1) ${GREEN}Change default username${NC}"
                        echo -e "2) ${GREEN}Change username for this branch only${NC}"
                        echo -e "3) ${ORANGE}Exit the script${NC}"
                        read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
                        case $action_choice in
                        1)
                            MODIFY_DEFAULT_USER=true
                            MODIFY_USER_FLAG=false
                            modify_default_user
                            ;;
                        2)
                            MODIFY_USER_FLAG=true
                            MODIFY_DEFAULT_USER=false
                            select_user
                            ;;
                        3) exit 1 ;;
                        *)
                            echo -e "${RED}Invalid choice${NC}"
                            select_user
                            ;;
                        esac
                    else
                        echo -e "${RED}Username creation aborted.${NC}"
                        exit 1
                    fi
                fi
                break
            else
                if [[ -n "$user" ]]; then
                    USER_NAME="$user"
                    # Do we want to save the username as default?
                    if [ "$MODIFY_USER_FLAG" == true ]; then
                        read -p "$(echo -e "${YELLOW}Use${NC} '${BLUE}$USER_NAME${NC}' ${YELLOW}as username for this branch? (y/n): ${NC}")" save
                        MODIFY_DEFAULT_USER=false
                    else
                        read -p "$(echo -e "${YELLOW}Save${NC} '${BLUE}$USER_NAME${NC}' ${YELLOW}as default username? (y/n): ${NC}")" save
                    fi
                    if [[ "$save" =~ ^[Yy]$ ]]; then
                        if [ "$MODIFY_DEFAULT_USER" == true ]; then
                            echo "USER_NAME=$USER_NAME" >.git-branch-config
                            MODIFY_DEFAULT_USER=false
                            echo -e "${BLUE}$USER_NAME${NC} ${GREEN}saved as default username.${NC}"
                            if [ "$BRANCH_OPTIONS" == true ]; then
                                handle_branch_modification "username" "$USER_NAME"
                            fi
                        elif [ "$MODIFY_DEFAULT_USER" == false ] && [ "$BRANCH_OPTIONS" == true ]; then
                            handle_branch_modification "username" "$USER_NAME"
                        else
                            create_git_branch_config
                        fi
                    else
                        # Do you want to modify something?
                        read -p "$(echo -e "${YELLOW}Do you want to modify something? (y/n): ${NC}")" modify
                        if [[ "$modify" =~ ^[Yy]$ ]]; then
                            # What do you want to modify?
                            echo -e "${YELLOW}Select an action:${NC}"
                            echo -e "1) ${GREEN}Change default username${NC}"
                            echo -e "2) ${GREEN}Change username for this branch only${NC}"
                            echo -e "3) ${ORANGE}Exit the script${NC}"
                            read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
                            case $action_choice in
                            1)
                                MODIFY_DEFAULT_USER=true
                                MODIFY_USER_FLAG=false
                                modify_default_user
                                ;;
                            2)
                                MODIFY_USER_FLAG=true
                                MODIFY_DEFAULT_USER=false
                                select_user
                                ;;
                            3) exit 1 ;;
                            *)
                                echo -e "${RED}Invalid choice${NC}"
                                select_user
                                ;;
                            esac
                        else
                            echo -e "${RED}Username creation aborted.${NC}"
                            exit 1
                        fi
                    fi
                    break
                else
                    echo -e "${RED}Invalid choice. Please select a username.${NC}"
                    select_user
                fi
            fi
        done
    fi
}

# Function to select branch type
select_branch_type() {
    # What type of branch are we creating?
    echo -e "${BLUE}Select branch type:${NC}"
    echo -e "0) ${GREEN}develop${NC} For development branch (default and should be unique)"
    echo -e "1) ${GREEN}feature:${NC} For new features development"
    echo -e "2) ${GREEN}bugfix:${NC} For bug fixes and hotfixes (select critical bugfix YES for hotfix)"
    echo -e "3) ${GREEN}release:${NC} For preparing a new release"
    echo -e "4) ${GREEN}improvement:${NC} For refactoring existing code or improving performance, update dependencies.."
    echo -e "5) ${GREEN}experimental:${NC} For experimental changes"
    echo -e "6) ${GREEN}docs:${NC} For documentation changes"
    echo -e "7) ${GREEN}test:${NC} For adding or modifying tests"
    echo -e "8) ${CYAN}custom:${NC} For custom branch types"
    echo -e "9) ${ORANGE}change user:${NC} To change the default username (current: ${GREEN}$USER_NAME${NC})"
    read -p "$(echo -e "${YELLOW}Enter the number corresponding to the branch type: ${NC}")" branch_type_choice

    case $branch_type_choice in
    0) BRANCH_TYPE="develop" ;;
    1) BRANCH_TYPE="feature" ;;
    2) BRANCH_TYPE="bugfix" ;;
    3) BRANCH_TYPE="release" ;;
    4) BRANCH_TYPE="improvement" ;;
    5) BRANCH_TYPE="experimental" ;;
    6) BRANCH_TYPE="docs" ;;
    7) BRANCH_TYPE="test" ;;
    8) BRANCH_TYPE="custom" ;;
    9)
        modify_default_user
        select_branch_type
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        ./git-branch-script.sh
        ;;
    esac

    case $BRANCH_TYPE in
    develop)
        BRANCH_NAME="develop"
        ;;
    custom)
        prompt "BRANCH_TYPE" "Enter the custom branch type" ""
        enter_scope
        enter_improvement_feature_test_custom
        ;;
    feature | improvement | test)
        enter_scope
        enter_improvement_feature_test_custom
        ;;
    bugfix | hotfix)
        enter_bugfix_or_hotfix
        ;;
    release)
        enter_release_version
        ;;
    experimental)
        enter_scope
        prompt_branch_name
        BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}/${BRANCH_NAME}"
        ;;
    docs)
        enter_scope
        prompt_branch_name
        BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}/${BRANCH_NAME}"
        ;;
    esac

}

# Function to enter scope (optional)
enter_scope() {
    prompt "BRANCH_SCOPE" "Enter the scope of the change (e.g., component, module)" ""
    if [[ -n "$BRANCH_SCOPE" ]]; then
        BRANCH_SCOPE="($BRANCH_SCOPE)"
    fi
}

enter_bugfix_or_hotfix() {
    # Are we creating a bugfix or a hotfix?
    read -p "$(echo -e "${YELLOW}Is this a critical bugfix? (y/n): ${NC}")" critical_bugfix

    # It is a hotfix, we ask for the release version
    if [[ "$critical_bugfix" =~ ^[Yy]$ ]]; then
        BRANCH_TYPE="hotfix"
        enter_release_version
    fi

    # If it's a bugfix, we ask for the issue ID
    if [ "$BRANCH_TYPE" == "bugfix" ]; then
        prompt "ISSUE_ID" "Enter the issue reference" ""
        if [[ -n "$ISSUE_ID" ]]; then
            ISSUE_ID="${ISSUE_ID}_"
        fi
        prompt_branch_name
        BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}/${ISSUE_ID}${BRANCH_NAME}"
    fi

}

enter_release_version() {
    # New tag flag
    new_tag=false

    # We get the latest tag
    if ! git describe --tags --abbrev=0 >/dev/null 2>&1; then
        echo -e "${RED}No previous tags found.${NC}"
    else
        latest_tag=$(git describe --tags --abbrev=0)
    fi

    if [[ -n "$latest_tag" ]]; then
        echo -e "${CYAN}Latest tag:${NC} ${GREEN}$latest_tag${NC}"
    fi

    read -p "$(echo -e "${YELLOW}Enter the release version (e.g., 1.0.0): ${NC}")" RELEASE_VERSION

    # If no valid object name refs/tags/$RELEASE_VERSION exists, we offer to create a new tag
    if ! git rev-parse "refs/tags/$RELEASE_VERSION" >/dev/null 2>&1; then
        read -p "$(echo -e "${YELLOW}Release version ${GREEN}$RELEASE_VERSION${YELLOW} does not exist. Create a new tag? (y/n): ${NC}")" create_tag
        if [[ "$create_tag" =~ ^[Yy]$ ]]; then
            read -p "$(echo -e "${YELLOW}Enter the tag message: ${NC}")" tag_message
            # We had the 'v' prefix to the tag version
            git tag -a "$RELEASE_VERSION" -m "$tag_message"
            echo -e "${YELLOW}Tag ${GREEN}$RELEASE_VERSION${YELLOW} created successfully.${NC}"
            echo -e "Check the tag with ${CYAN}git show $RELEASE_VERSION${NC}"
            new_tag=true
        else
            echo -e "${RED}Tag creation aborted.${NC}"
            enter_release_version
        fi
    fi

    # Check if release version is empty
    if [[ -z "$RELEASE_VERSION" ]]; then
        echo -e "${RED}Error: Release version cannot be empty.${NC}"
        enter_release_version
    fi

    # Check if release version is valid
    if [[ ! "$RELEASE_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}Error: Invalid release version.${NC}"
        enter_release_version
    fi

    # Check if release version is already tagged
    if [ "$new_tag" != true ] && git rev-parse "refs/tags/$RELEASE_VERSION" >/dev/null 2>&1; then
        echo -e "${RED}Error: Release version $RELEASE_VERSION is already tagged.${NC}"

        # What do we do next?
        echo -e "${YELLOW}Select an action:${NC}"
        echo -e "1) ${GREEN}Edit your version number${NC}"
        echo -e "2) ${GREEN}Edit the tag${NC}"
        echo -e "3) ${ORANGE}Exit the script${NC}"
        read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
        case $action_choice in
        1) enter_release_version ;;
        2)
            read -p "$(echo -e "${YELLOW}Enter the new tag message: ${NC}")" tag_message
            git tag -a "$RELEASE_VERSION" -m "$tag_message" -f
            echo -e "${YELLOW}Tag ${GREEN}$RELEASE_VERSION${YELLOW} updated successfully.${NC}"
            echo -e "Check the tag with ${CYAN}git show $RELEASE_VERSION${NC}"
            ;;
        3) exit 1 ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            # Let's start over
            enter_release_version
            ;;
        esac
    fi

    # Check if release version is ahead/behind the latest tag
    if [[ -n "$latest_tag" ]]; then
        latest_tag="$latest_tag"
        release_tag="$RELEASE_VERSION"

        # Get sorted list
        sorted_tags=$(echo -e "$latest_tag\n$release_tag" | sort -V)
        first_tag=$(echo "$sorted_tags" | head -n 1)
        last_tag=$(echo "$sorted_tags" | tail -n 1)

        if [[ "$release_tag" == "$first_tag" && "$release_tag" != "$last_tag" ]]; then
            check_version_comparison "$release_tag" "behind"
        elif [[ "$release_tag" == "$last_tag" && "$release_tag" != "$first_tag" ]]; then
            check_version_comparison "$release_tag" "ahead of"
        fi
    fi

    read -p "$(echo -e "${YELLOW}Is there an open issue for this release? (y/n): ${NC}")" open_issue
    if [[ "$open_issue" =~ ^[Yy]$ ]]; then
        prompt "ISSUE_ID" "Enter the issue reference" ""
        if [[ -n "$ISSUE_ID" ]]; then
            ISSUE_ID="${ISSUE_ID}_"
        fi
        prompt_branch_name
        BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}/${RELEASE_VERSION}/${ISSUE_ID}${BRANCH_NAME}"
    else
        prompt_branch_name
        BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}/${RELEASE_VERSION}/${BRANCH_NAME}"
    fi
}

enter_improvement_feature_test_custom() {
    prompt_branch_name

    prompt "TICKET_ID" "Enter the ticket reference, if any" ""
    if [[ -n "$TICKET_ID" ]]; then
        BRANCH_NAME="${TICKET_ID}_${BRANCH_NAME}"
    fi

    BRANCH_NAME="${USER_NAME}/${BRANCH_TYPE}${BRANCH_SCOPE}/${BRANCH_NAME}"
}

# Function to prompt for branch name with description limit
prompt_branch_name() {
    # If branch type is bugfix or hotfix, we ask for the issue ID
    if [ "$BRANCH_TYPE" == "bugfix" ] || [ "$BRANCH_TYPE" == "hotfix" ]; then
        prompt "BRANCH_NAME" "Enter a brief description of the issue" ""
    else
        prompt "BRANCH_NAME" "Enter a brief description for the branch" ""
    fi

    # Remove all spaces and special characters. Replace spaces with hyphens.
    BRANCH_NAME="${BRANCH_NAME//[^a-zA-Z0-9]/-}"
    # Convert to lowercase
    BRANCH_NAME=$(echo "$BRANCH_NAME" | tr '[:upper:]' '[:lower:]')
    # Trim to 64 characters
    # If more than 64 characters, show the truncated message and ask for confirmation
    if [ ${#BRANCH_NAME} -gt 64 ]; then
        echo -e "${ORANGE}Branch name is too long. Truncating to 64 characters.${NC}"
        BRANCH_NAME=${BRANCH_NAME:0:64}
        echo -e "${YELLOW}Truncated branch name:${NC} ${RED}$BRANCH_NAME${NC}"
        read -p "$(echo -e "${ORANGE}Press Enter to continue or type EDIT to modify the branch name: ${NC}")" input
        if [[ "$input" == "EDIT" ]]; then
            prompt_branch_name
        else
            return
        fi
    fi
    # Replace multiple hyphens with a single hyphen
    BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/-\+/-/g')
    # Remove leading and trailing hyphens
    BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/^-//;s/-$//')
    # Check if branch name is empty
    if [[ -z "$BRANCH_NAME" ]]; then
        echo -e "${RED}Error: Branch name cannot be empty.${NC}"
        # What do we do from here?
        echo -e "${YELLOW}Select an action:${NC}"
        echo -e "1) ${GREEN}Edit the branch name${NC}"
        echo -e "2) ${ORANGE}Exit the script${NC}"
        read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
        case $action_choice in
        1) prompt_branch_name ;;
        2) exit 1 ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            # Let's start over
            prompt_branch_name
            ;;
        esac
    fi
}

check_version_comparison() {
    local comparison="$1"
    local message="$2"

    echo -e "${CYAN}Checking if release version is $message the latest tag...${NC}"

    if [[ -n $comparison ]]; then
        echo -e "${RED}Error: Release version $RELEASE_VERSION is $message the latest tag $latest_tag.${NC}"
        echo -e "${YELLOW}Select an action:${NC}"
        echo -e "1) ${GREEN}Edit your version number${NC}"
        echo -e "2) ${ORANGE}Ignore and continue${NC}"
        read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
        case $action_choice in
        1) enter_release_version ;;
        2) ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            enter_release_version
            ;;
        esac
    fi
}

# Main function to create branch
create_branch() {
    select_user
    select_branch_type

    # Check if branch already exists
    if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
        echo -e "${RED}Error: Branch '$BRANCH_NAME' already exists.${NC}"
        exit 1
    fi

    # Create the branch
    create_branch_options
}

create_branch_options() {
    # We ask for a confirmation before creating the branch
    read -p "$(echo -e "${YELLOW}Create branch${NC} '${GREEN}$BRANCH_NAME'? (y/n): ${NC}")" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        git checkout -b "$BRANCH_NAME"
        echo -e "${YELLOW}Branch ${GREEN}'$BRANCH_NAME'${NC} created successfully.${NC}"
        if [ "GIT_BRANCH_CONFIG_FLAG" == true ]; then
            echo -e "${GREEN}'.git-branch-config' available here ${CYAN}$(pwd)/.git-branch-config${NC}"
        fi
        if [ "GITIGNORE_FLAG" == true ]; then
            echo -e "${GREEN}'.gitignore' available here ${CYAN}$(pwd)/.gitignore${NC}"
        fi
    else
        # No choices, ask again
        if [[ "$confirm" =~ ^[Nn]$ ]]; then
            # Do you want to modify something?
            read -p "$(echo -e "${YELLOW}Do you want to modify something? (y/n): ${NC}")" modify
            if [[ "$modify" =~ ^[Yy]$ ]]; then
                # What do you want to modify?
                echo -e "${YELLOW}Select an action:${NC}"
                echo -e "0) ${BLUE}Change Username${NC}"
                # Dynamic choices based on the branch type
                case $BRANCH_TYPE in
                develop | feature | improvement | test | experimental | docs)
                    echo -e "1) ${GREEN}Change Branch type${NC}"
                    echo -e "2) ${GREEN}Change Scope${NC}"
                    echo -e "3) ${GREEN}Change Branch name${NC}"
                    if [[ -n "$TICKET_ID" ]]; then
                        echo -e "4) ${GREEN}Change Ticket ID${NC}"
                    fi
                    ;;
                bugfix | hotfix)
                    echo -e "1) ${GREEN}Change Branch type${NC}"
                    echo -e "2) ${GREEN}Change Issue ID${NC}"
                    echo -e "3) ${GREEN}Change Branch name${NC}"
                    if [[ -n "$TICKET_ID" ]]; then
                        echo -e "4) ${GREEN}Change Ticket ID${NC}"
                    fi
                    ;;
                release)
                    echo -e "1) ${GREEN}Change Branch type${NC}"
                    echo -e "2) ${GREEN}Change Release version${NC}"
                    echo -e "3) ${GREEN}Change Branch name${NC}"
                    if [[ -n "$TICKET_ID" ]]; then
                        echo -e "4) ${GREEN}Change Ticket ID${NC}"
                    fi
                    ;;
                esac
                echo -e "E) ${ORANGE}Exit the script${NC}"
                read -p "$(echo -e "${YELLOW}Enter the number corresponding to the action: ${NC}")" action_choice
                case $action_choice in
                0)
                    BRANCH_OPTIONS=true
                    MODIFY_USER_FLAG=true
                    select_user
                    ;;
                1)
                    # What type of branch are we creating?
                    echo -e "${BLUE}Select branch type:${NC}"
                    echo -e "0) ${GREEN}develop${NC} For development branch (default and should be unique)"
                    echo -e "1) ${GREEN}feature:${NC} For new features development"
                    echo -e "2) ${GREEN}bugfix:${NC} For bug fixes and hotfixes (select critical bugfix YES for hotfix)"
                    echo -e "3) ${GREEN}release:${NC} For preparing a new release"
                    echo -e "4) ${GREEN}improvement:${NC} For refactoring existing code or improving performance, update dependencies.."
                    echo -e "5) ${GREEN}experimental:${NC} For experimental changes"
                    echo -e "6) ${GREEN}docs:${NC} For documentation changes"
                    echo -e "7) ${GREEN}test:${NC} For adding or modifying tests"
                    echo -e "8) ${CYAN}custom:${NC} For custom branch types"
                    read -p "$(echo -e "${YELLOW}Enter the number corresponding to the branch type: ${NC}")" branch_type_choice

                    case $branch_type_choice in
                    0) BRANCH_TYPE="develop" ;;
                    1) BRANCH_TYPE="feature" ;;
                    2) BRANCH_TYPE="bugfix" ;;
                    3) BRANCH_TYPE="release" ;;
                    4) BRANCH_TYPE="improvement" ;;
                    5) BRANCH_TYPE="experimental" ;;
                    6) BRANCH_TYPE="docs" ;;
                    7) BRANCH_TYPE="test" ;;
                    8) BRANCH_TYPE="custom" ;;
                    *)
                        echo -e "${RED}Invalid choice${NC}"
                        create_branch_options
                        ;;
                    esac

                    handle_branch_modification "branch_type" "$BRANCH_TYPE"
                    ;;
                2)
                    case $BRANCH_TYPE in
                    develop | feature | improvement | test | experimental | docs)
                        read -p "$(echo -e "${YELLOW}Enter the new scope of the change (e.g., component, module): ${NC}")" BRANCH_SCOPE
                        if [[ -n "$BRANCH_SCOPE" ]]; then
                            handle_branch_modification "scope" "$BRANCH_SCOPE"
                        fi
                        ;;
                    bugfix | hotfix)
                        read -p "$(echo -e "${YELLOW}Enter the new issue reference: ${NC}")" ISSUE_ID
                        if [[ -n "$ISSUE_ID" ]]; then
                            handle_branch_modification "issue_id" "$ISSUE_ID"
                        fi
                        ;;
                    release)
                        read -p "$(echo -e "${YELLOW}Enter the new release version (e.g., 1.0.0): ${NC}")" RELEASE_VERSION
                        if [[ -n "$RELEASE_VERSION" ]]; then
                            handle_branch_modification "release_version" "$RELEASE_VERSION"
                        fi
                        ;;
                    esac
                    ;;
                3)
                    prompt "NEW_BRANCH_NAME" "Enter the new branch name" ""
                    if [[ -n "$NEW_BRANCH_NAME" ]]; then
                        handle_branch_modification "branch_name" "$NEW_BRANCH_NAME"
                    fi
                    ;;
                4)
                    if [[ -n "$TICKET_ID" ]]; then
                        prompt "TICKET_ID" "Enter the new ticket reference" ""
                        if [[ -n "$TICKET_ID" ]]; then
                            handle_branch_modification "ticket_id" "$TICKET_ID"
                        fi
                    fi
                    ;;
                E | e) exit 1 ;;
                *)
                    echo -e "${RED}Invalid choice${NC}"
                    create_branch_options
                    ;;
                esac
            else
                echo -e "${RED}Branch creation aborted.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Invalid choice${NC}"
            create_branch_options
        fi
    fi
}

handle_branch_modification() {
    local element=$1
    local value=$2

    INITIAL_BRANCH_NAME=$BRANCH_NAME

    # We parse the initial branch name to get all parts
    IFS='/' read -r -a branch_parts <<<"$INITIAL_BRANCH_NAME"
    # Is there a scope in the branch name? If so, we need to keep it (it should be in between parentheses)
    if [[ "${branch_parts[1]}" =~ ^\(.+\)$ ]]; then
        BRANCH_TYPE="${branch_parts[1]}"
        BRANCH_SCOPE="${branch_parts[2]}"
    fi

    case $element in
    username)
        BRANCH_OPTIONS=false
        # We replace the username with the new one
        USER_NAME="${value}"
        # We replace the username in the branch name
        branch_parts[0]=${USER_NAME}
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    branch_type)
        # We replace the branch type with the new one
        branch_parts[1]=${BRANCH_TYPE}${BRANCH_SCOPE}
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    scope)
        # We replace the scope with the new one and add the parentheses
        BRANCH_SCOPE="($value)"
        branch_parts[1]=${BRANCH_TYPE}${BRANCH_SCOPE}
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    issue_id)
        # We replace the issue ID with the new one
        ISSUE_ID="${value}_"
        # If bugfix, ISSUE_ID is at index 2, else it's at index 3
        if [ "$BRANCH_TYPE" == "bugfix" ]; then
            branch_parts[2]=${ISSUE_ID}
        else
            branch_parts[3]=${ISSUE_ID}
        fi
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    ticket_id)
        # We replace the ticket ID with the new one
        TICKET_ID="${value}"
        # How many parts do we have?
        parts_count=${#branch_parts[@]}
        # We get the last part
        LAST_PART=${branch_parts[$parts_count - 1]}
        # We split the last part to get the ticket ID
        IFS='_' read -r -a last_part_parts <<<"$LAST_PART"
        # We replace the ticket ID with the new one
        last_part_parts[0]=${TICKET_ID}
        LAST_PART=$(
            IFS=_
            echo "${last_part_parts[*]}"
        )
        # We replace the last part with the new one
        branch_parts[$parts_count - 1]=${LAST_PART}
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    release_version)
        # We replace the release version with the new one
        RELEASE_VERSION="${value}"
        # If release, RELEASE_VERSION is at index 2, else it's at index 3
        if [ "$BRANCH_TYPE" == "release" ]; then
            branch_parts[2]=${RELEASE_VERSION}
        else
            branch_parts[3]=${RELEASE_VERSION}
        fi
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    branch_name)
        # We sanitize the new branch name
        NEW_BRANCH_NAME="${value//[^a-zA-Z0-9]/-}"
        NEW_BRANCH_NAME=$(echo "$NEW_BRANCH_NAME" | tr '[:upper:]' '[:lower:]')
        NEW_BRANCH_NAME=$(echo "$NEW_BRANCH_NAME" | sed 's/-\+/-/g')
        NEW_BRANCH_NAME=$(echo "$NEW_BRANCH_NAME" | sed 's/^-//;s/-$//')

        # How many parts do we have?
        parts_count=${#branch_parts[@]}
        # We get the last part
        LAST_PART=${branch_parts[$parts_count - 1]}
        # Is there a ticket ID in the branch name (there should be an underscore)?
        if [[ "$LAST_PART" =~ _ ]]; then
            # We split the last part to get the ticket ID
            IFS='_' read -r -a last_part_parts <<<"$LAST_PART"
            # We replace the last part with the new one
            last_part_parts[1]=${NEW_BRANCH_NAME}
            LAST_PART=$(
                IFS=_
                echo "${last_part_parts[*]}"
            )
            # We replace the last part with the new one
            branch_parts[$parts_count - 1]=${LAST_PART}
        else
            LAST_PART=${NEW_BRANCH_NAME}
        fi
        # We replace the branch name with the new one
        branch_parts[$parts_count - 1]=${LAST_PART}
        # We join the parts back together
        BRANCH_NAME=$(
            IFS=/
            echo "${branch_parts[*]}"
        )
        create_branch_options
        ;;
    esac

}

# Execute the main function
create_branch
