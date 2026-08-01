-- Bridges Omarchy's theme system into this (non-LazyVim) config.
--
-- Every Omarchy theme ships a `neovim.lua` written as a LazyVim spec, e.g.:
--   return {
--     { "rebelot/kanagawa.nvim" },
--     { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },
--   }
-- We don't run LazyVim, so we read that file ourselves: keep any real
-- colorscheme plugin it declares (so lazy.nvim installs/loads it) and pull
-- the `colorscheme` value (string or function) out of the LazyVim entry to
-- apply by hand. `omarchy theme set <name>` rewrites the symlinked theme
-- dir, so a fresh `nvim` start just picks up whatever it points to now.

local function find_theme_file()
  -- Omarchy 4 moved the active-theme symlink under .local/state; fall back
  -- to the Omarchy 3.x location under .config for older installs.
  local candidates = {
    vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua"),
    vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua"),
  }
  for _, path in ipairs(candidates) do
    if (vim.uv or vim.loop).fs_stat(path) then
      return path
    end
  end
end

-- Always transparent, regardless of what background a given theme paints.
local function apply_transparency()
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local theme_file = find_theme_file()
if not theme_file then
  return {}
end

local ok, theme_spec = pcall(dofile, theme_file)
if not ok or type(theme_spec) ~= "table" then
  vim.notify("omarchy-theme: failed to load " .. theme_file .. "\n" .. tostring(theme_spec), vim.log.levels.WARN)
  return {}
end

local plugins = {}
local colorscheme

for _, spec in ipairs(theme_spec) do
  if spec[1] == "LazyVim/LazyVim" then
    colorscheme = spec.opts and spec.opts.colorscheme
  else
    table.insert(plugins, spec)
  end
end

if colorscheme then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      if type(colorscheme) == "function" then
        colorscheme()
      else
        vim.cmd.colorscheme(colorscheme)
      end
      apply_transparency()
    end,
  })

  -- Covers any later manual `:colorscheme` switch too.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("OmarchyTransparency", { clear = true }),
    callback = apply_transparency,
  })
end

return plugins
