APT_PACKAGES=(stow tmux fzf fastfetch)   # packages handled by apt
CURL_PACKAGES=(starship zoxide) # packages installed via curl

# Handle restoring backups
restore_backup_if_exists() {
    local original="$1"
    local backup="${original}.backup"

    if [ -e "${backup}" ]; then
        echo "🔄 Restoring ${backup} -> ${original}"
        rm -rf "${original}"  # remove symlink or leftover
        mv "${backup}" "${original}"

        # Clean up all timestamped backups
        rm -rf "${original}.backup-"*
    else
        echo "⚠️ No backup found for ${original}"
    fi
}

# Handle backups
backup_if_exists() {
    local absolute_path="$1"
    local suffix=".backup"
    local timestamp="$(date +%Y%m%d-%H%M%S)"

    # skip symlinks
    if [ -L "${absolute_path}" ]; then
        return
    fi

    if [[ -f "${absolute_path}" ||  -d "${absolute_path}" ]]; then
        local backup_path="${absolute_path}${suffix}"

        if [ -e "${backup_path}" ]; then
            # Already have a .backup -> append timestamp
            backup_path="${absolute_path}${suffix}-${timestamp}"
        fi

        echo "Backing up ${absolute_path} -> ${backup_path}"
        mv "${absolute_path}" "${backup_path}"
    fi
}

# handle fastfetch ASCII file
handle_fastfetch_ascii_art() {
    local ascii_src="${SCRIPT_DIR}/fastfetch-art.txt"
    local ascii_dest="${HOME}/ascii/fastfetch-art.txt"

    # Ensure ~/ascii directory exists
    mkdir -p "${HOME}/ascii"

    # If the ascii art file doesn't exist in ~, copy it from repo
    if [ ! -f "${ascii_dest}" ]; then
        if [ -f "${ascii_src}" ]; then
            cp "${ascii_src}" "${ascii_dest}"
            echo "✅ Added default fastfetch ASCII art to ${ascii_dest}"
        else
            echo "⚠️ No ASCII art source file found at ${ascii_src}, skipping..."
        fi
    else
        echo "⚠️ ASCII art already exists at ${ascii_dest}, skipping copy."
    fi
}

# Go into the dotfiles directory in ~
add_symlinks() {
    cd "${SCRIPT_DIR}"

    # Loop through each subdirectory (bash, fastfetch, starship, …) and stow it
    for dir in */; do
        # only run stow if $dir is a directory
        if [ -d "${dir}" ]; then
            echo "Stowing ${dir}..."
            stow --restow --dir="${SCRIPT_DIR}" --target="${HOME}" "${dir}"
        fi
    done
}