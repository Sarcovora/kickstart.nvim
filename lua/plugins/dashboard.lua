return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- config
      -- Existing section for recent projects
      { desc = 'Recent Projects', action = 'Telescope projects', shortcut = 'SPC f p' },

      -- New entry for Lazy.nvim config
      { desc = 'Lazy Config', action = 'Lazy', shortcut = 'SPC l c' },

      -- New entry for Mason.nvim config
      { desc = 'Mason Config', action = 'Mason', shortcut = 'SPC m c' },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
