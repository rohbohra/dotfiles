-- Set up lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

-- Plugin specifications
require("lazy").setup({
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.rust_analyzer.setup({
        on_attach = function(client, bufnr)
          local bufmap = function(lhs, rhs)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
          end
          bufmap("gd", vim.lsp.buf.definition)
          bufmap("gr", vim.lsp.buf.references)
          bufmap("K", vim.lsp.buf.hover)
        end,
      })
    end,
  },
}, {
  defaults = { lazy = false },
})