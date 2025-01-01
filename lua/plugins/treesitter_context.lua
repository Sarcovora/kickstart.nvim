return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup {
      enable = true, -- Enable this plugin
      multiwindow = false, -- Enable multiwindow support
      max_lines = 0, -- Unlimited lines
      min_window_height = 0, -- No minimum window height
      line_numbers = true,
      multiline_threshold = 20, -- Max lines per context
      trim_scope = 'outer', -- Discard outer context lines
      mode = 'cursor', -- Context calculation mode
      separator = nil, -- No separator
      zindex = 20, -- Z-index
      on_attach = nil, -- No special attachment behavior
    }
  end,
}
