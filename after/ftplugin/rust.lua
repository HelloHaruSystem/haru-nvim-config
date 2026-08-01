-- Rust language configs
local set = vim.opt_local

set.shiftwidth = 4
set.tabstop = 4
set.number = true
set.relativenumber = true

-- mini.pairs auto-closes ' globally, which fights lifetime syntax (&'a).
-- Shadow just that key for this buffer so it inserts a single quote;
-- every other pair ((), "", etc.) still goes through mini.pairs as normal.
vim.keymap.set("i", "'", "'", { buffer = true, desc = "Insert single quote (no auto-pair, for lifetimes)" })
