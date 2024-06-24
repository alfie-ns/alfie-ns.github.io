**the scripts.md page will do the following:**

- [ ] get picture of scripts on desktop
- [ ] Get all bash scripts made on my mac
- [ ] Make more python scripts
- [ ] get all pygames from mac and dell
- [ ] make more pygames

# Bash Scripts

I use bash-scripts to automate nearly everything on my mac, particularty for git and vscode...elaborate [ ]

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

---

# Python Scripts

---

# Apple Scripts
