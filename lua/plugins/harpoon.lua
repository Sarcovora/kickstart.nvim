return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup {}

    -- Define a custom highlight group for the numbers (muted purple)
    vim.api.nvim_set_hl(0, 'HarpoonNumber', { fg = '#9d7cd8', bold = true }) -- Customize this to your preferred color

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon: Add file' })

    vim.keymap.set('n', '<leader>hl', function()
      local harpoon_files = harpoon:list()
      local conf = require('telescope.config').values
      local entry_display = require 'telescope.pickers.entry_display'

      -- Define the format for how the entries should be displayed
      local displayer = entry_display.create {
        separator = ' ',
        items = {
          { width = 5, hl_group = 'HarpoonNumber' }, -- Number with custom highlight
          { remaining = true }, -- File path
        },
      }

      -- Create a list of items that contains both the index and file path
      local file_items = {}
      for idx, item in ipairs(harpoon_files.items) do
        table.insert(file_items, { idx = idx, path = item.value })
      end

      -- Telescope picker setup
      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_items,
            entry_maker = function(entry)
              return {
                value = entry.path,
                display = function(display_entry)
                  return displayer {
                    { tostring(display_entry.idx), 'HarpoonNumber' }, -- Number with color
                    display_entry.path, -- File path
                  }
                end,
                ordinal = entry.path,
                idx = entry.idx,
                path = entry.path,
              }
            end,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
          attach_mappings = function(_, map)
            -- Define what happens when <CR> (enter) is pressed
            map('i', '<CR>', function(prompt_bufnr)
              local selection = require('telescope.actions.state').get_selected_entry()
              require('telescope.actions').close(prompt_bufnr)
              -- Open the selected file
              vim.cmd('edit ' .. selection.value)
            end)
            return true
          end,
        })
        :find()
    end, { desc = '[H]arpoon: List files with Telescope' })

    vim.keymap.set('n', '<leader>h1', function()
      harpoon:list():select(1)
    end, { desc = '[H]arpoon: select buffer (1)' })
    vim.keymap.set('n', '<leader>h2', function()
      harpoon:list():select(2)
    end, { desc = '[H]arpoon: select buffer (2)' })
    vim.keymap.set('n', '<leader>h3', function()
      harpoon:list():select(3)
    end, { desc = '[H]arpoon: select buffer (3)' })
    vim.keymap.set('n', '<leader>h4', function()
      harpoon:list():select(4)
    end, { desc = '[H]arpoon: select buffer (4)' })
    vim.keymap.set('n', '<leader>h5', function()
      harpoon:list():select(5)
    end, { desc = '[H]arpoon: select buffer (5)' })
    vim.keymap.set('n', '<leader>h6', function()
      harpoon:list():select(6)
    end, { desc = '[H]arpoon: select buffer (6)' })
    vim.keymap.set('n', '<leader>h7', function()
      harpoon:list():select(7)
    end, { desc = '[H]arpoon: select buffer (7)' })
    vim.keymap.set('n', '<leader>h8', function()
      harpoon:list():select(8)
    end, { desc = '[H]arpoon: select buffer (8)' })
    vim.keymap.set('n', '<leader>h9', function()
      harpoon:list():select(9)
    end, { desc = '[H]arpoon: select buffer (9)' })
    vim.keymap.set('n', '<leader>h0', function()
      harpoon:list():select(10)
    end, { desc = '[H]arpoon: select buffer (10)' })
  end,
}
