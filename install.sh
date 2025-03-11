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

# Generate default Fastfetch config (if missing)
if [ ! -f ~/.config/fastfetch/config.jsonc ]; then
    echo "Generating default Fastfetch config..."
    fastfetch --gen-config
fi

# Ensure Fastfetch config directory exists
mkdir -p ~/.config/fastfetch

# Replace the default config with the custom one
echo "Applying custom Fastfetch config..."
ln -sf ~/dotfiles/fastfetch_config.jsonc ~/.config/fastfetch/config.jsonc

# Symlink Bash configuration files
ln -sf ~/dotfiles/bashrc ~/.bashrc

# Apply changes
source ~/.bashrc

echo "Dotfiles setup complete!"
