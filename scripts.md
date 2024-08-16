---
layout: archive
author_profile: true
header:
  overlay_image: /assets/splash/header.png
title: "Scripts"
---
<!--**the scripts.md page will do the following:**

- [ ] get picture of scripts on desktop
- [X] Get all bash scripts made on my mac
- [ ] Make more python scripts
- [ ] get all pygames from mac and dell
- [ ] make more pygames
-->

<!-----------------------------------------------------------------------------------
------------------------------------->

I'm a keen enthusiast of `<a href="#python-scripts" style="color: #448c88">`Python `</a>` and `<a href="#bash-scripts" style="color: #448c88">`Bash `</a>` scripting. I utilise Python for effective, easy-to-use programs, Data Science and nearly everything I develop in the backend, whilst Bash is my go-to for automation on my Mac
Below are some of the scripts I've written for various projects and tasks.

---

# Windows batch scripts

**...**

# Python Scripts

### VidBriefs/APP/vidbriefs-desktop/youtube.py

This `<a href="https://github.com/alfie-ns/vidbriefs-desktop" style="color: #448c88"  target="_blank">`Python script `</a>` utilises OpenAI's GPT-4o-mini and Anthropic's Claude-3-sonnet-20240229 to analyse YouTube video transcripts and generate markdown files with insights. Features include:

- **AI Model Options**: Choose between GPT-4o-mini and Claude-3-sonnet-20240229
- **Customizable AI Personality**: Adjust the AI's approach to suit your preferences
- **YouTube Integration**: Analyse videos by inputting their URL
- **Interactive Querying**: Ask questions about the video content
- **Transcript Processing**: Handles longer transcripts by splitting them into sections
- **Markdown File Creation**: Generates formatted files from AI responses when applicable
- **Personality Customization**: Select from various traits and intensities to tailor the AI's communication style

This tool can be useful for content analysis, research, and extracting information from YouTube videos in a  fast structured format personalised to
the user.

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*- 

# Dependencies ------------------------------------------------------------------
import sys, os, re, time # system operations, regular expressions, time
from dotenv import load_dotenv # for loading environment variables from .env file

# --------------AI APIS---------------- 

from openai import OpenAI
import anthropic

# --------------YouTube Transcripts----------------

from youtube_transcript_api import YouTubeTranscriptApi
from urllib.parse import urlparse, parse_qs

# --------------formatting dependencies----------------

import textwrap # for text formatting
import datetime # for timestamping files
import tiktoken # for tokenizing text
import argparse # for command-line arguments

# ------------------------------------------------------------------------------
# vidbriefs-desktop.py 🟣 -------------------------------------------------------
# -------------------------------------initialisation---------------------------

# Load environment variables from .env file
load_dotenv()

# Get OpenAI API key from environment variables
openai_api_key = os.getenv("OPENAI_API_KEY")
claude_api_key = os.getenv("ANTHROPIC_API_KEY")
# || api_key = "sk-...""

# Initialise OpenAI client
openai_client = OpenAI(api_key=openai_api_key)
claude_client = anthropic.Anthropic(api_key=claude_api_key)

# --------------------------------------------------------------------------------
# Formatting Functions 🟨 --------------------------------------------------------
# --------------------------------------------------------------------------------

# Check if running in a terminal that supports formatting
def supports_formatting():
    return sys.stdout.isatty()
           #sys.stdout.isatty() returns True if the file descriptor allows formatting

# Formatting functions --------------------------------------------------------
def format_text(text, format_code):
    if supports_formatting():
        return f"\033[{format_code}m{text}\033[0m"
    return text

def bold(text):
    return format_text(text, "1")

def blue(text):
    return format_text(text, "34")

def red(text):
    return format_text(text, "31")

def green(text):
    return format_text(text, "32")

# --------------------------------------------------------------------------------
# General Functions 🟩 -----------------------------------------------------------
# --------------------------------------------------------------------------------

