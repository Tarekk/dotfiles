# dotfiles

Personal Neovim + Tmux configuration managed with symlinks.

## Installation

```bash
git clone <repo-url> ~/Documents/dotfiles
cd ~/Documents/dotfiles
chmod +x install.sh
./install.sh
```

The install script handles:
- Installing dependencies (neovim, tmux, git, curl) via Homebrew (macOS) or apt (Linux)
- Backing up existing configs
- Symlinking `nvim/` to `~/.config/nvim` and tmux config to `~/.tmux.conf`
- Installing TPM (Tmux Plugin Manager)

On first launch, Neovim will auto-bootstrap [lazy.nvim](https://github.com/folke/lazy.nvim) and install all plugins.

## Neovim Plugins

| Plugin | Purpose |
|--------|---------|
| **tokyonight.nvim** | Color scheme |
| **telescope.nvim** | Fuzzy finder (files, grep, buffers) |
| **nvim-treesitter** | Syntax highlighting and code analysis |
| **nvim-lspconfig** + **mason.nvim** | LSP support with auto-installed servers |
| **lsp-zero.nvim** | Simplified LSP configuration |
| **nvim-cmp** | Autocompletion (LSP, buffer, path, snippets) |
| **LuaSnip** + **friendly-snippets** | Snippet engine and library |
| **conform.nvim** | Formatting (prettier, stylua, ruff, djlint, xmlformat) |
| **nvim-lint** | Linting (eslint_d) |
| **nvim-ufo** | Code folding |
| **nvim-autopairs** | Auto-close brackets/quotes |
| **nvim-comment** | Toggle comments |
| **vim-tmux-navigator** | Seamless nav between vim splits and tmux panes |

### LSP Servers (via Mason)

ts_ls, html, cssls, tailwindcss, svelte, lua_ls, graphql, emmet_ls, prismals, pyright
