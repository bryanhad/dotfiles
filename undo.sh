#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Handle restoring backups
restore_backup_if_exists() {
    local original="$1"
    local backup="${original}.backup"

    if [ -f "$backup" ] || [ -d "$backup" ]; then
        echo "🔄 Restoring $backup -> $original"
        rm -rf "$original"  # remove symlink or leftover
        mv "$backup" "$original"
    else
        echo "⚠️ No backup found for $original"
    fi
}


# Remove symlinks created by stow
if command -v stow &> /dev/null; then
    cd "$HOME"
    for dir in bash starship fastfetch tmux; do
        stow -D --dir="$SCRIPT_DIR" --target="$HOME" "$dir" || true
        echo "🗑️ Removed $dir symlink"
    done
fi

# Restore backups
restore_backup_if_exists "$HOME/.bashrc"
restore_backup_if_exists "$HOME/.tmux.conf"
restore_backup_if_exists "$HOME/.config/starship.toml"
restore_backup_if_exists "$HOME/.config/fastfetch/config.jsonc"

# Remove apt packages
sudo apt remove --purge -y fastfetch tmux stow || true
echo "🗑️ Successfully uninstalled fastfetch, tmux, and stow"

# Remove starship (local install -> /usr/local/bin)
if [ -f "$HOME/.local/bin/starship" ]; then
    rm -f "$HOME/.local/bin/starship"
    echo "🗑️ Removed starship binary from ~/.local/bin"
fi

# Remove zoxide (curl install -> ~/.local/bin + manpages)
if [ -f "$HOME/.local/bin/zoxide" ]; then
    rm -f "$HOME/.local/bin/zoxide"

    if [ -d "$HOME/.local/share/man/man1" ] && ls "$HOME/.local/share/man/man1/zoxide"*.1 &>/dev/null; then
        rm -f "$HOME/.local/share/man/man1/zoxide"*.1
        echo "🗑️ Removed zoxide binary from ~/.local/bin & deleted zoxide manpages"
    else
        echo "🗑️ Removed zoxide binary from ~/.local/bin"
    fi
fi

echo "✅ Undo complete"
exec bash