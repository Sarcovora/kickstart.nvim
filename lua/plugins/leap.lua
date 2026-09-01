return {
  -- The GitHub repo was emptied on 2026-08-29 ("nuke it from orbit"); the author
  -- moved development to Codeberg. Pointing at github would fetch a README and
  -- no `lua/` directory, so `require 'leap'` fails at startup.
  url = 'https://codeberg.org/andyg/leap.nvim',
  name = 'leap.nvim',
  dependencies = { 'tpope/vim-repeat' }, -- so you can dot-repeat jumps
  config = function()
    local leap = require 'leap'
    leap.setup {}
    leap.opts.case_sensitive = true

    vim.keymap.set('n', '<leader>k', '<Plug>(leap-anywhere)', { desc = 'Leap anywhere' })
    vim.keymap.set({ 'x', 'o' }, '<leader>k', '<Plug>(leap)', { desc = 'Leap in selection / operator-pending' })
  end,
}
