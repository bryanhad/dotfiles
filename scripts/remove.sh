# Remove starship (local install -> /usr/local/bin)
remove_starship_bin() {
    if [ -f "${HOME}/.local/bin/starship" ]; then
        rm -f "${HOME}/.local/bin/starship"
        echo "🗑️ Removed starship binary from ~/.local/bin"
    fi
}

# Remove zoxide (curl install -> ~/.local/bin + manpages)
remove_zoxide_bin() {
    if [ -f "${HOME}/.local/bin/zoxide" ]; then
        rm -f "${HOME}/.local/bin/zoxide"

        if [ -d "${HOME}/.local/share/man/man1" ] && ls "${HOME}/.local/share/man/man1/zoxide"*.1 &>/dev/null; then
            rm -f "${HOME}/.local/share/man/man1/zoxide"*.1
            echo "🗑️ Removed zoxide binary from ~/.local/bin & deleted zoxide manpages"
        else
            echo "🗑️ Removed zoxide binary from ~/.local/bin"
        fi
    fi
}

# Remove apt packages
remove_apt_packages() {
    sudo apt remove --purge -y "${APT_PACKAGES[@]}" || true
    echo "🗑️ Successfully uninstalled ${APT_PACKAGES[*]} (if installed)"
}

DOTFILES=(bash starship fastfetch tmux)

# Remove symlinks created by stow
remove_symlinks() {
    if command -v stow &> /dev/null; then
        cd "${HOME}"
        for dir in "${DOTFILES[@]}"; do
            stow -D --dir="$SCRIPT_DIR" --target="${HOME}" "${dir}" || true
            echo "🗑️ Removed ${dir} symlink"
        done
    fi
}
