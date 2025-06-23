-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
return {
  -- 'catppuccin/nvim',
  'rose-pine/neovim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    -- vim.cmd.colorscheme 'tokyonight-night'
    -- vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.colorscheme 'rose-pine'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
}
