-- Tokyonight Color Scheme
return {
  {
    "folke/tokyonight.nvim",
    enabled = false,
    config = function()
      vim.cmd.colorscheme("tokyonight")
      -- Set background to be transparent
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
