# Arch_Cleaner

This script is a Bash script designed to manage orphaned packages in an Arch Linux system using the `pacman` package manager. Here's a breakdown of its components and functionality:

### Components of the Script

1. **Function Definitions**:
   
   - **`remove_lock_file`**: This function checks for the existence of a lock file (`/var/lib/pacman/db.lck`) that prevents multiple instances of `pacman` from running simultaneously. If the lock file exists, it attempts to remove it using `sudo rm`. It also provides feedback on whether the lock file was found and successfully removed.
   - **`get_installed_packages`**: This function retrieves a list of orphaned packages (packages that were installed as dependencies but are no longer required) using the command `sudo pacman -Qdtq`. It returns this list for further processing.
   - **`main`**: This is the main function that orchestrates the script's operations. It prompts the user for elevated privileges, calls the `remove_lock_file` function, retrieves the list of orphaned packages, and attempts to remove them if any are found.

2. **Color and Formatting Variables**:
   
   - The script uses several variables (like `BOLD_YELLOW`, `RESET`, `GREEN`, `RED`, etc.) which are presumably defined elsewhere in the script to format the output text with colors and styles for better visibility.

3. **Execution Flow**:
   
   - The script starts by calling the `main` function.
   - It prompts the user for their password to run commands with `sudo`.
   - It checks for the lock file and tries to remove it if it exists.
   - It retrieves the list of orphaned packages and checks if any exist.
   - If orphaned packages are found, it attempts to remove them using `sudo pacman -Rns --noconfirm`, which removes the packages without asking for confirmation.
   - It provides feedback on the success or failure of each operation. 

### Run the Script

You can run the script directly from the terminal by navigating to the directory where you saved it and executing:

```bash
./arch_cleaner.sh
```

**Create an Alias in Zsh**

If you want to create an alias for the script in your Zsh shell, you can add it to your `.zshrc` file. i.e:    

```bash
alias cls='/path/to/arch_cleaner.sh'
```

**Apply Changes**

i.e:

```bash
source ~/.zshrc
```

### Key Points

- **Error Handling**: The script includes basic error handling to inform the user if the lock file cannot be removed or if the orphaned packages cannot be removed.
- **Use of `sudo`**: Many commands require elevated privileges, hence the use of `sudo`.
- **User Feedback**: Throughout the script, there are messages that inform the user of what is happening, which enhances the user experience.
- **Safety Measures**: The script checks for the existence of the lock file before attempting to remove it, which is a good practice to prevent conflicts with other `pacman` processes.

### Conclusion

In summary, this script is a utility for Arch Linux users to safely manage orphaned packages by removing them while ensuring that no other package management operations are occurring simultaneously. It provides a structured approach to package management while giving the user clear feedback on the process.
