#!/bin/bash

echo "Starting dotfiles setup..."

# Install Fastfetch if it's not installed
if ! command -v fastfetch &> /dev/null; then
    echo "Installing Fastfetch..."
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
    sudo apt update
    sudo apt install fastfetch -y
else
    echo "Fastfetch is already installed!"
fi

# Symlink Bash configuration files
ln -sf ~/dotfiles/bashrc ~/.bashrc

# Apply changes
source ~/.bashrc

echo "Dotfiles setup complete!"
