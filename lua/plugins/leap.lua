return {
  'ggandor/leap.nvim',
  dependencies = { 'tpope/vim-repeat' }, -- so you can dot-repeat jumps
  config = function()
    local leap = require 'leap'
    leap.setup {}
    leap.opts.case_sensitive = true

    vim.keymap.set('n', '<leader>k', '<Plug>(leap-anywhere)', { desc = 'Leap anywhere' })
    vim.keymap.set({ 'x', 'o' }, '<leader>k', '<Plug>(leap)', { desc = 'Leap in selection / operator-pending' })
  end,
}
