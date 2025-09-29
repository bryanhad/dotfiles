#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
# Path to ascii art files
ASCII_SRC="$SCRIPT_DIR/fastfetch-art.txt"
ASCII_DEST="$HOME/ascii/fastfetch-art.txt"

# packages to be installed
PACKAGES=(stow tmux fastfetch starship zoxide)

install_fastfetch() {
    # Your system architecture
    local arch="amd64"

    local version="2.53.0"
    local url="https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/fastfetch-linux-${arch}.deb"
    local deb_file="/tmp/fastfetch-linux-${arch}.deb"

    echo "📦 Installing fastfetch..."

    # Download .deb to /tmp (temporary directory)
    wget -q -O "$deb_file" "$url"

    # Install using apt (resolves dependencies automatically)
    sudo apt install -y "$deb_file"

    # Clean up
    rm -f "$deb_file"

    # ensures the fastfetch config exists
    if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        fastfetch --gen-config-full
    fi

    echo "✅ fastfetch installed successfully"
}

install_starship() {
    echo "📦 Installing starship..."
    # Install to ~/.local/bin
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
    echo "✅ starship installed successfully"
}

install_zoxide() {
    echo "📦 Installing zoxide..."
    # Install using curl
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    echo "✅ zoxide installed successfully"
}

backup_if_exists() {
    local absolute_path="$1"
    local suffix=".backup"

    # skip symlinks
    if [ -L "$absolute_path" ]; then
        return
    fi

    if [ -f "$absolute_path" ]; then
        echo "Backing up existing file $absolute_path"
        mv "$absolute_path" "$absolute_path$suffix"
    elif [ -d "$absolute_path" ]; then
        echo "Backing up existing directory $absolute_path"
        mv "$absolute_path" "$absolute_path$suffix"
    fi
}

handle_fastfetch_ascii_art() {
    # Ensure ~/ascii directory exists
    mkdir -p "$HOME/ascii"

    # If the ascii art file doesn't exist in ~, copy it from repo
    if [ ! -f "$ASCII_DEST" ]; then
        if [ -f "$ASCII_SRC" ]; then
            cp "$ASCII_SRC" "$ASCII_DEST"
            echo "✅ Added default fastfetch ASCII art to $ASCII_DEST"
        else
            echo "⚠️ No ASCII art source file found at $ASCII_SRC, skipping..."
        fi
    else
        echo "⚠️ ASCII art already exists at $ASCII_DEST, skipping copy."
    fi
}

if command -v apt &> /dev/null; then
    sudo apt update
    for pkg in "${PACKAGES[@]}"; do
        # if package is already isntalled, continue
        if command -v "$pkg" &> /dev/null; then
            echo "✅ $pkg already installed."
            continue
        fi

        case "$pkg" in
            fastfetch)
                install_fastfetch
                ;;
            starship)
                install_starship
                ;;
            zoxide)
                install_zoxide
                ;;
            *)
                echo "📦 Installing $pkg via apt..."
                sudo apt install -y "$pkg"
                echo "✅ $pkg installed successfully"
                ;;
        esac
    done
else
    echo "❌ Error: apt not available. Please install ${PACKAGES[*]} manually."
    exit 1
fi

# backup existing config files/dir if it already exists 
backup_if_exists "$HOME/.bashrc"
backup_if_exists "$HOME/.config/fastfetch/config.jsonc"
backup_if_exists "$HOME/.config/starship.toml"
backup_if_exists "$HOME/.tmux.conf"

# Go into the dotfiles directory in ~
cd "$SCRIPT_DIR"

# Loop through each subdirectory (bash, fastfetch, starship, …) and stow it
for dir in */; do
    # only run stow if $dir is a directory
    if [ -d "$dir" ]; then
        echo "Stowing $dir..."
        stow --restow --dir="$SCRIPT_DIR" --target="$HOME" "$dir"
    fi
done

handle_fastfetch_ascii_art


echo "✅ Dotfiles setup complete!"
exec bash