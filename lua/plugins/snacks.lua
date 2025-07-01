return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Enabled
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },

    -- Disabled
    terminal = { enabled = false },
    scroll = { enabled = false, animate = { duration = { step = 10, total = 75 }, easing = 'linear' } },
    lazygit = { enabled = false },
    notifier = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    zen = { enabled = false },
    bufdelete = { enabled = false },
    rename = { enabled = false },
    git = { enabled = false },
    statuscolumn = { enabled = false },
    scratch = { enabled = false },
    toggle = { enabled = false },
    gitbrowse = { enabled = false },
    words = { enabled = false },
  },
  -- keys = {
  --   {
  --     '<c-/>',
  --     function()
  --       Snacks.terminal()
  --     end,
  --     desc = 'Toggle Terminal',
  --   },
  -- },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
  end,
}
