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

    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        height_in_lines = 20,
        border = "rounded",
      })
    end, { desc = '[H]arpoon: List files with Telescope' })

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon: Add file' })

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
