#!/usr/bin/env bash

# makes the script exit if something fails
set -euo pipefail

# Directory where this script lives (the repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import
source "${SCRIPT_DIR}/scripts/install.sh"
source "${SCRIPT_DIR}/scripts/helpers.sh"

# packages to be installed
PACKAGES=("${APT_PACKAGES[@]}" "${CURL_PACKAGES[@]}")

if ! command -v apt &> /dev/null; then
    echo "❌ Error: apt not available. Please install ${PACKAGES[*]} manually."
    exit 1
fi

sudo apt update

for pkg in "${PACKAGES[@]}"; do
    # if package is already isntalled, continue
    if command -v "${pkg}" &> /dev/null; then
        echo "✅ ${pkg} already installed."
        continue
    fi

    case "${pkg}" in
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
            echo "📦 Installing ${pkg} via apt..."
            sudo apt install -y "${pkg}"
            echo "✅ ${pkg} installed successfully"
            ;;
    esac
done

# backup existing config files/dir if it already exists 
backup_if_exists "${HOME}/.bashrc"
backup_if_exists "${HOME}/.config/fastfetch/config.jsonc"
backup_if_exists "${HOME}/.config/starship.toml"
backup_if_exists "${HOME}/.tmux.conf"

add_symlinks

handle_fastfetch_ascii_art

echo "✅ Dotfiles setup complete!"

# Reload shell
exec bash