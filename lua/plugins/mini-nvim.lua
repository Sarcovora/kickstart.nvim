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

    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    vim.api.nvim_set_hl(0, 'StatusLineFilenameBox', {
      bold = true,
      italic = true,
      fg = '#191724',
      bg = '#c4a7e7',
    })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      -- Check if this is a real file buffer
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype

      -- Skip special buffers (quickfix, help, terminal, etc.)
      if buftype ~= '' then
        return ''
      end

      -- Skip specific filetypes you don't want (outline, file explorers, etc.)
      local skip_filetypes = {
        'qf', -- quickfix
        'help', -- help files
        'Outline', -- outline buffer
        'neo-tree', -- neo-tree file explorer
        'NvimTree', -- nvim-tree
        'Trouble', -- trouble.nvim
        'lspinfo', -- LSP info
        'TelescopePrompt', -- Telescope
        'alpha', -- alpha dashboard
        'dashboard', -- dashboard
        'lazy', -- lazy.nvim
        'mason', -- mason.nvim
      }

      for _, ft in ipairs(skip_filetypes) do
        if filetype == ft then
          return ''
        end
      end

      local filename = vim.fn.expand '%:t'
      local filepath = vim.fn.expand '%:h'

      if filename == '' then
        filename = '[No Name]'
      end

      -- Create the filename box with padding
      local filename_box = '%#StatusLineFilenameBox# ' .. filename .. ' %*'

      if filepath == '.' or filepath == '' then
        return filename_box
      else
        -- Filename box + path in normal statusline color
        return filepath .. '/' .. filename_box
        -- return filename_box .. ' ./' .. filepath
      end
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
