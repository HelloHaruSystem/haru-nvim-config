-- In-buffer Markdown rendering (headers, tables, checkboxes, etc.) — no Node/npm needed
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = "markdown",
  opts = {},
  config = function(_, opts)
    require("render-markdown").setup(opts)
    -- Toggle rendering on/off
    vim.keymap.set("n", "<leader>mp", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Rendering" })
  end,
}
