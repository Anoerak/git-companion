#!/bin/bash

# chmod +x imgs-ascii.sh
# chmod -x imgs-ascii.sh
# aliases as install-dev

# --------------------------------------------------
	# ASCII art images
	# by: Anørak
	# version: 1.0
	# updated: 2024-07-06
# --------------------------------------------------

ALIAS="gascii"

# ANSI color codes
source libs/color-codes.sh

# Define the ASCII logo
LOGO=$(cat <<'EOF'
#   _______ _       _______                              _             
#  (_______|_)  _  (_______)                            (_)            
#   _   ___ _ _| |_ _       ___  ____  ____  _____ ____  _  ___  ____  
#  | | (_  | (_   _) |     / _ \|    \|  _ \(____ |  _ \| |/ _ \|  _ \ 
#  | |___) | | | |_| |____| |_| | | | | |_| / ___ | | | | | |_| | | | |
#   \_____/|_|  \__)\______)___/|_|_|_|  __/\_____|_| |_|_|\___/|_| |_|
#                                     |_|                              
EOF
)

# Function to print the header
function_print_header() {
	echo -e "${CYAN}******************************************"
	echo -e "*                                        *"
	echo -e "*      Welcome to GitCompanion!          *"
	echo -e "*   Your friendly assistant for GIT.     *"
	echo -e "*                                        *"
	echo -e "******************************************${NC}"
	echo -e ""
	echo -e "${YELLOW}$LOGO${NC}"
	echo -e ""
}

# Function to print the footer
function_print_footer() {
	echo -e ""
	echo -e "${GREEN2}******************************************"
	echo -e "*                                        *"
	echo -e "*  Thank you for using GitCompanion!     *"
	echo -e "*                                        *"
	echo -e "******************************************${NC}"
}
