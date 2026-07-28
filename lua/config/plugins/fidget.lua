return {
  "j-hui/fidget.nvim",
  opts = {
    progress = {
      -- FsAutoComplete re-checks on nearly every keystroke and fires
      -- constant $/progress updates, so it's always pinned on screen.
      -- Silence just that client; other servers still show progress.
      ignore = { "fsautocomplete" },
    },
  },
}
