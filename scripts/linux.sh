#!/bin/bash
# Linux-specific setup (Debian/Ubuntu)

set -e

echo "Updating package lists..."
sudo apt-get update

echo "Installing core packages..."
sudo apt-get install -y --no-install-recommends \
    tmux \
    git \
    curl \
    wget \
    stow \
    ripgrep \
    fzf \
    python3 \
    python3-venv \
    zsh \
    build-essential \
    software-properties-common \
    unzip

# Node.js via NodeSource (for modern npm/node)
if ! command -v node &>/dev/null; then
    echo "Installing Node.js via NodeSource..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
    echo "Installing GitHub CLI..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
fi

# Neovim via PPA
echo "Installing Neovim..."
if ! command -v nvim &>/dev/null; then
    if sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        # Fallback: extract appimage (no FUSE required)
        echo "PPA unavailable, installing Neovim via appimage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract
        sudo rm -rf /opt/nvim
        sudo mv squashfs-root /opt/nvim
        sudo ln -sf /opt/nvim/usr/bin/nvim /usr/local/bin/nvim
        rm nvim.appimage
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