# AI Communication Functions -----------------------------------------------------
def chat_with_ai(messages, personality, ai_model, youtube_link):
    system_message = f"""You are a highly knowledgeable and articulate assistant with a {personality} personality.
    Your primary goal is to provide comprehensive, well-structured, and educational responses.
  
    When responding:
    1. Always provide detailed, multi-section responses with clear headings and subheadings.
    2. Use markdown formatting to enhance readability (e.g., # for main headings, ## for subheadings, * for bullet points).
    3. Include relevant examples, analogies, or case studies to illustrate complex concepts.
    4. Summarize key points at the end of each major section.
    5. Suggest practical applications or exercises for the user to reinforce their understanding.
    6. When appropriate, include a "Further Reading" section with relevant resources.
    7. Always reference the video using this exact link: {youtube_link}. Do not generate or use any placeholder or example links.
  
    Remember to maintain a balance between being informative and engaging, adapting your tone to match the {personality} style."""
  
    instruction = f"You will assist the user with their question about the video and generate markdown files. When referencing the video, always use this exact link: {youtube_link}. Do not generate or use any placeholder or example links."
  
  
    # [ ] Create functionality to give user option for how much tokens to use

    if ai_model == "gpt":
        try: # try to communicate with GPT-4o-mini
            messages.insert(0, {"role": "system", "content": system_message, "role": "system", "content": instruction})
            response = openai_client.chat.completions.create(
                model="gpt-4o-mini",
                messages=messages
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"Error communicating with GPT: {str(e)}"
    elif ai_model == "claude":
        try:
            claude_messages = [
                {"role": "user", "content": messages[-1]['content']}
            ]
            response = claude_client.messages.create(
                model="claude-3-sonnet-20240229",
                max_tokens=450,
                system=system_message,
                messages=claude_messages
            )
            return response.content[0].text
        except Exception as e:
            return f"Error communicating with Claude: {str(e)}"
    else:
        return "Invalid AI model selected."

def process_transcript(chunks, query, personality, ai_model):
    """Process the transcript, either as a whole or in chunks."""
    if len(chunks) == 1:
        # Process the entire transcript at once
        full_query = f"Based on this transcript, {query}\n\nTranscript:\n{chunks[0]}"
        return chat_with_ai([{"role": "user", "content": full_query}], personality, ai_model)
    else:
        # Process in chunks
        combined_response = ""
        for i, chunk in enumerate(chunks):
            chunk_query = f"Based on this part of the transcript, {query}\n\nTranscript part {i+1}:\n{chunk}"
            chunk_response = chat_with_ai([{"role": "user", "content": chunk_query}], personality, ai_model)
            combined_response += f"\n\nInsights from part {i+1}:\n{chunk_response}"
        return combined_response  

# Transcript Processing Functions -------------------------------------------------
def num_tokens_from_string(string: str, encoding_name: str = "cl100k_base") -> int:
    """Returns the number of tokens in a text string."""
    encoding = tiktoken.get_encoding(encoding_name)
    num_tokens = len(encoding.encode(string))
    return num_tokens 

def split_transcript(transcript, max_tokens=125000):
    """Split the transcript into chunks if it exceeds max_tokens."""
    if num_tokens_from_string(transcript) <= max_tokens:
        return [transcript]  # Return the entire transcript as a single chunk

    words = transcript.split()
    chunks = []
    current_chunk = []
    current_count = 0

    for word in words:
        word_tokens = num_tokens_from_string(word)
        if current_count + word_tokens > max_tokens:
            chunks.append(' '.join(current_chunk))
            current_chunk = []
            current_count = 0
        current_chunk.append(word)
        current_count += word_tokens

    if current_chunk:
        chunks.append(' '.join(current_chunk))

    return chunks

def get_transcript(url):
    '''
    Extract video ID from YouTube URL:
    For youtu.be links: use the last part of the URL after '/'
    For full URLs: parse query string and get 'v' parameter
    Falls back to None if 'v' parameter is not found
    '''
    video_id = url.split('/')[-1] if 'youtu.be' in url else parse_qs(urlparse(url).query).get('v', [None])[0]


    # url_split splits the URL by '/' and takes the last part, which is the video ID.
    # if url is a youtu.be link, it takes the last part of the URL.
    if not video_id:
        raise ValueError("No video ID found in URL")
  
    transcript = YouTubeTranscriptApi.get_transcript(video_id) # Get the transcript for the video
    sentences = [entry['text'] for entry in transcript] # Extract the text into a list of sentences
    return " ".join(sentences) # Join the sentences into a single string

# Text Styling and Markdown Functions ------------------------------------------------
def apply_markdown_styling(text):
    """
    Apply markdown-like styling to text.
    Converts text between double asterisks or colons to bold, removing the markers.
    """
    def replace_bold(match):
        return bold(match.group(1))
  
    # Replace text between double asterisks, removing the asterisks
    text = re.sub(r'\*\*([^*]+)\*\*', replace_bold, text)
  
    # Replace text between colons, removing the colons
    text = re.sub(r':([^:]+):', replace_bold, text)
  
    return text

def extract_markdown(text):
    """Extract markdown content from the text."""
    # Check if the text contains any Markdown-like formatting
    if re.search(r'(^|\n)#|\*\*|__|\[.*\]\(.*\)|\n-\s', text):
        return text  # Return the entire text if it contains Markdown formatting
    return None

def slugify(text):
    """
    Create a slug from the given text.
    """
    # Convert to lowercase
    text = text.lower()
    # Remove non-word characters (everything except numbers and letters)
    text = re.sub(r'[^\w\s-]', '', text)
    # Replace all spaces with hyphens
    text = re.sub(r'\s+', '-', text)
    return text

def generate_markdown_file(content, title, youtube_link):
    """Generate a Markdown file with the given content, title, and YouTube link in a 'Markdown' folder."""
    if not title or title.strip() == "":
        title = "Untitled Document"
  
    folder_name = "Markdown"
  
    # Create the folder if it doesn't exist
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)
  
    # Generate a slug for the filename
    slug = slugify(title)
  
    # Create a unique filename with a timestamp
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"{slug}_{timestamp}.md"
  
    # Full path for the file
    file_path = os.path.join(folder_name, filename)
  
    # Write the content to the markdown file
    with open(file_path, 'w') as f:
        f.write(f"# {title}\n\n")
        f.write(content)
        f.write(f"\n\n---\n\n[Link to Video]({youtube_link})")
  
    return file_path

