#!/usr/bin/env bash
set -e

symlink() {
  local src="$HOME/.dotfiles/$1"
  local dst="$2"
  [ -e "$dst" ] && [ ! -L "$dst" ] && mv "$dst" "$dst.bak"
  ln -sfn "$src" "$dst"
  echo "linked $dst"
}

symlink "tmux.conf" "$HOME/.tmux.conf"
symlink "vimrc"     "$HOME/.vimrc"
