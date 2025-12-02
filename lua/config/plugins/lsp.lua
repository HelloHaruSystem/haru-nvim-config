-- nvim-lspconfig
return {
  -- Mason core
  {
    "mason-org/mason.nvim",
    opts = {},
  },

  -- Mason-lspconfig bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", -- lua
        "zls", -- Zig
        "ts_ls", -- Typescript
        "html", -- HTML
        "cssls", -- CSS
      },
      -- automatic_enable is true by default
    },
  },

  -- Mason Tool Installer (Formatters & Linters)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", -- Lua Formatter
          "prettier", -- JS/TS/JSON/YAML Formatter
        },
      })
    end,
  },

  -- Lsp config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- global diagnostic setup (Done Once)
      vim.diagnostic.config({
        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
          source = true,
        },
        signs = true,
        update_in_insert = false,
      })

      -- specific lsp configs
      -- TODO: change some default configs

      -- Lua Language Server (lua_ls)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- Zig Language Server (zls)
      vim.lsp.config("zls", {})

      -- Typescript Language Server (ts_ls)
      vim.lsp.config("ts_ls", {})

      -- HTML Language Server
      vim.lsp.config("html", {})

      -- CSS Language Server
      vim.lsp.config("cssls", {})

      -- Mason-lspconfig handles this now!
      -- enable the lsp's
      -- vim.lsp.enable('lua_ls')
      -- vim.lsp.enable('zls')
    end,
  },
}
