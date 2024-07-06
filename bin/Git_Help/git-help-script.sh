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

# Variables
# --------------------------------------------------
ALIAS="ghelp"

# Define command options in associative arrays
declare -A git_commands=(
    [1]="git log"
    [2]="git show"
    [3]="git shortlog"
    [4]="git blame"
    [5]="git diff"
    [6]="git restore"
    [7]="git reset"
    [8]="git revert"
    [9]="git cherry-pick"
    [10]="git bisect"
    [11]="git branch"
    [12]="git tag"
    [13]="git describe"
    [14]="git commit"
    [15]="git merge"
    [16]="git rebase"
    [17]="git reflog"
    [18]="git filter-branch"
    [19]="git fsck"
    [20]="git gc"
    [21]="git prune"
    [22]="git remote"
    [23]="git submodule"
)

declare -A git_options=(
    [1]="--oneline --graph --all --decorate --author='name' --since='date' --until='date' --grep='msg' --no-merges --merges --reverse --stat --patch"
    [2]="HEAD HEAD~1 HEAD^ <commit_hash>"
    [3]="-s -n -e -sn --no-merges"
    [4]="<file_name> -L 10,20 <file_name>"
    [5]=" --cached HEAD HEAD~1"
    [6]="<file_name> --staged <file_name>"
    [7]="--soft HEAD~1 --mixed HEAD~1 --hard HEAD~1"
    [8]="HEAD HEAD~1 <commit_hash>"
    [9]="<commit_hash>"
    [10]="start bad good <commit_hash> reset"
    [11]=" <branch_name> -d <branch_name>"
    [12]=" <tag_name> -d <tag_name>"
    [13]=" --tags --all"
    [14]="-m 'commit_message' --amend"
    [15]="<branch_name>"
    [16]="<branch_name>"
    [17]=" expire --expire=2.weeks delete --expire=2.weeks"
    [18]="--tree-filter 'rm -f <file_name>' HEAD"
    [19]=""
    [20]=""
    [21]=""
    [22]=" add <remote_name> <remote_url> remove <remote_name>"
    [23]="add <submodule_url> update --init update --remote"
)

prompt_user() {
    local prompt_message="$1"
    read -p "$prompt_message" user_input
    echo "$user_input"
}

construct_arguments() {
    local cmd_number="$1"
    local arguments=""
    IFS=' ' read -r -a arg_numbers <<< "$2"
    arg_numbers=($(echo "${arg_numbers[@]}" | tr ' ' '\n' | sort -n | tr '\n' ' ')) # Sort argument numbers
    
    for arg_num in "${arg_numbers[@]}"; do
        local options=(${git_options[$cmd_number]})
        local option=${options[$arg_num-1]}
        
        if [[ $option == *"<"* ]]; then
            local placeholder=$(echo $option | grep -oP "(?<=<).*(?=>)")
            local user_value=$(prompt_user "Enter $placeholder: ")
            arguments+=" ${option//<$placeholder>/$user_value}"
        else
            arguments+=" $option"
        fi
    done
    
    echo "$arguments"
}

function_choose_git_command() {
    echo "Choose a command to display the options:"

    # We sort the keys of the associative array 
    IFS=$'\n' sorted_keys=($(sort <<<"${!git_commands[*]}"))
    unset IFS
    
    for i in "${!sorted_keys[@]}"; do
        echo "$((i+1)). ${git_commands[${sorted_keys[$i]}]}"
    done
    
    local cmd_number=$(prompt_user "Enter the number of the command you want to display: ")
    
    if [[ -z "${git_commands[$cmd_number]}" ]]; then
        echo "Invalid command number"
        return
    fi
    
    echo "Options for ${git_commands[$cmd_number]}:"
    IFS=' ' read -r -a options <<< "${git_options[$cmd_number]}"
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[$i]}"
    done
    
    local arg_numbers=$(prompt_user "Enter the numbers of the arguments you want to use, separated by spaces: ")
    
    local arguments=$(construct_arguments "$cmd_number" "$arg_numbers")
    
    local final_command="${git_commands[$cmd_number]} $arguments"
    echo "Executing: $final_command"
    eval $final_command
}

init() {
    function_choose_git_command
}

init