# ------------------------------------------------------------------------------
# Main 🟥 ----------------------------------------------------------------------
# ------------------------------------------------------------------------------
def main():
    while True:  # Outer loop for restart 'break' functionality
        os.system('clear')
        # ----------------- Main Program -----------------
        print(bold(blue("\nYoutube Transcript AI Assistant\n")))
    
        ai_model = input(bold("Choose your AI model (gpt/claude): ")).strip().lower() # Ask user to choose AI model, strip whitespace and convert to lowercase
        while ai_model not in ["gpt", "claude"]: # While ai not in the ...
            print(red("Invalid choice. Please enter 'gpt' or 'claude'."))
            ai_model = input(bold("Choose your AI model (gpt/claude): ")).strip().lower()

        # Personalise assistant ------------------------------------------------

        # dedent() removes leading whitespace from the text, thus allowing cleaner formatting
        personality_choice = input(bold(textwrap.dedent("""
            How would you like to personalise the assistant?
            (Feel free to describe the personality in your own words, or use the suggestions below)

            Learning Style Examples:
            - 🧠 ANALYTICAL: "HIGH 🧠 ANALYTICAL with MEDIUM 🔬 TECHNICAL focus"
            - 🎨 CREATIVE: "MEDIUM 🎨 CREATIVE with LOW 🌈 VISUAL emphasis"
            - 🗣️ PERSUASIVE: "BALANCED 🗣️ PERSUASIVE-🧠 LOGICAL approach"
            - 🌐 MULTIDISCIPLINARY: "HIGH 🌐 MULTIDISCIPLINARY with MEDIUM 🔗 CONTEXTUALIZING"
            - 📚 ACADEMIC: "HIGH 📚 ACADEMIC with LOW 🧪 EXPERIMENTAL style"
            - 🤔 SOCRATIC: "MEDIUM 🤔 SOCRATIC with HIGH 🔍 QUESTIONING focus"
            - 🤝 EMPATHETIC: "HIGH 🤝 EMPATHETIC with MEDIUM 👥 COLLABORATIVE approach"
            - 💡 INNOVATIVE: "BALANCED 💡 INNOVATIVE-🔬 TECHNICAL style"
            - 📊 DATA-DRIVEN: "HIGH 📊 DATA-DRIVEN with LOW 🖼️ CONCEPTUAL emphasis"
            - 🧩 PROBLEM-SOLVING: "MEDIUM 🧩 PROBLEM-SOLVING with HIGH 🔀 ADAPTIVE focus"

            Combine these or create your own to define the AI's learning style and personality.
            Remember, you can specify intensity levels (LOW, MEDIUM, HIGH, BALANCED) and combine
            traits.
                                                    
            BALANCED 🧠 ANALYTICAL-🎨 CREATIVE with HIGH 🌐 MULTIDISCIPLINARY focus.
            MEDIUM 🗣️ PERSUASIVE with LOW 🤔 SOCRATIC questioning.                                         
            HIGH 📊 DATA-DRIVEN and MEDIUM 🤝 EMPATHETIC approach
                                                    
            EXTENSIVE MARKDOWN FILE CREATOR  
            EXTENSIVE TRAVERSAL OF ALL VIDEO INSIGHTS

            Teacher                                  

            Your choice: """)))

        personality = personality_choice or "BALANCED 🧠 ANALYTICAL-🎨 CREATIVE with HIGH 🌐 MULTIDISCIPLINARY focus. MEDIUM 🗣️ PERSUASIVE with LOW 🤔 SOCRATIC questioning. HIGH 📊 DATA-DRIVEN and MEDIUM 🤝 EMPATHETIC approach."

        print(f"\nGreat! Your {ai_model.upper()} assistant will be", bold(personality))
        print("Paste a YouTube URL to start chatting about videos of your interest.")
        print("Type 'exit' to quit the program or 'restart' to start over.")

        messages = [] # init as empty list
        current_transcript = "" # init as empty string
        transcript_chunks = [] # init as empty list

        try: # Inner loop for conversation functionality
            current_youtube_link = ""  # Initialise YouTube link variable
            while True:
                user_input = input(bold("\nEnter a YouTube URL, your message, 'restart', or 'exit': ")).strip()

                if user_input.lower() == 'exit':
                    os.system('clear')
                    print("\nExiting...")
                    time.sleep(1.5)
                    os.system('clear')
                    sys.exit() 

                if user_input.lower() == "restart":
                    print(bold(green("Restarting the assistant...")))
                    break  # Break the inner loop to restart

                if 'youtube.com' in user_input or 'youtu.be' in user_input:
                    current_youtube_link = user_input  # Store the YouTube link
                    try:
                        current_transcript = get_transcript(user_input)
                        transcript_chunks = split_transcript(current_transcript)
                        if len(transcript_chunks) > 1:
                            print(bold(green("New video transcript loaded and split into chunks due to its length. You can now ask questions about this video.")))
                        else:
                            print(bold(green("New video transcript loaded. You can now ask questions about this video.")))
                        messages = []  # Reset conversation history for new video
                    except Exception as e:
                        print(red(f"Error loading video transcript: {str(e)}"))
                        continue
                else:
                    if not current_transcript: # If transcript hasnt been initially loaded prior to conversation 
                        print(red("Please load a YouTube video first by pasting its URL."))
                        continue
                
                    # Add user message to conversation history
                    messages.append({"role": "user", "content": user_input})
                
                    # Process the transcript with the entire conversation history
                    full_query = f"Based on this transcript and our conversation so far, please respond to the latest message: {user_input}\n\nTranscript:\n{current_transcript}"
                    response = chat_with_ai(messages + [{"role": "user", "content": full_query}], personality, ai_model, current_youtube_link) # response = 
                
                    print(bold(red("\nAssistant: ")) + apply_markdown_styling(response))
                
                    # Add assistant's response to conversation history
                    messages.append({"role": "assistant", "content": response})

                    # Check for markdown content in the response
                    markdown_content = extract_markdown(response)
                    if markdown_content:
                        title_prompt = f"Generate a brief, concise title (5 words or less) for this content:\n\n{markdown_content[:200]}..."
                        title_response = chat_with_ai([{"role": "user", "content": title_prompt}], "concise", ai_model, current_youtube_link)
                    
                        file_path = generate_markdown_file(markdown_content, title_response, current_youtube_link)  # Pass the current YouTube link
                        print(green(f"\nMarkdown file generated: {file_path}\n"))
                    else:
                        print(blue("\nNo Markdown content detected in this response.\n"))

        except KeyboardInterrupt: # Handle Ctrl+C to exit the program
            os.system('clear')
            print("\nExiting...")
            time.sleep(1.75)
            os.system('clear')
            sys.exit()

