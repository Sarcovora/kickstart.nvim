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

      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
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

    vim.keymap.set('n', '<leader>h,', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: prev buffer' })

    vim.keymap.set('n', '<leader>h.', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: next buffer' })
  end,
}
