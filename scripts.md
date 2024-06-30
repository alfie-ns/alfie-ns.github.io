**the scripts.md page will do the following:**

- [ ] get picture of scripts on desktop
- [ ] Get all bash scripts made on my mac
- [ ] Make more python scripts
- [ ] get all pygames from mac and dell
- [ ] make more pygames

<!-- ---------------------------------------------------------------------------------------------------------------------->

# Bash Scripts

<!--I use bash-scripts to automate nearly everything on my mac, particularty for git and vscode...elaborate [ ] -->

<!-- ---------------------------------------------------------------------------------------------------------------------->

### clone-all.sh

```

#!/bin/bash

# Function to clone a repository
clone_repo() {
    local dir=$1 # Get the directory name from the first argument
    echo "Cloning $dir repository..." # Print which repository is being cloned (API or APP)
    if (cd "$dir" && chmod +x clone.sh && ./clone.sh); then # attempt to cd into dir make clone.sh executable and run it
        # If can cd into the directory, make clone.sh executable, and run it successfully
        echo "$dir cloned successfully" # Print success message for the specific repository
        return 0 # Return success (0 in bash means success)
    else
        # if attempt fails
        echo "Error cloning $dir" >&2 # Print error message to stderr (standard error)
        return 1 # Return failure (non-zero in bash=failure)
    fi
}

# Clone API and APP repositories in parallel as background processes(&)
clone_repo API & 
clone_repo APP &

echo "API and APP cloning started in parallel..." # Print message to indicate that cloning has started

# Wait for all background processes to finish
wait

# Check if both API and APP cloning were successful
if [ $? -eq 0 ]; then # if last command's exit with success 
    # if succesfully(0) waited
    # If it's 0, it means all background processes (API and APP cloning) succeeded
    echo "API and APP cloned successfully"
else
    # If $? is non-zero, it means at least one of the background processes failed
    echo "Error occurred while cloning API or APP" >&2
    # >&2 redirects the output to stderr instead of stdout
    exit 1 # Exit the script with a failure status
fi

# Clone Desktop repository
if (cd Desktop && chmod +x clone.sh && ./clone.sh); then
    # If we can cd into Desktop, make clone.sh executable, and run it successfully
    echo "Desktop repository cloned successfully"
    echo "All repositories cloned successfully"
else
    # If any part of the Desktop cloning process fails
    echo "Error cloning Desktop repository" >&2
    exit 1 # Exit the script with a failure status
fi

```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### xcode-clone.sh

This Bash script will first define a function to bold the format of subsequent echos later in the script.

Next, it will go into VidBriefs/APP and clone the vidbriefs-app repo; it gets the full path of the .env file to be copied to the OPENAI_API_KEY env variable that gets put into the Xcode scheme_file for the project. It uses xmlstarlet to modify the value of the environment variable in the Xcode scheme file. It will then check if the change was successful; if it was, it will print a success message and exit the script with success(0); if the if statement is not true, it will print an error message and exit the script with failure(1).


```

#!/bin/bash

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "${BOLD}$1${NORMAL}"
}

cd APP

# Clone the repository
git clone https://github.com/alfie-ns/vidbriefs-app # Replace <your-repo-url> with the actual repository URL

# Path to the .env file outside the cloned repo
ENV_FILE="/Users/oladeanio/Library/CloudStorage/GoogleDrive-alfienurse@gmail.com/My Drive/Dev/VidBriefs/APP/.env"

# Navigate to the cloned repository directory
cd vidbriefs-app

# Path to the xcscheme file
SCHEME_FILE="VidBriefs-Final.xcodeproj/xcshareddata/xcschemes/VidBriefs-Final.xcscheme"

# Check if the .env file exists
if [ ! -f "$ENV_FILE" ]; then
  echo ".env file not found."
  exit 1
fi

# Read the API key from the .env file
OPENAI_API_KEY=$(grep -E '^OPENAI_API_KEY=' "$ENV_FILE" | cut -d '=' -f 2)

if [ -z "$OPENAI_API_KEY" ]; then
  echo "API key not found in .env file."
  exit 1
fi

# Backup the original scheme file
cp "$SCHEME_FILE" "${SCHEME_FILE}.bak"

# Use xmlstarlet to modify the environment variable value
xmlstarlet ed -L -u '//EnvironmentVariable[@key="openai-apikey"]/@value' -v "$OPENAI_API_KEY" "$SCHEME_FILE"

# Verify the change
if grep -q "value=\"$OPENAI_API_KEY\"" "$SCHEME_FILE"; then
    print_bold "openai-apikey has been set to $OPENAI_API_KEY in the Xcode scheme"
    exit 0
else
    echo "Failed to set openai-apikey in the Xcode scheme"
    exit 1
fi

# Open the API key page in Google Chrome
open -a "Google Chrome" "https://platform.openai.com/api-keys"
print_bold "Enter API key into: vidbriefs-app/VidBriefs-Final.xcodeproj/xcshareddata/xcschemes/VidBriefs-Final.xcscheme"

```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### pbd.sh

This script will first define a function to handle errors, then it will check if push.sh exists and is executable; if it is, it will execute it. If it succeeds, it will print a success message and delete the local repository; if it fails, it will print an error message and exit the script before deleting the local repository. The `-euo pipefail` options mean:

- `-e`: Exit immediately if a command exits with a non-zero status. This ensures that any error in the script stops execution immediately, preventing subsequent commands from running and potentially causing more issues.
- `-u`: Treat unset variables as an error and exit immediately. This prevents the script from continuing with uninitialised variables, which could lead to unexpected behaviour or difficult-to-debug errors.
- `-o pipefail`: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status. This makes sure that any failure in a sequence of piped commands is caught, ensuring that the script doesn't inadvertently ignore errors in complex command chains. 

These options are set to ensure robustness and reliability, making the script terminate promptly on encountering errors, thereby maintaining a clean and predictable execution flow.

```
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
if ./push.sh; then
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

```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### scripts/
#### run-migrations.sh
#### setup-db.sh
#### start-server.sh
...
<!-- ---------------------------------------------------------------------------------------------------------------------->

### db-management.sh
...
---

# Python Scripts

---

# Apple Scripts