if __name__ == "__main__": # Run the main function if the script is executed directly, not when imported as a module
    main()
```

---

<!--### VidBriefs/APP/vidbriefs-desktop/tedtalks.py-->

### VidBriefs/Desktop/vidbriefs-desktop/categorise-md.py

This Python script reorganises markdown files into categories based on their content. It uses OpenAI's GPT-4o-mini(cheapest model) to categorise the content into CompSci, Gaming, Health, Sports, or Other. The script reads the content of each markdown file, sends it to the AI model for categorisation, and moves the file to the corresponding category folder based on the AI's response. If the category folder does not exist, the file remains in the Markdown folder.

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, shutil
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Constants
CATEGORIES = [
    "CompSci", 
    "AI & Machine Learning",
    "Gaming",
    "Health & Medicine",
    "Fitness & Nutrition",
    "Neuroscience",
    "Sports",
    "Technology",
    "Politics & Current Events",
    "Economics & Finance",
    "History",
    "Investing",
    "Military & Defense",
    "Entertainment",
    "Science",
    "Mental Health",
    "Cybersecurity",
    "Environmental Science",
    "Social Issues",
    "Business & Entrepreneurship",
    "Education",
    "Travel",
    "Other"
]
MARKDOWN_DIR = "Markdown"
CATEGORIES_DIR = "Categories"

def categorise_with_ai(content):
    prompt = f"Categorise the following content into one of these categories: {', '.join(CATEGORIES)}. Respond with just the category name.\n\nContent: {content[:500]}..."
  
    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",  # Updated to a more recent model
            messages=[
                {"role": "system", "content": "You are a helpful assistant that categorises content into their respective categories."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=10
        )
        category = response.choices[0].message.content.strip()
        return category if category in CATEGORIES else "Other"
    except Exception as e:
        print(f"Error in AI categorization: {e}")
        return "Other"

def get_markdown_files():
    return [f for f in os.listdir(MARKDOWN_DIR) if f.endswith('.md')]

def read_markdown_content(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.read()

def move_file(source, destination):
    shutil.move(source, destination)

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    markdown_files = get_markdown_files()
  
    for file in markdown_files: # for each markdown file
        file_path = os.path.join(script_dir, MARKDOWN_DIR, file) # file path = 
        content = read_markdown_content(file_path) # read the content of the file
    
        category = categorise_with_ai(content) # categorise file into respective category
    
        destination_folder = os.path.join(script_dir, CATEGORIES_DIR, category)
        destination_path = os.path.join(destination_folder, file)
    
        if not os.path.exists(destination_folder):
            os.makedirs(destination_folder)
            print(f"\nCreated category folder: {destination_folder}\n")
    
        try: # try to move into respective category, catch error and print if exception
            move_file(file_path, destination_path)
            print(f"Moved {file} to {os.path.relpath(destination_path, script_dir)}")
        except Exception as e:
            print(f"Error moving {file}: {e}")

if __name__ == "__main__":
    main()
```

