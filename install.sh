#!/bin/bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# ── Validate location ──────────────────────────────────────────────
if [ "$(cd "$(dirname "$0")" && pwd)" != "$DOTFILES_DIR" ]; then
    echo "Error: This repo must live at $DOTFILES_DIR"
    echo "  ln -s $(cd "$(dirname "$0")" && pwd) $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR"

# ── OS-specific packages ───────────────────────────────────────────
if [[ "$OSTYPE" == darwin* ]]; then
    source "$DOTFILES_DIR/scripts/macos.sh"
elif [[ "$OSTYPE" == linux-gnu* ]]; then
    source "$DOTFILES_DIR/scripts/linux.sh"
fi

# ── Stow packages ─────────────────────────────────────────────────
echo "Stowing dotfiles..."
for pkg in nvim tmux zsh git; do
    stow --restow --target="$HOME" "$pkg"
    echo "  stowed $pkg"
done

# ── Oh My Zsh ──────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ── zsh-vi-mode plugin ────────────────────────────────────────────
ZVM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
if [ ! -d "$ZVM_DIR" ]; then
    echo "Installing zsh-vi-mode..."
    git clone https://github.com/jeffreytse/zsh-vi-mode "$ZVM_DIR"
fi

# ── TPM + tmux plugins ────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "Installing tmux plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# ── Local config templates ─────────────────────────────────────────
if [ ! -f "$HOME/.zshrc.local" ]; then
    cat > "$HOME/.zshrc.local" <<'EOF'
# Machine-specific shell config (not tracked in git)
# Examples:
# export GEMINI_API_KEY="..."
# export GOOGLE_CLOUD_PROJECT="..."
# export PATH="$PATH:$HOME/.pulumi/bin"
EOF
    echo "Created ~/.zshrc.local template"
fi

if [ ! -f "$HOME/.gitconfig-local" ]; then
    cat > "$HOME/.gitconfig-local" <<'EOF'
# Machine-specific git config (not tracked in git)
# Examples:
# [includeIf "gitdir:~/work/"]
#     path = ~/.gitconfig-work
EOF
    echo "Created ~/.gitconfig-local template"
fi

# ── Default shell ──────────────────────────────────────────────────
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "Changing default shell to zsh..."
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
fi

echo ""
echo "Done! Restart your terminal or run: exec zsh"
