return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    -- Interactive grep args (handy to toggle -uu etc. at runtime)
    { 'nvim-telescope/telescope-live-grep-args.nvim' },

    -- Pretty idons (requires Nerd Font)
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'

    -- Hefty dirs to keep out of searches
    local HOGS = {
      '**/.git/**',
      '**/node_modules/**',
      '**/.next/**',
      '**/dist/**',
      '**/build/**',
      '**/out/**',
      '**/coverage/**',
      '**/.turbo/**',
      '**/.cache/**',
      '**/.yarn/**',
      '**/.venv/**',
      '**/venv/**',
      '**/.mypy_cache/**',
      '**/.pytest_cache/**',
      '**/bazel-*/**',
      '**/buck-out/**',
      '**/.gradle/**',
      '**/.idea/**',
      '**/.vscode/**',
      '**/.DS_Store',
      '**/*.lock',
      '**/.ipynb_checkpoints/**',
    }

    -- Choose a fast file lister command for find_files
    local find_cmd
    if vim.fn.executable 'fd' == 1 then
      -- fd respects .gitignore by default; include dotfiles; keep cwd paths short
      find_cmd = { 'fd', '--type', 'f', '--hidden', '--strip-cwd-prefix' }
    else
      -- ripgrep fallback
      find_cmd = { 'rg', '--files', '--hidden', '--color', 'never' }
    end

    telescope.setup {
      -- All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        layout_strategy = 'vertical',
        path_display = { 'truncate' },

        -- Make grep see dotfiles but still respect .gitignore
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--no-follow',
        },

        file_ignore_patterns = {},
      },
      pickers = {
        find_files = {
          hidden = true, -- show dotfiles (like .env)
          follow = true, -- follow symlinks
          find_command = find_cmd,
        },
      },

      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
        -- live_grep_args lets you add flags at runtime (<C-k> to quote, etc.)
        ['live_grep_args'] = { auto_quoting = true },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'live_grep_args')
    pcall(telescope.load_extension, 'harpoon')

    ---- Smart helpers (project-aware) ----
    local function is_git_repo()
      -- 0 exit code => inside a git work tree
      return vim.fn.system 'git rev-parse --is-inside-work-tree 2>/dev/null' ~= '' and vim.v.shell_error == 0
    end

    local function project_files()
      if is_git_repo() then
        -- super fast; includes untracked, but still respects .gitignore
        local ok = pcall(builtin.git_files, { show_untracked = true })
        if ok then
          return
        end
      end
      -- not a git repo (or git failed): use find_files with ignores/dotfiles
      builtin.find_files()
    end

    local function live_grep_project()
      -- Respect .gitignore; include dotfiles; explicitly exclude hogs
      local args = { '--hidden' }
      for _, pat in ipairs(HOGS) do
        -- convert lua-style patterns to ripgrep globs (best-effort)
        local glob = pat:gsub('%%%.', '.'):gsub('%^', '') -- drop anchors / escapes
        table.insert(args, '--glob')
        table.insert(args, '!' .. glob)
      end
      builtin.live_grep {
        additional_args = function()
          return args
        end,
      }
    end

    local function find_files_include_ignored()
      -- Include ignored files (e.g., if .env is git-ignored) but still exclude hogs manually.
      builtin.find_files {
        hidden = true,
        follow = true,
        no_ignore = true, -- ignore .gitignore/.ignore
        file_ignore_patterns = HOGS,
      }
    end

    local function live_grep_include_ignored()
      -- -uu => --hidden + --no-ignore + --binary (binary is fine; ripgrep skips unreadable)
      local args = { '-uu' }
      for _, pat in ipairs(HOGS) do
        local glob = pat:gsub('%%%.', '.'):gsub('%^', '')
        table.insert(args, '--glob')
        table.insert(args, '!' .. glob)
      end
      builtin.live_grep {
        additional_args = function()
          return args
        end,
      }
    end

    -- Robust git root detection (nvim 0.10+ uses vim.fs; fall back to git CLI)
    local function git_root()
      if vim.fs and vim.fs.root then
        local r = vim.fs.root(0, '.git')
        if r then
          return r
        end
      end
      local ok, out = pcall(vim.fn.systemlist, 'git rev-parse --show-toplevel')
      if ok and vim.v.shell_error == 0 and #out > 0 then
        return out[1]
      end
      return vim.loop.cwd()
    end

    -- Build ripgrep --glob arguments from HOGS (negated)
    local function rg_prune_globs()
      local args = { '--hidden', '--no-follow' } -- see dotfiles; avoid symlink loops
      for _, pat in ipairs(HOGS) do
        table.insert(args, '--glob')
        table.insert(args, '!' .. pat)
      end
      return args
    end

    -- Fast project grep that respects VCS ignore, includes dotfiles, and prunes hogs
    local function live_grep_project()
      local builtin = require 'telescope.builtin'
      builtin.live_grep {
        cwd = git_root(),
        additional_args = rg_prune_globs, -- function returning args is fine
      }
    end

    -- Variant: include ignored (e.g., if .env is git-ignored)
    local function live_grep_include_ignored()
      local builtin = require 'telescope.builtin'
      local args = rg_prune_globs()
      table.insert(args, 1, '-uu') -- = --hidden + --no-ignore + (binary allowed)
      builtin.live_grep {
        cwd = git_root(),
        additional_args = function()
          return args
        end,
      }
    end

    ---- Keymaps ----
    local map = vim.keymap.set
    -- Files
    -- map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>sf', project_files, { desc = '[S]earch [F]iles (smart, fast)' })
    map('n', '<leader>sF', find_files_include_ignored, { desc = '[S]earch [F]iles (include ignored)' })

    -- Grep
    -- map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep (Current Directory)' }) -- Able to find text in current directory
    map('n', '<leader>sg', live_grep_project, { desc = '[S]earch by [G]rep (repo root, fast)' })
    map('n', '<leader>sG', live_grep_include_ignored, { desc = '[S]earch by [G]rep (include ignored)' })

    -- Other
    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    -- map('n', '<leader>sr', builtin.registers, { desc = '[S]earch [R]egisters' })
    map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- In-buffer fuzzy
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Grep open files
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Nvim config files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