---

# Bash Scripts

<!--I use bash-scripts to automate nearly everything on my mac, particularty for git and vscode...elaborate [ ] -->

<!-- ---------------------------------------------------------------------------------------------------------------------->

### VidBriefs/clone-all.sh

```bash

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

#if ./clone-all.sh; then

#echo "" # padding

# Clone APP and API in parallel(& means run in background)
run_clone_script "APP" & run_clone_script "API" &
wait # wait for the background processes to finish

echo "" # padding
echo "" # padding
run_clone_script "Desktop" # Clone Desktop repo
echo "" # padding
print_bold "All repositories cloned successfully!"
echo "" # padding
```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### VidBriefs/clean-all.sh

```bash
#!/bin/bash

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "${BOLD}$1${NORMAL}"
}

print_bold "Starting clean-all.sh script..."

if ./push-all.sh; then
  print_bold "Push successful, cleaning up local repositories..."

  # Debugging information
  pwd
  
  print_bold "Removing API directory..."
  cd api || { print_bold "Failed to change directory to api"; exit 1; }
  pwd  # Print current directory
  rm -rf vidbriefs-api
  ls  # List files to verify deletion
  cd .. || { print_bold "Failed to change directory back from api"; exit 1; }
  
  print_bold "Removing APP directory..."
  cd app || { print_bold "Failed to change directory to app"; exit 1; }
  pwd  # Print current directory
  rm -rf vidbriefs-app
  ls  # List files to verify deletion
  cd .. || { print_bold "Failed to change directory back from app"; exit 1; }
  
  print_bold "Removing Desktop directory..."
  cd desktop || { print_bold "Failed to change directory to desktop"; exit 1; }
  pwd  # Print current directory
  rm -rf vidbriefs-desktop
  ls  # List files to verify deletion
  cd .. || { print_bold "Failed to change directory back from desktop"; exit 1; }
  
  print_bold "Local repositories cleaned."
else
  print_bold "Push failed, not cleaning up local repositories."
fi
```

