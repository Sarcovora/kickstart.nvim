return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    -- to see this in action, run `NO_AUTO_SESSION=1 nvim` in your terminal
    enabled = os.getenv 'NO_AUTO_SESSION' ~= '1', -- disable if NO_AUTO_SESSION env var is set
    suppressed_dirs = { '~/', '~/Downloads', '/' },
    -- log_level = 'debug',
  },
}
