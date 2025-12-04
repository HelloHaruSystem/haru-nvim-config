-- lua/custom/plugins/mini.lua
return {
  {
    "echasnovski/mini.nvim",
    enabled = true,
    config = function()
      local statusline = require("mini.statusline")
      local pairs = require("mini.pairs")
      local comment = require("mini.comment")

      statusline.setup({ use_icons = true })
      pairs.setup()
      comment.setup() -- keybinds = gcc in normal mode and gc in visual mode
    end,
  },
}
