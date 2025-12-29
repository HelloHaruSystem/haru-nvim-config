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

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Better editing
vim.opt.smartindent = true
vim.opt.signcolumn = "yes" -- Prevents jitter when LSP shows diagnostics
vim.opt.updatetime = 250 -- Faster completion (default is 4000ms)
vim.opt.incsearch = true -- Show search matches as you type
