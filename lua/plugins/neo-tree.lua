-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'NC',
    enable_git_status = true,
    enable_diagnostics = true,
    -- Relative line numbers... WARNING - May cause lag
    -- event_handlers = {
    --   {
    --     event = "neo_tree_buffer_enter",
    --     handler = function(arg)
    --       vim.opt_local.relativenumber = true
    --     end,
    --   }
    -- },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['z'] = false,
          ['zc'] = 'close_all_nodes',
        },
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          '.git',
          '.github',
          '.DS_Store',
          'thumbs.db',
        },
      },
    },
    default_component_configs = {
      -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
      file_size = {
        enabled = false,
        width = 12, -- width of the column
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = false,
        width = 10, -- width of the column
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        width = 20, -- width of the column
        required_width = 110, -- min width of window required to show this column
      },
      created = {
        enabled = false,
        width = 20, -- width of the column
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },
  },
}
