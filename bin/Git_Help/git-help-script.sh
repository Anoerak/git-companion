#!/bin/bash

# chmod +x git-help-script.sh
# chmod -x git-help-script.sh
# ./git-gelp-script.sh


# --------------------------------------------------
# Git Help - A simple script to help you with Git
# by: Anørak
# version: 1.0
# updated: 2024-06-24
# --------------------------------------------------

ALIAS="ghelp"

# ANSI color codes
source libs/color-codes.sh

# Function to display the help menu
function_help_menu() {
    echo -e "${YELLOW}Welcome to Git Help!${NC}"
    echo -e "${YELLOW}Here are the available Git commands:${NC}"
    echo -e "${GREEN}1.${NC} ${CYAN}Git User ${YELLOW}(guser)${NC} # Set up your user informations${NC}"
    echo -e "${GREEN}2.${NC} ${CYAN}Git Init ${YELLOW}(ginit)${NC} # Initialize a new repository${NC}"
    echo -e "${GREEN}3.${NC} ${CYAN}Git Branch ${YELLOW}(gbranch)${NC} # Create a new branch${NC}"
    echo -e "${GREEN}4.${NC} ${CYAN}Git Commit ${YELLOW}(gcommit)${NC} # Commit your changes${NC}"
    echo -e "${GREEN}5.${NC} ${CYAN}Git Log ${YELLOW}(glog)${NC} # View the commit history${NC}"
    echo -e "${GREEN}6.${NC} ${CYAN}Git Config ${YELLOW}(gconfig)${NC} # Configure your Git${NC}"
    echo -e "${GREEN}7.${NC} ${CYAN}Git Help ${YELLOW}(ghelp)${NC} # Get help with Git Companion${NC}"

    # Prompt for user input
    read -p "$(echo -e "${YELLOW}Enter the number of the command you want to display: ${NC}")" command

    case $command in
        1) echo -e "${YELLOW}Git User${NC} ${CYAN}Set up your user informations${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}guser${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will prompt you to set up your user information for Git. It will ask for your name and email address.${NC}"
            ;;
        2) echo -e "${YELLOW}Git Init${NC} ${CYAN}Initialize a new repository${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}ginit${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will initialize a new Git repository. It will also prompt you to add a remote repository and rename the main branch.${NC}"
            ;;
        3) echo -e "${YELLOW}Git Branch${NC} ${CYAN}Create a new branch${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}gbranch${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will create a new branch in your Git repository. It will prompt you to enter the name of the new branch.${NC}"
            ;;
        4) echo -e "${YELLOW}Git Commit${NC} ${CYAN}Commit your changes${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}gcommit${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will commit your changes to the current branch. It will prompt you to enter a commit message.${NC}"
            ;;
        5) echo -e "${YELLOW}Git Log${NC} ${CYAN}View the commit history${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}glog${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will display the commit history of the current branch. It will show the commit hash, author, date, and commit message.${NC}"
            ;;
        6) echo -e "${YELLOW}Git Config${NC} ${CYAN}Configure your Git${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}gconfig${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will prompt you to configure your Git settings. It will ask for your name and email address.${NC}"
            ;;
        7) echo -e "${YELLOW}Git Help${NC} ${CYAN}Get help with Git Companion${NC}"
            echo -e "${YELLOW}Command:${NC} ${GREEN}ghelp${NC}"
            echo -e "${YELLOW}Description:${NC} ${CYAN}This command will display the available Git commands and their options. It will help you choose the right command for your needs.${NC}"
            ;;
        *) echo -e "${RED}Invalid option. Please try again.${NC}" ;;
    esac

    read -p "$(echo -e "${YELLOW}What would you like to do next? (Press Enter to continue) ${NC}")"

    echo -e "${YELLOW}Returning to the main menu...${NC}"

    # We launch the main menu script
    bash "$(pwd)/bin/Git_Menu/git-menu-script.sh"

}

# Main function to display the help menu
function_help_menu