### Vidbriefs/push-all.sh

```bash
#!/bin/bash

# Function to print bold text
print_bold() {
  BOLD=$(tput bold)
  NORMAL=$(tput sgr0)
  echo -e "${BOLD}$1${NORMAL}"
}

print_bold "Starting push-all.sh script..."

for dir in api/vidbriefs-api app/vidbriefs-app desktop/vidbriefs-desktop; do
  if [ -d "$dir" ]; then
    print_bold "Entering directory $dir..."
    cd $dir || { print_bold "Failed to change directory to $dir"; exit 1; }
  
    if [ -f ./pu.sh ]; then
      print_bold "Running pu.sh in $dir"
      ./pu.sh || { print_bold "pu.sh failed in $dir"; exit 1; }
    else
      print_bold "pu.sh not found in $dir"
      exit 1
    fi
  
    cd - || { print_bold "Failed to change directory back from $dir"; exit 1; }
  else
    print_bold "Directory $dir does not exist."
    exit 1
  fi
done

echo "All repositories pushed successfully"

: <<'EOF'
- 'dir' holds the directory name of the repository to be pushed
- for each directory in the list of directories (api, app, desktop)
- cd into the directory && push.sh && cd back to the root directory for the next iteration
EOF
```

---

<!-- ---------------------------------------------------------------------------------------------------------------------->

### VidBriefs/APP/clone.sh/

This Bash script will first define a function to bold the format of subsequent echo statements later in the script.

Next, it will navigate to VidBriefs/APP and clone the vidbriefs-app repository. It retrieves the full path of the .env file to be copied to the OPENAI_API_KEY environment variable, which is then inserted into the Xcode scheme file for the project. It uses `<a href="http://xmlstar.sourceforge.net/">`xmlstarlet `</a>` to modify the value of the environment variable in the Xcode scheme file. The script will then check if the change was successful; if it was, it will print a success message and exit the script with success(0). If the if statement is not true, it will print an error message and exit the script with failure(1).

```bash
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

---

### Function to run clone script for a given directory

```bash
run_clone_script() {
  local dir=$1 # dir = APP || API || Desktop
  cd "$dir" # change to respective directory
  if [ -f "clone.sh" ]; then # if clone .sh file exists
    print_bold "Running clone script for $dir...\n" # print bold text with padding
    bash clone.sh # run the clone script
  else
    echo "$dir/clone.sh not found."
    return 1
  fi
  cd .. # back to VidBriefs directory for the next iteration
}
```

---

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->

### pu.sh

```bash
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
```

```bash
-------
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
   
PUSHED TO GIT
```

---

### xcode.sh

```bash
#!/bin/bash
xed app/vidbriefs-app || { echo "Failed to open Xcode in app/vidbriefs-app"; exit 1; }

