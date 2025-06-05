return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = function()
    require('claude-code').setup {}
  end,
  keys = {
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
  },
}
-- return {
--   'coder/claudecode.nvim',
--   config = true,
--   keys = {
--     { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
--     -- { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
--   },
-- }
