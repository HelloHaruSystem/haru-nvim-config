-- lua/config/plugins/formatter.lua
return {
  -- Formatter setup
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- Load before writing
    config = function()
      require("conform").setup({
        -- Options passed to confrom.format()
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback", -- Use the LSP formatter if a specific formatter is not configured
        },
        -- Configure specific formatters. Mason will install
        formatters_by_ft = {
          lua = { "stylua" },
          zig = { "lsp" },
          typescript = { "prettier" },
          javascript = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },

          -- Fallback for other filetypes (just trims trailing whitespace)
          _ = { "trim_whitespace" },
        },
      })

      -- Add keymaps here (If needed)
    end,
  },
}
