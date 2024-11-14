#!/bin/bash

# Define color codes for output formatting
BOLD_YELLOW="\033[1;33m"
BOLD_RED="\033[1;31m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Function to run a command and handle output
run_command() {
    local command="$1"
    local suppress_output="$2"

    echo -e "${GREEN}✔${RESET} Running command: $command"
    if eval "$command" &> /dev/null; then
        if [[ "$suppress_output" != "true" ]]; then
            echo -e "${GREEN}✔${RESET} Command succeeded: $command"
        fi
        return 0
    else
        echo -e "${RED}✖${RESET} Command failed: $command"
        return 1
    fi
}

# Function to remove the lock file if it exists
remove_lock_file() {
    local lock_file="/var/lib/pacman/db.lck"

    if [[ -f "$lock_file" ]]; then
        echo -e "${BOLD_YELLOW}Info:${RESET} Lock file found at $lock_file. Attempting to remove it."
        if run_command "sudo rm '$lock_file'"; then
            echo -e "${GREEN}✔${RESET} Lock file removed successfully."
        else
            echo -e "${RED}✖${RESET} Failed to remove the lock file. Ensure no other pacman processes are running."
            return 1
        fi
    else
        echo -e "${BOLD_YELLOW}Info:${RESET} No db.lck file found."
    fi
    return 0
}

# Function to get a list of orphaned packages
get_installed_packages() {
    local orphaned_packages
    orphaned_packages=$(sudo pacman -Qdtq)
    echo "$orphaned_packages"
}

# Main function to execute the script logic
main() {
    echo -e "${BOLD_RED}REMINDER:${RESET} Please enter your password to proceed with elevated commands."
    sudo -v

    if ! remove_lock_file; then
        return 1
    fi

    local orphaned_packages_list
    orphaned_packages_list=$(get_installed_packages)

    if [[ -n "$orphaned_packages_list" ]]; then
        echo -e "${BOLD_YELLOW}Info:${RESET} Orphaned packages found. Proceeding to removal."
        # Proceed to remove orphaned packages
        if run_command "sudo pacman -Rns --noconfirm $orphaned_packages_list"; then
            echo -e "${GREEN}✔${RESET} Orphaned packages removed successfully."
        else
            echo -e "${RED}✖${RESET} Failed to remove orphaned packages."
        fi
    else
        echo -e "${BOLD_YELLOW}Info:${RESET} No orphaned packages found."
    fi
}

# Execute the main function
main