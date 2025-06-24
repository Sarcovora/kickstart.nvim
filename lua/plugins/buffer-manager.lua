return {
  'j-morano/buffer_manager.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('buffer_manager').setup {
      width = 0.9,
      select_menu_item_commands = {
        v = {
          key = '<C-v>',
          command = 'vsplit',
        },
        h = {
          key = '<C-x>',
          command = 'split',
        },
      },
    }
  end,
  keys = {
    {
      '<leader>bl',
      function()
        require('buffer_manager.ui').toggle_quick_menu()
      end,
      desc = 'Toggle buffer manager',
    },
  },
}
