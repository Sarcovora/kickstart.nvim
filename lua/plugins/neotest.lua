return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-neotest/neotest-python',
    -- 'nvim-neotest/neotest-playwright',
    'nvim-neotest/neotest-jest',
    'nvim-neotest/neotest-plenary',
    'nvim-neotest/neotest-vim-test',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          dap = { justMyCode = false },
        },
        -- require 'neotest-playwright',
        require 'neotest-jest',
        require 'neotest-plenary',
        require 'neotest-vim-test' {
          ignore_file_types = { 'python', 'vim', 'lua' },
        },
      },
    }

    vim.keymap.set('n', '<leader>nt', function()
      require('neotest').run.run()
    end, { desc = 'Run nearest test' })

    vim.keymap.set('n', '<leader>nc', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = 'Run current file tests' })

    vim.keymap.set('n', '<leader>ns', function()
      require('neotest').run.stop()
    end, { desc = 'Stop test run' })

    vim.keymap.set('n', '<leader>na', function()
      require('neotest').run.attach()
    end, { desc = 'Attach to test run' })

    vim.keymap.set('n', '<leader>nd', function()
      require('neotest').run.run { strategy = 'dap' }
    end, { desc = 'Debug nearest Test' })

    vim.keymap.set('n', '<leader>noo', function()
      require('neotest').output.open()
    end, { desc = 'View test output as popup' })

    vim.keymap.set('n', '<leader>nop', function()
      require('neotest').output_panel.toggle()
    end, { desc = 'Toggle test output panel' })

    vim.keymap.set('n', '<leader>nos', function()
      require('neotest').summary.toggle()
    end, { desc = 'Toggle test summary' })
  end,
}
