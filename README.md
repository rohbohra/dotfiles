# dotfiles

Symlink-based dotfiles for linux dev boxes. Clone to `~/.dotfiles` and run once:

```bash
git clone git@github.com:rohbohra/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` links tmux + nvim config into `$HOME` (backs up anything it replaces).
nvim plugins self-install via lazy.nvim on first launch — nothing else to run.

## nvim

Config: [.config/nvim/init.lua](.config/nvim/init.lua) — lazy.nvim, nvim-lspconfig
(rust-analyzer: clippy on save, all cargo features), nvim-cmp, fugitive.
LSP keys on attach: `gd` definition, `gr` references, `K` hover, `<leader>cr` rename.
Leader is `<space>`.

**Requires nvim >= 0.9.** The apt package on jammy is 0.6.1, which is too old.
One-time binary setup (installs to `~/.local`, shadows `/usr/bin/nvim` via PATH):

```bash
curl -fsSL -o /tmp/nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
mkdir -p ~/.local/opt ~/.local/bin
tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C ~/.local/opt
ln -sfn ~/.local/opt/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
```

rust-analyzer comes from rustup (`rustup component add rust-analyzer`).

## branches

- `main` — active config
- `rust-lsp-wip` — parked 2026-era vim-lsp experiment for `.vimrc` (vim, not nvim)
