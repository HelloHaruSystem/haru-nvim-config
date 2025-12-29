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

-- LSP keymaps (only when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    -- Jump to where a function/variable is defined
    vim.keymap.set("n", "gd", function()
      if vim.bo.filetype == "cs" then
        require("omnisharp_extended").lsp_definition()
      else
        vim.lsp.buf.definition()
      end
    end, opts)

    -- Find all places where this symbol is used
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    -- Rename a symbol everywhere intelligently
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    -- Show available code actions (fixes, refactors, imports)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- Jump to previous diagnostic/error
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)

    -- Jump to next diagnostic/error
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)

    -- Show error details in floating window
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end,
})
