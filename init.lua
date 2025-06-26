vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
--  You can change these options as you wish!
--  For more options, you can see `:help option-list`
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'

vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true

vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'

vim.o.colorcolumn = '80'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

-- laststatus
vim.o.laststatus = 3

-- Buffer related options
vim.o.hidden = true

-- Tabs and Indentation NOTE: somewhat irrelevant now that we have vim-sleuth / guess-indent
-- vim.o.tabstop = 4
-- vim.o.shiftwidth = 4
--
-- vim.o.expandtab = true
-- vim.o.autoindent = true
-- vim.o.smartindent = true

-- Folding

-- Lazyredraw: Avoid unnecessary screen redraws during macro execution or long commands
vim.o.lazyredraw = true

-- Enable fold saving across sessions
vim.opt.viewoptions:append 'folds'
vim.opt.foldmethod = 'manual'

-- Start with all folds open by default
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

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle LSP diagnostics on and off
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
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- Setting the MASON_PYTHON environment variable
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
require('lazy').setup({
  require 'plugins.guess-indent', -- Automatically detect tabstop and shiftwidth
  require 'plugins.whichkey', -- useful plugin to show you pending keybinds.
  require 'plugins.telescope', -- fuzzy finder, file search, etc

  -- LSP
  require 'plugins.inline-diagnostic',
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  require 'plugins.lspconfig', -- 'neovim/nvim-lspconfig',
  'Decodetalkers/csharpls-extended-lsp.nvim',

  -- CORE
  require 'plugins.autoformat', -- conform.nvim; also contains autoformatting block
  require 'plugins.autocompletion', -- blink.cmp
  require 'plugins.todo-comments', -- highlight todo, notes, etc in comments
  require 'plugins.mini-nvim', -- surround, text objects, statusline
  require 'plugins.treesitter',
  require 'plugins.snacks',
  require 'plugins.debug',

  -- Appearance
  require 'plugins.colorscheme',
  require 'plugins.dropbar', -- breadcrumbs
  -- require 'plugins.treesitter_context', -- shows the current context of your code (function, class, etc.) in top bar... can be annoying
  require 'plugins.heirline',

  -- Functional
  require 'plugins.autopairs',
  require 'plugins.indent_line', -- adds vertical lines to show indent levels
  require 'plugins.gitsigns', -- adds gitsigns recommend keymaps
  require 'plugins.treesj',
  require 'plugins.lint',

  -- Nav + Management
  require 'plugins.neo-tree', -- file explorer
  require 'plugins.yazi',
  require 'plugins.oil',
  require 'plugins.outline',
  require 'plugins.harpoon',
  require 'plugins.buffer-manager',
  require 'plugins.leap',
  -- require 'plugins.eyeliner',

  require 'plugins.colorizer',
  require 'plugins.lazygit',
  require 'plugins.autosession',
  require 'plugins.undotree',
  require 'plugins.highlight-undo', -- highlight undo history

  -- Stack dependant add-ons
  require 'plugins.markdown_preview',
  -- require 'plugins.render_markdown', -- renders markdown files in a floating window
  require 'plugins.vimtex',

  -- AI
  -- require 'plugins.copilot',
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
vim.o.termguicolors = true

-- Set transparent vim background, but after the colorscheme has been set
-- vim.cmd [[highlight Normal guibg=none]]
-- vim.cmd [[highlight NonText guibg=none]]
-- vim.cmd [[highlight NormalFloat guibg=none]]

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
