---
layout: archive
author_profile: true
header:
  overlay_image: /assets/splash/header.png
title: "Scripts"
permalink: /scripts/
---

I'm a keen enthusiast of <a href="#python-scripts" class="accent-link">Python</a> and <a href="#bash-scripts" class="accent-link">Bash</a> scripting. I utilise Python for effective, easy-to-use programs, Data Science and nearly everything I develop in the backend, whilst Bash is my go-to for automation on my Mac. I also use <a href="#windows-batch-scripts" class="accent-link">Windows Batch</a> scripts for various tasks on my Dell laptop.
Below are some of the scripts I've written for various projects and tasks.

<hr class="section-divider">

## Windows Batch Scripts

<div class="project-card" markdown="1">

### 1001-CW/q3/q3/run.bat

```batch
@echo off
g++ q3b.cpp -o q3 -O3 -lm
q3 .\q3-images\input_images\ .\q3-images\output_images
```

</div>

## Python Scripts

<div class="project-card" markdown="1">

### VidBriefs/APP/vidbriefs-desktop/youtube.py

This <a href="https://github.com/alfie-ns/vidbriefs-desktop" class="accent-link" target="_blank">Python script</a> utilises OpenAI's GPT-4o-mini and Anthropic's Claude-3-sonnet-20240229 to analyse YouTube video transcripts and generate markdown files with insights. Features include:

- **AI Model Options**: Choose between GPT-4o-mini and Claude-3-sonnet-20240229
- **Customisable AI Personality**: Adjust the AI's approach to suit your preferences
- **YouTube Integration**: Analyse videos by inputting their URL
- **Interactive Querying**: Ask questions about the video content
- **Transcript Processing**: Handles longer transcripts by splitting them into sections
- **Markdown File Creation**: Generates formatted files from AI responses when applicable
- **Personality Customisation**: Select from various traits and intensities to tailor the AI's communication style

This tool can be useful for content analysis, research, and extracting information from YouTube videos in a fast structured format personalised to the user.

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Dependencies
import sys, os, re, time
from dotenv import load_dotenv
from openai import OpenAI
import anthropic
from youtube_transcript_api import YouTubeTranscriptApi
from urllib.parse import urlparse, parse_qs
import textwrap, datetime, tiktoken, argparse

load_dotenv()

openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
claude_client = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))

def supports_formatting():
    return sys.stdout.isatty()

def format_text(text, format_code):
    if supports_formatting():
        return f"\033[{format_code}m{text}\033[0m"
    return text

def bold(text): return format_text(text, "1")
def blue(text): return format_text(text, "34")
def red(text): return format_text(text, "31")
def green(text): return format_text(text, "32")

