-- lua/config/settings.lua

-- Global 4 Space Indenting 
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4        
vim.opt.expandtab = true    

-- Clipboard setting
vim.opt.clipboard = "unnamedplus"

-- always fat cursor
vim.o.guicursor = ""

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-hightlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
