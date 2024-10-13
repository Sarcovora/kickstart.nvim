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

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = 'Harpoon: Add file' })

    vim.keymap.set('n', '<leader>hl', function()
      local file_paths = {}
      local harpoon_files = harpoon:list()
      local conf = require('telescope.config').values

      for idx, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, idx .. ': ' .. item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end, { desc = 'Harpoon: List files with Telescope' })

    vim.keymap.set('n', '<leader>h1', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: select buffer (1)' })
    vim.keymap.set('n', '<leader>h2', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: select buffer (2)' })
    vim.keymap.set('n', '<leader>h3', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: select buffer (3)' })
    vim.keymap.set('n', '<leader>h4', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: select buffer (4)' })
    vim.keymap.set('n', '<leader>h5', function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon: select buffer (5)' })
    vim.keymap.set('n', '<leader>h6', function()
      harpoon:list():select(6)
    end, { desc = 'Harpoon: select buffer (6)' })
    vim.keymap.set('n', '<leader>h7', function()
      harpoon:list():select(7)
    end, { desc = 'Harpoon: select buffer (7)' })
    vim.keymap.set('n', '<leader>h8', function()
      harpoon:list():select(8)
    end, { desc = 'Harpoon: select buffer (8)' })
    vim.keymap.set('n', '<leader>h9', function()
      harpoon:list():select(9)
    end, { desc = 'Harpoon: select buffer (9)' })
    vim.keymap.set('n', '<leader>h0', function()
      harpoon:list():select(10)
    end, { desc = 'Harpoon: select buffer (10)' })

    vim.keymap.set('n', '<leader>h,', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: prev buffer' })

    vim.keymap.set('n', '<leader>h.', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: next buffer' })
  end,
}
