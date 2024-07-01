#!/bin/bash
# vidbriefs-app/push.sh

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "\n${BOLD}$1${NORMAL}\n"
}

git add .
git commit -m "update"
git push origin main

print_bold "PUSHED TO GITHUB"
