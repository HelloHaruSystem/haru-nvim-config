return {
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      }
    },
    config = function()
      require('telescope').setup {}
      require('telescope').load_extension('fzf')

      -- Telescope mappings
      local builtin = require('telescope.builtin')
      -- Find Project Files
      vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope Find Project Files" })
      -- Find Git Files
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope Find git files" })
      -- Project Search
      vim.keymap.set("n", "<leader>ps", function()
          builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end,
        { desc = "Telescope Project Search" })
      -- Search help tags
      vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "Telescope Search Help Tags" })
    end
  }
}
