#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KEEP_PACKAGES=false

# Argument parsing
for arg in "$@"; do
    case $arg in
        --keep-installed-packages|--keep-pkgs)
            KEEP_PACKAGES=true
            ;;
        *)
            echo "❌ Unknown option: $arg"
            echo "Usage: $0 [--keep-installed-packages | --keep-pkgs]"
            exit 1
            ;;
    esac
done

# Import
source "${SCRIPT_DIR}/scripts/remove.sh"
source "${SCRIPT_DIR}/scripts/helpers.sh"

remove_symlinks

# Restore backups
restore_backup_if_exists "${HOME}/.bashrc"
restore_backup_if_exists "${HOME}/.tmux.conf"
restore_backup_if_exists "${HOME}/.config/starship.toml"
restore_backup_if_exists "${HOME}/.config/fastfetch/config.jsonc"

# Remove packages and binaries
if [ "$KEEP_PACKAGES" = false ]; then
    remove_apt_packages
    remove_starship_bin
    remove_zoxide_bin
fi

echo "✅ Undo complete"

# Reload shell
exec bash