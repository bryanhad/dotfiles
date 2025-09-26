# My Dotfiles Setup

My custom setup for `bash`, `tmux`, `Fastfetch`, and `Starship` using `GNU Stow`.

## Quick Start
```bash
git clone <repo-url> ~/dotfiles-repo
cd ~/dotfiles-repo
./setup.sh
```
The script will:
- Install missing packages: `stow`, `tmux`, `fastfetch`, `starship`.
- Backup existing dotfiles (.bashrc, .tmux.conf, Fastfetch & Starship configs).
- Symlink dotfiles into your home directory.
- Copy Fastfetch ASCII art to ~/ascii.

### Notes
> Tested on Ubuntu/Debian environments.<br> sudo is required for installing packages.
