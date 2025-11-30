-- nvim-lspconfig
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
	"folke/lazydev.nvim",
	ft = "lua", -- only load on lua files
	opts = {
	  library = {
	    -- See the configuration section for more details
	    -- Load luvit types when the `vim.uv` word is found
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
      -- global setup over
      
      -- specific lsp configs
      -- Lua Language Server (lua_ls)
      vim.lsp.config('lua_ls', {
	settings = {
	  Lua = {
	    diagnostics = {
	      globals = {'vim'}, 
	    },
	  },
	},
      })

      -- enable the lsp's
      vim.lsp.enable('lua_ls')
    end,
  }
}
