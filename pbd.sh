#!/bin/bash -euo pipefail

# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error and exit immediately.
# -o pipefail: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.

# Function to handle errors
handle_error() {
    local exit_code="$1" # '$1' is the first argument passed to the function, assigned to 'exit_code' as the exit status code.
    local msg="$2"       # '$2' is the second argument passed to the function, assigned to 'msg' as the error message.
    echo "Error: $msg" >&2 # Output the error message to standard error (stderr).
    exit "$exit_code"    # Exit the script with the provided exit code.
}

# Critical command example
# some_critical_command || handle_error 4 "Critical command failed."

# Verify push.sh's existence and executability
# if push.sh is not found, exit with error(2)
[[ ! -f "./push.sh" ]] && handle_error 2 "push.sh is missing."

# if push.sh is not executable, exit with error(3)
[[ ! -x "./push.sh" ]] && handle_error 3 "push.sh is not executable."

# Execute push.sh
# if it fails, script stops due to 'set -e'
./push.sh

# Post-push actions: navigating up and cleaning the directory
echo "Pushed to GitHub; backing out to parent directory..."
cd ..

sleep 2 # sleep for 2 seconds

# Remove alfie-ns.github.io directory recursively
# if rm fails, script stops due to 'set -e'
echo "deleting local repository..."
rm -rf alfie-ns.github.io


# 'alfie-ns' ASCII Art
cat <<'EOF'
-----------------------------------------
 ⚙️ Process complete ⚙️                   |
-----------------------------------------
|         _  __ _                       |
|   __ _ | |/ _(_) ___       _ __  ___  | 
|  / _` || | |_| |/ _ \_____| '_ \/ __| |
| | (_| || |  _| |  __/_____| | | \__ \ |
|  \__,_||_|_| |_|\___|     |_| |_|___/ |
 ---------------------------------------- 
 
EOF