<<EOF
    try open Xcode in app/vidbriefs-app directory, 
    if fails -> print error message and exit with failure status.
EOF

```

<!-- ---------------------------------------------------------------------------------------------------------------------->

### alfie-ns.github.io/pbd.sh

This script will first define a function to handle errors, then it will check if push.sh exists and is executable; if it is, it will execute it. If it succeeds, it will print a success message and delete the local repository; if it fails, it will print an error message and exit the script before deleting the local repository. The `-euo pipefail` options mean:

- `-e`: Exit immediately if a command exits with a non-zero status. This ensures that any error in the script stops execution immediately, preventing subsequent commands from running and potentially causing more issues.
- `-u`: Treat unset variables as an error and exit immediately. This prevents the script from continuing with uninitialised variables, which could lead to unexpected behaviour or difficult-to-debug errors.
- `-o pipefail`: The return value of a pipeline is the status of the last command to exit with a non-zero status, or zero if no command exited with a non-zero status. This makes sure that any failure in a sequence of piped commands is caught, ensuring that the script doesn't inadvertently ignore errors in complex command chains.

These options are set to ensure robustness and reliability, making the script terminate promptly on encountering errors, thereby maintaining a clean and predictable execution flow.

```bash
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

---

<!-- ---------------------------------------------------------------------------------------------------------------------->

### VidBriefs/API/vidbriefs-api/scripts

In the process of initializing the API to run on a local machine, the following scripts are executed:

#### run-migrations.sh

This scripts handle the commands necessary to run the migrations for the API server.

```bash
#!/bin/bash

# Load environment variables
load_env() {
    if [ -f .env ]; then
        export $(grep -v '^#' .env | xargs)
    else
        echo ".env file not found."
        exit 1
    fi
}

load_env

# Activate virtual environment
source venv/bin/activate

# Run Django migrations
echo "Applying Django database migrations..."
python manage.py migrate

echo "Migrations complete."
```

#### setup-db.sh

This script setups up the database for the API server.

```bash
#!/bin/bash

# Function to load environment variables from .env file
load_env() {
    if [ -f .env ]; then
        while IFS='=' read -r key value; do
            if [[ $key && ! $key =~ ^# ]]; then
                # Remove leading/trailing spaces and quotes from the value
                value=$(echo "$value" | sed 's/^ *//; s/ *$//; s/^"//; s/"$//')
                # Export variable safely
                export "$key=$value"
            fi
        done < .env
    else
        echo ".env file not found."
        exit 1
    fi
}

# Load environment variables
load_env

# Ensure PostgreSQL service is running
if ! pg_isready -h $DB_HOST -p $DB_PORT > /dev/null 2>&1; then
    echo "Starting PostgreSQL service..."
    brew services start postgresql
fi

# Create the superuser role if not exists
psql -h $DB_HOST -p $DB_PORT -d template1 -U $(whoami) <<EOF
DO \$\$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles
        WHERE rolname = '$(whoami)') THEN
        CREATE ROLE "$(whoami)" WITH SUPERUSER LOGIN PASSWORD '$DB_PASSWORD';
    END IF;
END
\$\$;
EOF

# Create PostgreSQL role if it doesn't exist
psql -h $DB_HOST -p $DB_PORT -d template1 -U $(whoami) <<EOF
DO \$\$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_catalog.pg_roles
        WHERE rolname = '$DB_USER') THEN
        CREATE ROLE "$DB_USER" WITH LOGIN PASSWORD '$DB_PASSWORD';
        ALTER ROLE "$DB_USER" CREATEDB;
    END IF;
END
\$\$;
EOF

# Create the database if it doesn't exist
psql -h $DB_HOST -p $DB_PORT -d template1 -U $(whoami) -c "
SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q 1 || psql -h $DB_HOST -p $DB_PORT -d template1 -U $(whoami) -c "CREATE DATABASE \"$DB_NAME\" OWNER \"$DB_USER\";"

echo "Database setup complete."
```

#### start-server.sh

### VidBriefs/API/clone.sh/vidbriefs-api

```bash
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

---

<!-- ---------------------------------------------------------------------------------------------------------------------->

### db-management.sh

---

---

# Apple Scripts
