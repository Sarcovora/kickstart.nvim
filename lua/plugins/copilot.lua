-- copilot
-- https://github.com/github/copilot.vim

return {
  'github/copilot.vim',
  config = function()
    -- Function to toggle Copilot and show status
    local function toggle_copilot()
      -- Check if Copilot is enabled by checking the value of g:copilot_enabled
      if vim.g.copilot_enabled == 1 then
        -- Disable Copilot
        vim.g.copilot_enabled = 0
        vim.cmd 'Copilot disable'
        vim.notify('Copilot Disabled', vim.log.levels.INFO)
      else
        -- Enable Copilot
        vim.g.copilot_enabled = 1
        vim.cmd 'Copilot enable'
        vim.notify('Copilot Enabled', vim.log.levels.INFO)
      end
    end

    vim.keymap.set('n', '<leader>cp', toggle_copilot, { desc = 'Toggle Copilot' })
  end,
}
