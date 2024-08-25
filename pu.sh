#!/bin/bash
# vidbriefs-app/pu.sh

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "\n${BOLD}$1${NORMAL}\n"
}

if git add . && git commit -m 'update'; then
  git push origin main
  print_bold "PUSHED TO GIT"
else
  print_bold "FAILED TO PUSH TO GIT"
fi
