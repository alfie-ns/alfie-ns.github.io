#!/bin/bash -euo pipefail

# if [[ ! -d "./alfie-ns.github.io" ]]; then
if [[ ! -x "./push.sh" ]]; then # Check if push.sh is executable
    echo "Error: ./push.sh not found or not executable."
    exit 1 # Exit with error
fi # '! -x' means not executable

# Execute push.sh and handle success or failure
if ./push.sh; then # is push.sh successful, backout to parent directory and rm repo
    echo "Pushed to GitHub; backout to parent directory"
    cd .. # Backout to parent directory
    rm -rf alfie-ns.github.io # Remove repo
    echo "Process complete"
fi