-- Highlight, edit, and navigate code
--
-- This targets nvim-treesitter's `main` branch, a full rewrite that requires
-- Neovim 0.12+. It provides no "modules": highlighting, indentation and folding
-- are Neovim features that we turn on ourselves in the FileType autocmd below.
-- The pre-rewrite `master` spec lives on the `nvim-0.11` branch of this config.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  -- `main` does not support lazy-loading, and needs :TSUpdate after every bump
  -- to keep parsers in step with the plugin's `parser.lua` revisions.
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'
    ts.setup {}

    local ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'python',
      'javascript',
      'typescript',
      'css',
      'angular',
      'scss',
    }

    -- Languages that need Vim's regex syntax running alongside treesitter for
    -- their indent rules (the old `additional_vim_regex_highlighting` list).
    local needs_vim_regex = { ruby = true }
    -- Languages whose treesitter indentexpr misbehaves (the old `indent.disable`).
    local no_ts_indent = { ruby = true }

    local installed = {}
    for _, lang in ipairs(ts.get_installed 'parsers') do
      installed[lang] = true
    end

    local missing = vim.tbl_filter(function(lang)
      return not installed[lang]
    end, ensure_installed)
    if #missing > 0 then
      ts.install(missing)
    end

    -- Stands in for the old `auto_install`: `get_available()` is the set of
    -- parsers upstream knows how to build, so anything in it can be fetched on
    -- first encounter with that filetype.
    local available = {}
    for _, lang in ipairs(ts.get_available()) do
      available[lang] = true
    end

    local function enable(buf, lang)
      if not vim.api.nvim_buf_is_valid(buf) then
        return false
      end
      if not pcall(vim.treesitter.start, buf, lang) then
        return false
      end
      if not no_ts_indent[lang] then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      if needs_vim_regex[lang] then
        vim.bo[buf].syntax = 'on'
      end
      return true
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == '' then
          return
        end

        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end

        if enable(args.buf, lang) then
          installed[lang] = true
          return
        end

        -- No parser yet. Fetch it once, then turn highlighting on for the
        -- buffer that triggered this, if it's still around.
        if available[lang] and not installed[lang] then
          installed[lang] = true -- claim it so concurrent buffers don't re-request
          local ok = pcall(function()
            ts.install({ lang }):await(function(err)
              if err then
                installed[lang] = nil
                return
              end
              vim.schedule(function()
                enable(args.buf, lang)
              end)
            end)
          end)
          if not ok then
            installed[lang] = nil
          end
        end
      end,
    })
  end,
}
