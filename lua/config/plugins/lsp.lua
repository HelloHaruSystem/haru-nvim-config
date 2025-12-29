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
        "bashls", -- Bash/Shell
        "clangd", -- C/C++
        "zls", -- Zig
        "jdtls", -- Java
        "omnisharp", -- C#
        "elixirls", -- Elixir
        "ts_ls", -- Typescript
        "angularls", -- Angular
        "html", -- HTML
        "cssls", -- CSS
        "tailwindcss", -- Tailwind CSS
        "lemminx", -- XML
        "jsonls", -- JSON
        "yamlls", -- YAML
        "basedpyright", -- Python
        "lua_ls", -- lua
        "marksman", -- Markdown
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
          "shfmt", -- Bash/Shell Formatter
          "clang-format", -- C/C++ Formatter
          "prettier", -- JS/TS/JSON/YAML Formatter
          "ruff", -- Python
          "stylua", -- Lua Formatter
          "eslint_d", -- JS/TS linter
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

      -- Bash Language Server
      vim.lsp.config("bashls", {})

      -- C/C++ Language Server
      vim.lsp.config("clangd", {})

      -- Zig Language Server (zls)
      vim.lsp.config("zls", {})

      -- Java Language Server
      -- The Java plugin will handle this
      -- Because a per-project setup is needed

      -- Disable lspconfig's default omnisharp to avoid conflicts
      vim.g.lspconfig_omnisharp_disable = true

      -- C# Language Server (omnisharp)
      vim.lsp.config("omnisharp", {
        cmd = {
          "dotnet",
          vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll",
          "--languageserver",
        },
        root_markers = { "*.csproj", "*.sln" },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            EnableDecompilationSupport = true,
          },
        },
      })

      -- Elixir Language Server
      vim.lsp.config("elixirls", {})

      -- Typescript Language Server (ts_ls)
      vim.lsp.config("ts_ls", {})

      -- Angular Language Server
      vim.lsp.config("angularls", {})

      -- HTML Language Server
      vim.lsp.config("html", {})

      -- CSS Language Server
      vim.lsp.config("cssls", {})

      -- Tailwind CSS Language Server
      vim.lsp.config("tailwindcss", {
        filetypes = {
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
      })

      -- XML Language Server
      vim.lsp.config("lemminx", {})

      -- JSON Language Server
      vim.lsp.config("jsonls", {})

      -- YAML Language Server
      vim.lsp.config("yamlls", {})

      -- Python Language Server
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

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

      -- Markdown
      vim.lsp.config("marksman", {})

      -- Mason-lspconfig handles this now!
      -- enable the lsp's
      -- vim.lsp.enable('lua_ls')
      -- vim.lsp.enable('zls')
    end,
  },
}
