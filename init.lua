print("Hello, Halfdan~")

require("config.lazy")

-- global 4 Space indenting
vim.opt.shiftwidth = 4
vim.opt.tapsop = 4
vim.expandtab = true              -- Insert spaces instead of \t
-- yank and put from clipboard
vim.opt.clipboard = "unnamedplus"

-- Key remaps
-- space + space  + x to source
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
-- Space + x to executes the current line of lua code 
vim.keymap.set("n", "<space>x", ":.lua<CR>")
-- Space + x in visual mode executes the currently selected block of lua code
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Highlight when yanking (copying) text
-- Try `yap` in normal mode
-- help at `:help vim.highlight.on_yank()'
vim.api.nvim_create_autocmd('TextYankPost', {
desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-hightlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

