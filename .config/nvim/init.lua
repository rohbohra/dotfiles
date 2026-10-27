-- nvim config, managed in ~/.dotfiles
-- requires nvim >= 0.9 (latest stable: https://github.com/neovim/neovim/releases/tag/stable)

-- leader key (set before plugins load)
vim.g.mapleader = " "

-- basics: tabs are 4 spaces, relative line numbers
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = true

-- bootstrap lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    error("Failed to clone lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    lazy = false, -- provides server configs for vim.lsp.config, load eagerly
    config = function()
      -- native nvim 0.11+ LSP API: :help lspconfig-nvim-0.11
      if vim.fn.executable("rust-analyzer") == 1 then
        vim.lsp.config("rust_analyzer", {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
            },
          },
        })
        vim.lsp.enable("rust_analyzer")
      end

      if vim.fn.executable("pyright-langserver") == 1 then
        vim.lsp.config("pyright", {
          settings = {
            python = {
              analysis = { typeCheckingMode = "off" },
            },
          },
        })
        vim.lsp.enable("pyright")
      end
    end,
  },

  -- completion: nvim-cmp + lsp source (pre-0.11 API still supported on 0.12)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- git
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gvdiff" } },
}, {
  performance = {
    rtp = {
      -- keep startup lean: don't preload these heavy rtp plugins
      disabled_rtp_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
  install = { colorscheme = { "default" } },
  change_detection = { notify = false },
})

-- LSP keymaps, attached per-buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = function(desc)
      return { buffer = args.buf, silent = true, desc = "LSP: " .. desc }
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("go to definition"))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("list references"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("hover"))
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts("rename symbol"))
  end,
})
