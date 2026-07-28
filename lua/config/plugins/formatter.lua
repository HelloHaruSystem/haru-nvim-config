-- lua/config/plugins/formatter.lua
return {
  -- Formatter setup
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- Load before writing
    config = function()
      require("conform").setup({
        -- Options passed to confrom.format()
        format_on_save = function(bufnr)
          local timeout_ms = 500
          if vim.bo[bufnr].filetype == "fsharp" then
            -- fantomas runs via `dotnet`; the CLR host's cold-start alone
            -- can exceed the default timeout, especially on first save.
            timeout_ms = 3000
          end
          return {
            timeout_ms = timeout_ms,
            lsp_format = "fallback", -- Use the LSP formatter if a specific formatter is not configured
          }
        end,
        -- Configure specific formatters. Mason will install
        formatters_by_ft = {
          sh = { "shfmt" },
          bash = { "shfmt" },
          c = { "clang-format" },
          zig = { "lsp" },
          rust = { "lsp" },
          fsharp = { "fantomas" },
          java = { "lsp" },
          cs = { "lsp" },
          csharp = { "lsp" },
          elixir = { "mix" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          python = { "ruff_format" },
          lua = { "stylua" },
          markdown = { "prettier" },

          -- Fallback for other filetypes (just trims trailing whitespace)
          _ = { "trim_whitespace" },
        },
      })

      -- Add keymaps here (If needed)
    end,
  },
}
