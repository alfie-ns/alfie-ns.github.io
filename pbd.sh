#!/bin/bash -euo pipefail

# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error and exit immediately.
# -o pipefail: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status.

# Function to handle errors
handle_error() {
    local exit_code="$1"  # '$1' is the first argument passed to the function, assigned to 'exit_code' as the exit status code.
    local msg="$2"        # '$2' is the second argument passed to the function, assigned to 'msg' as the error message.
    echo "Error: $msg" >&2 # Output the error message to standard error (stderr).
    exit "$exit_code"     # Exit the script with the provided exit code.
}

# Verify push.sh's existence and executability
[[ ! -f "./push.sh" ]] && handle_error 2 "push.sh is missing."
[[ ! -x "./push.sh" ]] && handle_error 3 "push.sh is not executable."

# Execute push.sh
if ./pu.sh; then
    # If push.sh succeeds
    echo "Pushed to GitHub; backing out to parent directory..."
    cd ..

    # Remove alfie-ns.github.io directory recursively
    echo "Deleting local repository..."
    rm -rf alfie-ns.github.io

    # 'alfie-ns' ASCII Art
    cat <<'EOF'
-----------------------------------------
| ⚙️ Process complete ⚙️                  |
-----------------------------------------
|         _  __ _                       |
|   __ _ | |/ _(_) ___       _ __  ___  | 
|  / _` || | |_| |/ _ \_____| '_ \/ __| |
| | (_| || |  _| |  __/_____| | | \__ \ |
|  \__,_||_|_| |_|\___|     |_| |_|___/ |
 ---------------------------------------- 
EOF

else
    # If push.sh fails
    handle_error $? "Execution of push.sh failed."
fi