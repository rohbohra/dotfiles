#!/usr/bin/env bash
set -e

symlink() {
  local src="$HOME/.dotfiles/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak"
  ln -sfn "$src" "$dst"
  echo "linked $dst"
}

symlink "tmux.conf" "$HOME/.tmux.conf"
symlink ".config/nvim" "$HOME/.config/nvim"

# nvim plugins (lazy.nvim) are NOT installed here:
# they self-install on the first `nvim` launch. see README.md
# for the one-time nvim >= 0.9 binary setup.

