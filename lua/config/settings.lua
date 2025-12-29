-- lua/config/settings.lua

-- Line numbers (globally)
vim.opt.nu = true
vim.opt.relativenumber = true

-- Global 4 Space Indenting
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Enable true color support
vim.opt.termguicolors = true

-- Clipboard setting
vim.opt.clipboard = "unnamedplus"

-- Always fat cursor
vim.o.guicursor = ""

-- Verticalscroll offset
vim.opt.scrolloff = 15

-- Better editing
vim.opt.smartindent = true
vim.opt.signcolumn = "yes" -- Prevents jitter when LSP shows diagnostics
vim.opt.updatetime = 250 -- Faster completion (default is 4000ms)
vim.opt.incsearch = true -- Show search matches as you type

-- Autocommands
local augroup = vim.api.nvim_create_augroup("AutoCommands", { clear = true })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto-remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
