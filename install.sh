#!/bin/bash

set -e

# Helper functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install dependencies with brew
    brew install neovim tmux git curl
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    apt-get purge --auto-remove neovim
    apt install -y tmux curl build-essential --fix-missing

    apt update && apt upgrade -y
    add-apt-repository ppa:deadsnakes/ppa
    apt update
    apt install -y python3.10 npm unzip ripgrep python3.10-venv --fix-missing

    # not sure if these are necessary, also how to dynamically know default sys py version?
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2

    wget -c https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar xzf nvim-linux-x86_64.tar.gz
    mv nvim-linux-x86_64 /usr/local/nvim
    ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim
fi

# Create config directories
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim
mkdir -p ~/.tmux/plugins

# Backup existing configs
if [ -f ~/.config/nvim/init.lua ]; then
    echo "Backing up existing neovim config..."
    mv ~/.config/nvim{,.bak}
fi

if [ -f ~/.tmux.conf ]; then
    echo "Backing up existing tmux config..."
    mv ~/.tmux.conf{,.bak}
fi

# Install TPM
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create symlinks
echo "Creating symlinks..."
# Remove existing nvim config directory if it exists
rm -rf ~/.config/nvim
# Create the symlink for nvim config
ln -sf "$(pwd)/nvim" ~/.config/nvim
ln -sf "$(pwd)/tmux/.tmux.conf" ~/.tmux.conf

# Install plugins
echo "Installing plugins..."
# Install neovim plugins (lazy.nvim will handle this on first launch)
nvim --headless "+Lazy! sync" +qa

# Install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

echo "Installation complete! Please restart your terminal."
