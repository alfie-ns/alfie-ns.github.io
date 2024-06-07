#!/bin/bash -euo pipefail

# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error and exit immediately.
# -o pipefail: Return the exit status of the first command that fails in a pipeline.

# Function to bail with style
# handle_error: Prints the error message and exits with the given status code.
handle_error() {
    local exit_code="$1"
    local msg="$2"
    echo "Error: $msg" >&2
    exit "$exit_code"
}

# Verify push.sh's existence and executability
# if push.sh is not found, exit with error(2)
[[ ! -f "./push.sh" ]] && handle_error 2 "push.sh is missing."

# if push.sh is not executable, exit with error(3)
[[ ! -x "./push.sh" ]] && handle_error 3 "push.sh is not executable."

# Execute push.sh
# if it fails, script stops due to 'set -e'
./push.sh

# Post-push actions: navigating up and cleaning the directory
echo "Pushed to GitHub; backing out to parent directory"
cd ..

# Remove alfie-ns.github.io directory recursively
# if rm fails, script stops due to 'set -e'
rm -rf alfie-ns.github.io

# 'alfie-ns' ascii
cat <<'EOF'

 ⚙️ Process complete ⚙️ 

         _  __ _                     
   __ _ | |/ _(_) ___       _ __  ___
  / _` || | |_| |/ _ \_____| '_ \/ __|
 | (_| || |  _| |  __/_____| | | \__ \
  \__,_||_|_| |_|\___|     |_| |_|___/
  
EOF