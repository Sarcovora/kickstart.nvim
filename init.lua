-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true IF you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
--  You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Enable colorcolumn at 80 characters
vim.opt.colorcolumn = '80'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

vim.opt.laststatus = 3

-- Buffer related options
vim.opt.hidden = true

-- Tabs and Indentation (somewhat irrelevant with vim-sleuth)
-- vim.opt.tabstop = 4
-- vim.opt.shiftwidth = 4
--
-- vim.opt.expandtab = true
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true

-- Folding

-- Lazyredraw: Avoid unnecessary screen redraws during macro execution or long commands
vim.opt.lazyredraw = true

--   Enable fold saving across sessions
vim.opt.viewoptions:append 'folds'
vim.opt.foldmethod = 'manual'

--   Start with all folds open by default
vim.opt.foldlevelstart = 99

--   Automatically save folds when leaving a buffer
-- vim.cmd [[
--   augroup remember_folds
--     autocmd!
--     autocmd BufWinLeave * silent! mkview
--     autocmd BufWinEnter * silent! loadview
--   augroup END
-- ]]

-- Wrapping
vim.opt.wrap = false

-- Linebreak: Break lines at word boundaries instead of the middle of words
vim.opt.linebreak = true

-- Showbreak: Display a character at the start of wrapped lines
vim.opt.showbreak = '↪'

-- Comments: Disable automatic comment continuation and wrapping
vim.opt.formatoptions:remove { 'c', 'r', 'o' }

-- Use // for single-line comments in C
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'c',
  command = 'setlocal commentstring=//\\ %s',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cpp',
  command = 'setlocal commentstring=//\\ %s',
})

-- Disable auto-comment insertion when pressing Enter after a comment
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  command = 'setlocal formatoptions-=o',
})

-- Normal mode: Toggle comment on the current line
-- vim.api.nvim_set_keymap('n', '<C-/>', 'gcc', { noremap = false, silent = true })

-- Visual mode: Toggle comment on the selected lines
-- vim.api.nvim_set_keymap('v', '<C-/>', 'gc', { noremap = false, silent = true })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle LSP diagnostics on and off
-- vim.keymap.set('n', '<leader>ld', function()
--   vim.diagnostic.disable()
--   print 'Linter diagnostics disabled'
-- end, { desc = 'Disable Linter Diagnostics' })
--
-- vim.keymap.set('n', '<leader>le', function()
--   vim.diagnostic.enable()
--   print 'Linter diagnostics enabled'
-- end, { desc = 'Enable Linter Diagnostics' })

local diagnostics_enabled = true

vim.keymap.set('n', '<leader>ld', function()
  if diagnostics_enabled then
    vim.diagnostic.enable(false)
    vim.notify('LSP Diagnostics Disabled', vim.log.levels.INFO)
  else
    vim.diagnostic.enable()
    vim.notify('LSP Diagnostics Enabled', vim.log.levels.INFO)
  end
  diagnostics_enabled = not diagnostics_enabled
end, { desc = 'Toggle [L]inter [D]iagnostics' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- NOTE: Setting the MASON_PYTHON environment variable
vim.env.MASON_PYTHON = '/usr/bin/python3'

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Use `opts = {}` to force a plugin to be loaded.
  --
  -- Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  require 'plugins.whichkey',
  require 'plugins.telescope',

  -- LSP Plugins
  require 'plugins.inline-diagnostic',
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  require 'plugins.lsp',
  'Decodetalkers/csharpls-extended-lsp.nvim',

  require 'plugins.conform-nvim', -- Autoformatter
  require 'plugins.nvim-cmp',  -- Autocompletion
  require 'plugins.theme',  -- Colorscheme
  require 'plugins.todo-comments',  -- Highlight todo, notes, etc in comments
  require 'plugins.mini-nvim',  -- Textobjects, surround, statusline
  require 'plugins.nvim-treesitter',  -- Highlight, edit, and navigate code

  -- PROVIDED PLUGINS (kickstart.nvim)
  require 'plugins.snacks',
  require 'plugins.debug',  -- Nvim DAP
  require 'plugins.indent_line', -- Adds vertical lines to show indent levels
  require 'plugins.lint',
  require 'plugins.autopairs',
  require 'plugins.neo-tree',  -- File explorer
  require 'plugins.gitsigns', -- Adds gitsigns recommend keymaps

  -- MY CUSTOM PLUGINS LIST
  require 'plugins.colorizer',
  -- require 'plugins.copilot',
  require 'plugins.markdown_preview',
  require 'plugins.oil',
  require 'plugins.treesj',
  require 'plugins.lazygit',
  require 'plugins.yazi',
  require 'plugins.harpoon',
  require 'plugins.outline',
  require 'plugins.autosession',
  -- require 'plugins.treesitter_context',
  require 'plugins.eyeliner',
  require 'plugins.undotree',

  require 'plugins.claude-code',
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Use true colors
vim.opt.termguicolors = true

-- Set transparent vim background, but after the colorscheme has been set
-- vim.cmd [[highlight Normal guibg=none]]
-- vim.cmd [[highlight NonText guibg=none]]
-- vim.cmd [[highlight NormalFloat guibg=none]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
