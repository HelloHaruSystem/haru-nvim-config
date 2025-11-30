-- Key remaps
-- Leader key = space
vim.g.mapleader = " "

-- leader + pv for :Ex
-- opens directory where the current fie is placed
vim.keymap.set("n", "<leader>pv", ":Ex<CR>")

-- TODO: add keymaps for Vex or Sex or both

-- leader + leader + x to source
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
-- Leader + x to executes the current line of lua code 
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
-- leader + x in visual mode executes the currently selected block of lua code
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- LSP Features Mappings
-- Show Hover Documentation (K)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })

-- Move select blocks in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")