def chat_with_ai(messages, personality, ai_model, youtube_link):
    system_message = f"""You are a highly knowledgeable assistant with a
    {personality} personality. Always reference the video using: {youtube_link}."""

    if ai_model == "gpt":
        try:
            messages.insert(0, {"role": "system", "content": system_message})
            response = openai_client.chat.completions.create(
                model="gpt-4o-mini", messages=messages
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"Error communicating with GPT: {str(e)}"
    elif ai_model == "claude":
        try:
            response = claude_client.messages.create(
                model="claude-3-sonnet-20240229", max_tokens=450,
                system=system_message,
                messages=[{"role": "user", "content": messages[-1]['content']}]
            )
            return response.content[0].text
        except Exception as e:
            return f"Error communicating with Claude: {str(e)}"

# ... (transcript processing, markdown generation, main loop)
```

</div>

<div class="project-card" markdown="1">

### VidBriefs/Desktop/categorise-md.py

This Python script reorganises markdown files into categories based on their content. It uses OpenAI's GPT-4o-mini to categorise the content and moves the file to the corresponding category folder.

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, shutil
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

CATEGORIES = [
    "CompSci", "AI & Machine Learning", "Gaming",
    "Health & Medicine", "Fitness & Nutrition", "Neuroscience",
    "Sports", "Technology", "Politics & Current Events",
    "Economics & Finance", "History", "Investing",
    "Military & Defense", "Entertainment", "Science",
    "Mental Health", "Cybersecurity", "Environmental Science",
    "Social Issues", "Business & Entrepreneurship",
    "Education", "Travel", "Other"
]

def categorise_with_ai(content):
    prompt = f"Categorise into: {', '.join(CATEGORIES)}. "
    prompt += f"Respond with just the category name.\n\nContent: {content[:500]}..."
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "system", "content": "You categorise content."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=10
        )
        category = response.choices[0].message.content.strip()
        return category if category in CATEGORIES else "Other"
    except Exception as e:
        return "Other"

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    for file in [f for f in os.listdir("Markdown") if f.endswith('.md')]:
        file_path = os.path.join(script_dir, "Markdown", file)
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        category = categorise_with_ai(content)
        dest = os.path.join(script_dir, "Categories", category)
        os.makedirs(dest, exist_ok=True)
        shutil.move(file_path, os.path.join(dest, file))
        print(f"Moved {file} to {category}")

if __name__ == "__main__":
    main()
```

</div>

<hr class="section-divider">

## Bash Scripts

<div class="project-card" markdown="1">

### Nexus-API/scripts/pu.sh

**Enhanced Git-Commit Importance** -- The script allows selective Git staging, customised importance levels, and local backup of the Categories/ and prompts/ directories.

```bash
#!/bin/bash
set -e

print_bold() { echo -e "\033[1m$1\033[0m"; }

get_commit_details() {
    local importance_text
    while true; do
        echo -n "Enter the importance (1-5): " >&2
        read -rsn1 importance; echo >&2
        case $importance in
            1) importance_text="Trivial"; break;;
            2) importance_text="Minor"; break;;
            3) importance_text="Moderate"; break;;
            4) importance_text="Significant"; break;;
            5) importance_text="Milestone"; break;;
            *) echo "Invalid input." >&2;;
        esac
    done
    echo -n "Enter a custom message: " >&2; read custom_message; echo >&2
    echo "${importance_text}: ${custom_message}"
}

selective_add() {
    print_bold "\nUnstaged changes:"
    git status --porcelain | grep -E '^\s*[\?M]' | sed 's/^...//'
    while true; do
        echo -n "Enter file to add, 'all' or 'done': "; read item
        if [ "$item" = "done" ]; then break
        elif [ "$item" = "all" ]; then git add . && break
        elif [ -e "$item" ]; then git add "$item"
        else echo "Not found."
        fi
    done
}

git rm -r --cached Categories/ 2>/dev/null || true
selective_add
commit_message=$(get_commit_details)
rsync -avh --update --delete "Categories/" "../../base/Categories/" &>/dev/null &
rsync -avh --update --delete "prompts/" "../../base/desktop-prompts/" &>/dev/null &
wait
git commit -m "$commit_message" && git push origin main
```

</div>

<div class="project-card" markdown="1">

### 1001-CW/q3a.sh

A compilation and image processing script -- checks the OS (macOS vs Linux), compiles the C++ program accordingly, then processes 3 random PGM image files through blur and edge detection.

```bash
#!/bin/bash

print_red() { tput setaf 1; echo -e "$1"; tput sgr0; }
print_green() { tput setaf 2; echo -e "$1"; tput sgr0; }
print_amber() { tput setaf 3; echo -e "$1"; tput sgr0; }

compile_success=false

if [[ "$OSTYPE" == "darwin"* ]]; then
    clang++ -std=c++11 -o q3_mac q3a-mac.cpp && \
        print_green "Compiled for macOS!" && compile_success=true && executable="./q3_mac"
else
    g++ -std=c++11 -o q3 q3a.cpp -lm && \
        print_green "Compiled for Linux!" && compile_success=true && executable="./q3"
fi

[ "$compile_success" = false ] && print_red "Compilation failed." && exit 1

images=()
while IFS= read -r file; do images+=("$file")
done < <(find "q3-images/input_images" -name "*.pgm" | sort -R | head -n 3)

[ ${#images[@]} -lt 3 ] && print_red "Not enough PGM files." && exit 1

for img in "${images[@]}"; do
    base=$(basename "$img" .pgm)
    print_amber "Processing $img..."
    $executable "$img" "q3-images/output_images/${base}_blurred.pgm" \
        "q3-images/output_images/${base}_edge_detected.pgm" && \
        print_green "Success!" || print_red "Failed."
done
```

</div>

<div class="project-card" markdown="1">

### VidBriefs/Desktop/run-desktop.sh

A menu-driven launcher for the VidBriefs-Desktop suite. Checks for a virtual environment, then presents options including the Enhanced AI Assistant (Nexus), YouTube and TED Talk analysis tools, and a markdown categorisation utility.

```bash
#!/bin/bash

trap 'clear; echo "Exiting..."; sleep 0.5; clear; exit 0' SIGINT
clear

if [[ -z "$VIRTUAL_ENV" ]]; then
    printf '\n%s\n' "$(tput bold)ERROR: Not in a virtual environment$(tput sgr0)"
    exit 1
fi

display_menu() {
    echo "╔══════════════════════════════════════════════╗"
    echo "║              VidBriefs-Desktop               ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║ 1. Enhanced AI Assistant (Nexus)             ║"
    echo "║ 2. YouTube Transcript AI Assistant           ║"
    echo "║ 3. TED Talk Analysis Assistant               ║"
    echo "║ 4. Sight Repo Assistant                      ║"
    echo "║ 5. Huberman.py                               ║"
    echo "║ 6. Categorise your insights                  ║"
    echo "╚══════════════════════════════════════════════╝"
}

while true; do
    display_menu
    read -rsn1 input
    case $input in
        1) python3 AI-Scripts/nexus.py ;;
        2) python3 AI-Scripts/youtube.py ;;
        3) python3 AI-Scripts/tedtalk.py ;;
        4) python3 AI-Scripts/sight.py ;;
        5) python3 AI-Scripts/huberman.py ;;
        6) python3 catergorise.py ;;
        *) echo "Invalid choice." ;;
    esac
    echo "Press Enter to continue..." && read && clear
done
```

</div>

<div class="project-card" markdown="1">

### alfie-ns.github.io/pbd.sh

A robust push-backup-delete script using strict error handling (`-euo pipefail`). Pushes to GitHub, then cleans up the local repository.

```bash
#!/bin/bash -euo pipefail

handle_error() {
    echo "Error: $2" >&2
    exit "$1"
}

[[ ! -f "./push.sh" ]] && handle_error 2 "push.sh is missing."
[[ ! -x "./push.sh" ]] && handle_error 3 "push.sh is not executable."

if ./push.sh; then
    echo "Pushed to GitHub; cleaning up..."
    cd .. && rm -rf alfie-ns.github.io
    cat <<'EOF'
-----------------------------------------
| Process complete                      |
|         _  __ _                       |
|   __ _ | |/ _(_) ___       _ __  ___  |
|  / _` || | |_| |/ _ \_____| '_ \/ __| |
| | (_| || |  _| |  __/_____| | | \__ \ |
|  \__,_||_|_| |_|\___|     |_| |_|___/ |
-----------------------------------------
EOF
else
    handle_error $? "push.sh failed."
fi
```

</div>

<hr class="section-divider">

## Apple Scripts

*Coming soon...*
