#!/bin/bash
# Linux-specific setup (Debian/Ubuntu)

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing core packages..."
sudo apt-get install -y \
    tmux \
    git \
    curl \
    wget \
    stow \
    ripgrep \
    fzf \
    npm \
    python3 \
    python3-venv \
    zsh \
    build-essential \
    software-properties-common \
    unzip

# Neovim via PPA
echo "Installing Neovim..."
if ! command -v nvim &>/dev/null; then
    if sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        # Fallback: appimage
        echo "PPA unavailable, installing Neovim via appimage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi
fi

# JetBrains Mono Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    echo "Installing JetBrains Mono Nerd Font..."
    mkdir -p "$FONT_DIR"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    curl -fsSL "$FONT_URL" -o /tmp/JetBrainsMono.tar.xz
    tar -xf /tmp/JetBrainsMono.tar.xz -C "$FONT_DIR"
    rm /tmp/JetBrainsMono.tar.xz
    fc-cache -fv
fi
