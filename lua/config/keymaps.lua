-- Key remaps
-- space + space  + x to source
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
-- Space + x to executes the current line of lua code 
vim.keymap.set("n", "<space>x", ":.lua<CR>")
-- Space + x in visual mode executes the currently selected block of lua code
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- LSP Features Mappings
-- Show Hover Documentation (K)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })
