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

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "${BOLD}$1${NORMAL}"
}

# Function to run clone script for a given directory
run_clone_script() {
  local dir=$1
  cd "$dir"
  if [ -f "clone.sh" ]; then
    print_bold "Running clone script for $dir..."
    echo "" # padding
    bash clone.sh # run the clone script
  else
    echo "$dir/clone.sh not found."
    return 1
  fi
  cd .. # back to VidBriefs directory for the next iteration
}

# Main execution
echo "" # padding
print_bold "Cloning repositories in parallel..." # print bold text
echo "" # padding

#echo "" # padding

# Clone APP and API in parallel(& means run in background)
run_clone_script "APP" & run_clone_script "API" &
wait # wait for the background processes to finish

echo "" # padding

# Clone Desktop
echo "" # padding
run_clone_script "Desktop"
echo "" # padding

echo "" # padding
print_bold "All repositories cloned successfully!"
echo "" # padding

```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### APP/clone.sh/vidbriefs-app

This Bash script will first define a function to bold the format of subsequent echos later in the script.

Next, it will go into VidBriefs/APP and clone the vidbriefs-app repo; it gets the full path of the .env file to be copied to the OPENAI_API_KEY env variable that gets put into the Xcode scheme_file for the project. It uses [xmlstarlet](http://xmlstar.sourceforge.net/) to modify the value of the environment variable in the Xcode scheme file. It will then check if the change was successful; if it was, it will print a success message and exit the script with success(0); if the if statement is not true, it will print an error message and exit the script with failure(1).


```
#!/bin/bash

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "${BOLD}$1${NORMAL}"
}

# Clone the repository
git clone https://github.com/alfie-ns/vidbriefs-app

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

# Use xmlstarlet to modify the environment variable value
xmlstarlet ed -L -u '//EnvironmentVariable[@key="openai-apikey"]/@value' -v "$OPENAI_API_KEY" "$SCHEME_FILE"

# Verify the change
if grep -q "value=\"$OPENAI_API_KEY\"" "$SCHEME_FILE"; then
    echo ""
    print_bold "openai-apikey has been set to $OPENAI_API_KEY in the Xcode scheme"
    echo ""
    exit 0
else
    echo "Failed to set openai-apikey in the Xcode scheme"
    exit 1
fi

```

### pu.sh


```

script to push local changes to global repo

#!/bin/bash
# alfie-ns.github.io/push.sh

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "\n${BOLD}$1${NORMAL}\n"
}

git add .
git commit -m "update"
git push origin main

print_bold "PUSHED TO GIT"
...
OUTPUT:
-------
main 7a4d40e] update
 2 files changed, 27 insertions(+), 1 deletion(-)
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 11 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 510 bytes | 510.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To https://github.com/alfie-ns/alfie-ns.github.io
   a41162e..7a4d40e  main -> main 
***PUSHED TO GIT***
```
```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### alfie-ns.github.io/pbd.sh

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

### vidbriefs-api/scripts
#### run-migrations.sh
#### setup-db.sh
#### start-server.sh

### API/clone.sh/vidbriefs-api

```
#!/bin/bash

# Find the next available number for multiple directories
base_name="vidbriefs-api"
I=1 # init as 1
while [ -d "${base_name}-${I}" ]; do # while directory exist
  I=$((I + 1)) # increment I
done # end of while loop
new_name="${base_name}-${I}" # new directory name = base_name - I

# Clone the repository into the new directory, init into new_name variable
git clone https://github.com/alfie-ns/vidbriefs-api "$new_name"

# Change directory to the cloned repository
cd "$new_name"

# Copy the .env file - 
cp ../.env .
# backout 1 directory -> copy .env -> paste in current directory the cp command is executed in

echo "Repository cloned as $new_name and .env file copied."
```

...
<!-- ---------------------------------------------------------------------------------------------------------------------->

### db-management.sh

---



---

# Python Scripts

---

# Apple Scripts
