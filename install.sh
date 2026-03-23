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
symlink ".vimrc" "$HOME/.vimrc"

mkdir -p "$HOME/.config/nvim"
symlink ".config/nvim" "$HOME/.config/nvim"

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

