-- In-buffer Markdown rendering (headers, tables, checkboxes, etc.) — no Node/npm needed
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "markdown",
  opts = {
    -- LSP hover docs (and other scratch/preview floats) are buftype=nofile.
    -- Rendering those hits a treesitter query-predicate crash on some content
    -- (nil node in query_predicates.lua), so leave them as plain text.
    overrides = {
      buftype = {
        nofile = { enabled = false },
      },
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    -- Toggle rendering on/off
    vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Rendering" })
  end,
}
