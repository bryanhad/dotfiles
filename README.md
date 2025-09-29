# My Dotfiles Setup

My custom setup for `bash`, `tmux`, `Fastfetch`, and `Starship` using `GNU Stow`.

## Quick Start
```bash
git clone <repo-url> ~/dotfiles-repo
cd ~/dotfiles-repo
./setup.sh
```

The script will:
- Install missing packages: stow, tmux, fastfetch, starship, zoxide.
    -  fastfetch → installed via .deb (apt-compatible)
    -  starship → installed via curl (binary to ~/.local/bin)
    -  zoxide → installed via curl (binary to ~/.local/bin, manpages to ~/.local/share/man)
- Backup existing dotfiles (.bashrc, .tmux.conf, Fastfetch & Starship configs).
- Symlink dotfiles into your home directory via GNU Stow.
- Copy Fastfetch ASCII art to ~/ascii.
- Update your .bashrc with:
    -  PATH="$HOME/.local/bin:$PATH" so local binaries are picked up
    -  Initialization of Starship + Zoxide
    -  Conditional Fastfetch + tmux auto-start

### tmux Customizations

- Changed default prefix key from `Ctrl+b` to `` ` `` (backtick).
- Mouse support enabled for sanity.
- Scrollback increased to 10,000 lines (default 2,000).
- Vim key bindings enabled in scrollmode
- Pane borders customized (cool looking).
- 1-based indexing for windows and panes (default starts at 0).
- Minimalist status bar (cool looking).

## Undo Setup
To completely revert changes:
```bash
./undo.sh
```
The script will:
- Remove symlinks created by Stow.
- Restore backed-up configs (.bashrc, .tmux.conf, Starship & Fastfetch configs).
- Uninstall packages:
    - Removes fastfetch, tmux, and stow via apt remove --purge.
    - Removes starship binary from ~/.local/bin.
    - Removes zoxide binary from ~/.local/bin and its manpages if present.
- Restart your shell (exec bash) so the clean .bashrc is loaded immediately.

### Notes
1. Starship and Zoxide are installed locally (~/.local/bin). If you want system-wide install, you can adjust the setup script.
2. If you run into `stow` warnings like:
    ```bash
    BUG in find_stowed_path? Absolute/relative mismatch ...
    ```
    it usually means Stow is crossing into Windows-mounted directories under WSL. This can be safely ignored if your dotfiles are working as expected.