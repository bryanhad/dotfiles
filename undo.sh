#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remove symlinks created by stow
cd "$HOME" || exit
if command -v stow &> /dev/null; then
    for dir in bash starship fastfetch tmux; do
        stow -D --dir="$SCRIPT_DIR" --target="$HOME" "$dir" || true
        echo "✅ Removed $dir symlink"
    done
fi

# Remove installed packages
sudo apt remove --purge -y fastfetch tmux stow || true
echo "✅ Uninstalled fastfetch, tmux, and stow"

# Remove starship stuff
rm -f "$HOME/.local/bin/starship"
rm -f "$HOME/.config/starship.toml"
rm -f "$HOME/.config/starship.toml.backup"

# Remove Fastfetch stuff
rm -rf "$HOME/.config/fastfetch"
rm -rf "$HOME/.config/fastfetch.backup"

# Remove bashrc and tmux stuff
rm -f "$HOME/.tmux.conf.backup"

echo "✅ Deleted starship, fastfetch, and tmux configs"

# Use bashrc backup config
mv "$HOME/.bashrc.backup" "$HOME/.bashrc"
echo "✅ Reset bashrc config"