-- nvim-lspconfig
return {
  -- Mason core
  {
    "mason-org/mason.nvim",
    opts = {}
  },

  -- Mason-lspconfig bridge
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", -- lua
        "zls",    -- Zig
        "ts_ls"   -- Typescript
      },
      -- automatic_enable is true by default
    }
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

      -- Formatting on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end
            })
          end
        end,
      })
      -- global setup over

      -- specific lsp configs
      -- Lua Language Server (lua_ls)
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- Zig Language Server (zls)
      vim.lsp.config('zls', {})

      -- Typescript Language Server (ts_ls)
      vim.lsp.config('ts_ls', {})

      -- Mason-lspconfig handles this now!
      -- enable the lsp's
      -- vim.lsp.enable('lua_ls')
      -- vim.lsp.enable('zls')
    end,
  }
}
