-- Treesitter plugin
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all" (the listed parsers MUST always be installed)
        ensure_installed = {
          "bash",
          "c",
          "zig",
          "rust",
          "fsharp",
          "java",
          "c_sharp",
          "elixir",
          "heex", -- Elixir Phoenix templates
          "javascript",
          "typescript",
          "angular", -- Angular Templates
          "html",
          "css",
          "xml",
          "json",
          "yaml",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
        },

        modules = {},
        ignore_install = {},

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        --ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
          -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
          -- the name of the parser)
          -- list of language that will be disabled
          --disable = { "c", "rust" },
          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      })

      -- Workaround for https://github.com/neovim/neovim/issues/39032
      -- The bundled markdown `highlights` query sets `conceal_lines` on fenced
      -- code block delimiters, which crashes the treesitter highlighter (nil
      -- node in a query predicate) on Neovim 0.12.x. Strip just that
      -- directive, keep everything else in the query intact.
      -- Closed upstream as "not planned" — remove this if a future
      -- Neovim/nvim-treesitter release fixes the query itself.
      -- Real fix for a second, more common crash in the markdown `injections`
      -- query (nvim-treesitter#8636, nvim-treesitter#8618): on Neovim 0.12 a
      -- query match capture can return a *list* of nodes instead of a single
      -- node (core API change), but nvim-treesitter's query_predicates.lua
      -- still assumes a single node and calls node:range() on it directly —
      -- crashing whenever it's actually a table. This is what was actually
      -- crashing on LSP hover for labeled code fences (e.g. omnisharp's
      -- ```csharp hover docs). Re-register the affected predicates/directives
      -- (force=true) with a version that unwraps the list first. Also fixes
      -- a real, separate gap noticed while debugging this: "csharp" (the
      -- literal label omnisharp emits) was never mapped to the actual parser
      -- name "c_sharp", so C# code inside fences was never being
      -- syntax-highlighted at all, crash or no crash — added that alias too.
      -- Remove this whole block once nvim-treesitter ships its own fix.
      do
        local function get_node(match, id)
          local val = match[id]
          if type(val) == "table" then
            return val[1]
          end
          return val
        end

        local html_script_type_languages = {
          ["importmap"] = "json",
          ["module"] = "javascript",
          ["application/ecmascript"] = "javascript",
          ["text/ecmascript"] = "javascript",
        }

        local non_filetype_match_injection_language_aliases = {
          ex = "elixir",
          pl = "perl",
          sh = "bash",
          uxn = "uxntal",
          ts = "typescript",
          csharp = "c_sharp", -- not a real file extension, so vim.filetype.match() can't find it
        }

        local function get_parser_from_markdown_info_string(injection_alias)
          local match = vim.filetype.match({ filename = "a." .. injection_alias })
          return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
        end

        local q = vim.treesitter.query

        q.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
          local node = get_node(match, pred[2])
          local n = tonumber(pred[3])
          if node and node:parent() and node:parent():named_child_count() > n then
            return node:parent():named_child(n) == node
          end
          return false
        end, { force = true })

        q.add_predicate("is?", function(match, _pattern, bufnr, pred)
          local locals = require("nvim-treesitter.locals")
          local node = get_node(match, pred[2])
          local types = { unpack(pred, 3) }
          if not node then
            return true
          end
          local _, _, kind = locals.find_definition(node, bufnr)
          return vim.tbl_contains(types, kind)
        end, { force = true })

        q.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
          local node = get_node(match, pred[2])
          local types = { unpack(pred, 3) }
          if not node then
            return true
          end
          return vim.tbl_contains(types, node:type())
        end, { force = true })

        q.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
          local node = get_node(match, pred[2])
          if not node then
            return
          end
          local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
          local configured = html_script_type_languages[type_attr_value]
          if configured then
            metadata["injection.language"] = configured
          else
            local parts = vim.split(type_attr_value, "/", {})
            metadata["injection.language"] = parts[#parts]
          end
        end, { force = true })

        q.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
          local node = get_node(match, pred[2])
          if not node then
            return
          end
          local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
          metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
        end, { force = true })

        q.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
          local id = pred[2]
          local node = get_node(match, id)
          if not node then
            return
          end
          local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
          if not metadata[id] then
            metadata[id] = {}
          end
          metadata[id].text = string.lower(text)
        end, { force = true })
      end

      local files = vim.treesitter.query.get_files("markdown", "highlights")
      if #files > 0 then
        local parts = {}
        for _, file in ipairs(files) do
          local f = io.open(file, "r")
          if f then
            table.insert(parts, f:read("*a"))
            f:close()
          end
        end
        local text = table.concat(parts, "\n")
        -- Remove just the directive, not the whole line: it shares a line
        -- with the closing paren of its parent pattern.
        text = text:gsub('%(#set!%s+conceal_lines%s+""%)', "")
        if text ~= "" then
          vim.treesitter.query.set("markdown", "highlights", text)
        end
      end
    end,
  },
}
