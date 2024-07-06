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
	echo "******************************************"
	echo "*                                        *"
	echo "*      Welcome to GitCompanion!          *"
	echo "*   Your friendly assistant for GIT.     *"
	echo "*                                        *"
	echo "******************************************"
	echo ""
	echo "$LOGO"
	echo ""
}

# Function to print the footer
function_print_footer() {
	echo ""
	echo "******************************************"
	echo "*                                        *"
	echo "*  Thank you for using GitCompanion!     *"
	echo "*                                        *"
	echo "******************************************"
}
