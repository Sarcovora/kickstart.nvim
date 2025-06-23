return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- NOTE: can instead use ), }, or ] to replace without space

    -- Disable default 's' key behavior in normal and visual modes
    vim.keymap.set('n', 's', '<Nop>', { silent = true })
    vim.keymap.set('v', 's', '<Nop>', { silent = true })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup {
      use_icons = vim.g.have_nerd_font,
      -- Force our custom content function
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
          local git           = statusline.section_git({ trunc_width = 40 })
          local diff          = statusline.section_diff({ trunc_width = 75 })
          local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
          local lsp           = statusline.section_lsp({ trunc_width = 75 })
          local filename      = statusline.section_filename({ trunc_width = 140 })
          local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
          local location      = statusline.section_location({ trunc_width = 75 })
          local search        = statusline.section_searchcount({ trunc_width = 75 })

          return statusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl,                  strings = { search, location } },
          })
        end,
      }
    }

    vim.api.nvim_set_hl(0, 'StatusLineFilenameBox', {
      bold = true,
      italic = true,
      fg = '#191724',
      bg = '#c4a7e7',
    })

    -- ---@diagnostic disable-next-line: duplicate-set-field
    -- statusline.section_filename = function()
    --   local filename = vim.fn.expand '%:t'
    --   local filepath = vim.fn.expand '%:h'
    --
    --   if filename == '' then
    --     filename = '[No Name]'
    --   end
    --
    --   -- Create the filename box with padding
    --   local filename_box = '%#StatusLineFilenameBox# ' .. filename .. ' %*'
    --
    --   if filepath == '.' or filepath == '' then
    --     return filename_box
    --   else
    --     -- Filename box + path in normal statusline color
    --     return filename_box .. ' (' .. filepath .. ')'
    --   end
    -- end

    -- Override the section_filename AFTER setup
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function(args)
      local trunc_width = args and args.trunc_width or 140

      -- Check if this is a real file buffer
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype

      -- Skip special buffers (quickfix, help, terminal, etc.)
      if buftype ~= '' then
        return ''
      end

      -- Skip specific filetypes you don't want (outline, file explorers, etc.)
      local skip_filetypes = {
        'qf', 'help', 'Outline', 'neo-tree', 'NvimTree', 'Trouble',
        'lspinfo', 'TelescopePrompt', 'alpha', 'dashboard', 'lazy', 'mason'
      }

      for _, ft in ipairs(skip_filetypes) do
        if filetype == ft then
          return ''
        end
      end

      local filename = vim.fn.expand '%:t'
      -- local filepath = vim.fn.expand '%:h'
      local full_path = vim.fn.expand '%:p'

      local cwd = vim.fn.getcwd()
      local filepath = vim.fn.fnamemodify(full_path, ':h')

      if filepath:sub(1, #cwd) == cwd then
        filepath = filepath:sub(#cwd + 2) -- +2 to skip the trailing slash
        if filepath == '' then
          filepath = '.'
        end
      end

      if filename == '' then
        filename = '[No Name]'
      end

      -- Get appropriate width based on laststatus setting
      local statusline_width
      if vim.o.laststatus == 3 then
        -- Global statusline: use full terminal width
        statusline_width = vim.o.columns
      else
        -- Per-window statusline: use current window width
        statusline_width = vim.api.nvim_win_get_width(0)
      end

      -- If statusline is too narrow, just show filename
      if statusline_width < trunc_width then
        return '%#StatusLineFilenameBox# ' .. filename .. ' %*'
      end

      -- Calculate space for path display
      local filename_len = string.len(filename) + 2 -- +2 for padding
      local reserved_space = 60 -- space for other statusline elements
      local available_space = statusline_width - filename_len - reserved_space - 4 -- -4 for " (" and ")"

      local display_path = filepath
      if filepath ~= '.' and filepath ~= '' then
        if string.len(filepath) > available_space and available_space > 10 then
          -- Truncate from left, show ellipsis
          local truncated_len = available_space - 1 -- -1 for ellipsis
          display_path = '…' .. string.sub(filepath, -truncated_len)
        end
        return '%#StatusLineFilenameBox# ' .. filename .. ' %* (' .. display_path .. ')'
      else
        return '%#StatusLineFilenameBox# ' .. filename .. ' %*'
      end
    end

    -- Force mini.statusline to use our custom filename function
    local MiniStatusline = require('mini.statusline')
    MiniStatusline.config.content.active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git           = MiniStatusline.section_git({ trunc_width = 40 })
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location      = MiniStatusline.section_location({ trunc_width = 75 })
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
      })
    end

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
