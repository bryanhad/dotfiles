#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure stow is installed
if ! command -v stow &> /dev/null; then
    if command -v apt &> /dev/null; then
        echo "Installing stow..."
        sudo apt update && sudo apt install -y stow
    else
        echo "Error: stow not installed and apt not available. Please install stow manually."
        exit 1
    fi
fi

# backup existing .bashrc if it already exists 
EXISTING_BASHRC="$HOME/.bashrc"
if [ -f "$EXISTING_BASHRC" ] && [ ! -L "$EXISTING_BASHRC" ]; then
    echo "Backing up existing $EXISTING_BASHRC"
    mv "$EXISTING_BASHRC" "$EXISTING_BASHRC.backup"
fi

# Go into the dotfiles directory in ~
cd "$SCRIPT_DIR"

# Loop through each subdirectory (bash, fastfetch, starship, …) and stow it
for dir in */; do
    # only run stow if $dir is a directory
    if [ -d "$dir" ]; then
        echo "Stowing $dir..."
        stow --restow --verbose --target="$HOME" "$dir"
    fi
done

# Ensure ~/ascii directory exists
mkdir -p "$HOME/ascii"

# Path to ascii art files
ASCII_SRC="$SCRIPT_DIR/fastfetch-art.txt"
ASCII_DEST="$HOME/ascii/fastfetch-art.txt"

# If the ascii art file doesn't exist in ~, copy it from repo
if [ ! -f "$ASCII_DEST" ]; then
    if [ -f "$ASCII_SRC" ]; then
        cp "$ASCII_SRC" "$ASCII_DEST"
        echo "Added default fastfetch ASCII art to $ASCII_DEST"
    else
        echo "No ASCII art source file found at $ASCII_SRC, skipping..."
    fi
else
    echo "ASCII art already exists at $ASCII_DEST, skipping copy."
fi


echo "✅ Dotfiles setup complete!"