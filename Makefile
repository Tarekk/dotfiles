DOTFILES_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
STOW_PKGS := nvim tmux zsh git claude

.PHONY: help stow restow unstow install mcp
.DEFAULT_GOAL := help

help:
	@echo "Usage: dotfiles <command>"
	@echo ""
	@echo "Commands:"
	@echo "  stow      Symlink packages into ~"
	@echo "  restow    Re-symlink packages (use after adding skills, etc.)"
	@echo "  unstow    Remove all symlinks"
	@echo "  mcp       Merge MCP servers into ~/.claude.json"
	@echo "  install   Full machine bootstrap"

stow:
	@mkdir -p $(HOME)/.claude
	@for pkg in $(STOW_PKGS); do \
		stow --target="$(HOME)" -d "$(DOTFILES_DIR)" $$pkg; \
		echo "  stowed $$pkg"; \
	done

restow:
	@mkdir -p $(HOME)/.claude
	@for pkg in $(STOW_PKGS); do \
		stow --restow --target="$(HOME)" -d "$(DOTFILES_DIR)" $$pkg; \
		echo "  restowed $$pkg"; \
	done

unstow:
	@for pkg in $(STOW_PKGS); do \
		stow --delete --target="$(HOME)" -d "$(DOTFILES_DIR)" $$pkg; \
		echo "  unstowed $$pkg"; \
	done

mcp:
	@if [ ! -f $(HOME)/.claude.json ]; then echo '{}' > $(HOME)/.claude.json; fi
	@jq -s '.[0].mcpServers = ((.[0].mcpServers // {}) * .[1]) | .[0]' \
		$(HOME)/.claude.json \
		$(DOTFILES_DIR)/claude/mcp-servers.json > $(HOME)/.claude.json.tmp \
		&& mv $(HOME)/.claude.json.tmp $(HOME)/.claude.json
	@echo "Merged MCP servers into ~/.claude.json"

install:
	@bash "$(DOTFILES_DIR)/install.sh"
