install_fastfetch() {
    # Your system architecture
    local arch="amd64"

    local version="2.53.0"
    local url="https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/fastfetch-linux-${arch}.deb"
    local deb_file="/tmp/fastfetch-linux-${arch}.deb"

    echo "📦 Installing fastfetch..."

    # Download .deb to /tmp (temporary directory)
    wget -q -O "${deb_file}" "${url}"

    # Install using apt (resolves dependencies automatically)
    sudo apt install -y "${deb_file}"

    # Clean up
    rm -f "${deb_file}"

    # ensures the fastfetch config exists
    if [ ! -f "${HOME}/.config/fastfetch/config.jsonc" ]; then
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