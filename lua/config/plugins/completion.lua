-- lua/config/plugins/completion.lua
return {
  -- Snippet engine required by nvim-cmp
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },

  -- Completion engine nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completions
      "hrsh7th/cmp-buffer", -- Buffer word completion
      "hrsh7th/cmp-path", -- File path completion
      "saadparwaiz1/cmp_luasnip", -- Snippet completion
      "L3mon4D3/LuaSnip", -- Snippet engine
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Trying if i like ghost text
        experimental = {
          ghost_text = true,
        },

        -- Keymaps
        mapping = cmp.mapping.preset.insert({
          -- Ctrl + space to trigger completion manual (If I close the menu and want it back)
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Ctrl + e to abort completion menu
          ["<C-e>"] = cmp.mapping.abort(),

          -- Enter to confrim selection
          ["<CR>"] = cmp.mapping.confirm({ select = true }),

          -- Tab to select next item
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift + tab to select previous item
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Ctrl + d/u to scroll documentation
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        }),

        -- Sources for completion (ORDER MATTERS :) - first has priority)
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP completion (high prio)
          { name = "luasnip" }, -- Snippet completion
          { name = "path" }, -- File path completion
        }, {
          { name = "buffer" }, -- Buffer word completion (fallback)
        }),
      })
    end,
  },
}
