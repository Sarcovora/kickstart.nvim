return {
  'rebelot/heirline.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    local heirline = require 'heirline'
    local conditions = require 'heirline.conditions'
    local utils = require 'heirline.utils'

    -- Rosé Pine colors
    local colors = {
      base = '#191724',
      surface = '#1f1d2e',
      overlay = '#26233a',
      muted = '#6e6a86',
      subtle = '#908caa',
      text = '#e0def4',
      love = '#eb6f92',
      gold = '#f6c177',
      rose = '#ebbcba',
      pine = '#31748f',
      foam = '#9ccfd8',
      iris = '#c4a7e7',
      highlight_low = '#21202e',
      highlight_med = '#403d52',
      highlight_high = '#524f67',
    }

    -- Utility functions
    local function get_diagnostic_counts()
      local counts = { error = 0, warn = 0, info = 0, hint = 0 }
      local diagnostics = vim.diagnostic.get(0)
      for _, diagnostic in ipairs(diagnostics) do
        local severity = diagnostic.severity
        if severity == vim.diagnostic.severity.ERROR then
          counts.error = counts.error + 1
        elseif severity == vim.diagnostic.severity.WARN then
          counts.warn = counts.warn + 1
        elseif severity == vim.diagnostic.severity.INFO then
          counts.info = counts.info + 1
        elseif severity == vim.diagnostic.severity.HINT then
          counts.hint = counts.hint + 1
        end
      end
      return counts
    end

    -- Shared mode colors table
    local mode_colors = {
      n = 'subtle',
      i = 'foam',
      v = 'iris',
      V = 'iris',
      ['\22'] = 'iris',
      c = 'gold',
      s = 'rose',
      S = 'rose',
      ['\19'] = 'rose',
      R = 'love',
      r = 'love',
      ['!'] = 'love',
      t = 'pine',
    }

    -- Function to get current mode color
    local function get_mode_color()
      local mode = vim.fn.mode(1):sub(1, 1)
      return mode_colors[mode] or 'subtle'
    end

    -- Mode component
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          n = 'N',
          no = 'N?',
          nov = 'N?',
          noV = 'N?',
          ['no\22'] = 'N?',
          niI = 'Ni',
          niR = 'Nr',
          niV = 'Nv',
          nt = 'Nt',
          v = 'V',
          vs = 'Vs',
          V = 'V_',
          Vs = 'Vs',
          ['\22'] = '^V',
          ['\22s'] = '^V',
          s = 'S',
          S = 'S_',
          ['\19'] = '^S',
          i = 'I',
          ic = 'Ic',
          ix = 'Ix',
          R = 'R',
          Rc = 'Rc',
          Rx = 'Rx',
          Rv = 'Rv',
          Rvc = 'Rv',
          Rvx = 'Rv',
          c = 'C',
          cv = 'Ex',
          r = '...',
          rm = 'M',
          ['r?'] = '?',
          ['!'] = '!',
          t = 'T',
        },
        mode_colors = mode_colors,
      },
      utils.surround({ '', '' }, function(self)
        local mode = self.mode:sub(1, 1)
        return self.mode_colors[mode] or 'subtle'
      end, {
        provider = function(self)
          return ' ' .. self.mode_names[self.mode] .. ' '
        end,
        hl = { fg = 'base', bold = true },
      }),
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
    }

    -- Git branch with icon
    local GitBranch = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.show_full = false
      end,
      utils.surround({ '', '' }, 'surface', {
        provider = function(self)
          local branch = self.status_dict and self.status_dict.head or ''
          if branch == '' then
            return '󰊢 '
          end

          -- Show full branch name if clicked or if it's short enough
          if self.show_full or #branch <= 35 then
            return '󰊢 ' .. branch
          else
            -- Truncate long branch names
            return '󰊢 ' .. branch:sub(1, 32) .. '...'
          end
        end,
        hl = { fg = 'pine', bold = true },
        on_click = {
          callback = function(self)
            self.show_full = not self.show_full
            vim.cmd 'redrawstatus'
            -- Auto-hide after 3 seconds
            if self.show_full then
              vim.defer_fn(function()
                self.show_full = false
                vim.cmd 'redrawstatus'
              end, 3000)
            end
          end,
          name = 'heirline_git_branch',
        },
      }),
    }

    -- File components
    local FileIcon = {
      init = function(self)
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FilePath = {
      provider = function()
        local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.:h')
        if filepath == '' or filepath == '.' then
          return ''
        end
        return filepath .. '/'
      end,
      hl = { fg = 'muted' },
    }

    local FileName = {
      provider = function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
        if filename == '' then
          return '[No Name]'
        end
        return filename
      end,
      hl = { fg = 'text', bold = true },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = ' ●',
        hl = { fg = 'gold' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = ' ',
        hl = { fg = 'love' },
      },
    }

    -- Git diff with colors
    local GitDiff = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict or {}
      end,
      {
        provider = function(self)
          return self.status_dict.added and self.status_dict.added > 0 and ('+' .. self.status_dict.added) or ''
        end,
        hl = { fg = 'foam' },
      },
      {
        provider = function(self)
          return self.status_dict.changed and self.status_dict.changed > 0 and (' ~' .. self.status_dict.changed) or ''
        end,
        hl = { fg = 'gold' },
      },
      {
        provider = function(self)
          return self.status_dict.removed and self.status_dict.removed > 0 and (' -' .. self.status_dict.removed) or ''
        end,
        hl = { fg = 'love' },
      },
    }

    -- Diagnostics with icons
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      init = function(self)
        self.counts = get_diagnostic_counts()
        self.diagnostic_icons = vim.g.have_nerd_font
            and {
              error = '󰅚',
              warn = '󰀪',
              info = '󰋽',
              hint = '󰌶',
            }
          or {
            error = 'E',
            warn = 'W',
            info = 'I',
            hint = 'H',
          }
      end,
      {
        provider = function(self)
          return self.counts.error > 0 and (self.diagnostic_icons.error .. self.counts.error) or ''
        end,
        hl = { fg = 'love' },
      },
      {
        provider = function(self)
          return self.counts.warn > 0 and (' ' .. self.diagnostic_icons.warn .. self.counts.warn) or ''
        end,
        hl = { fg = 'gold' },
      },
      {
        provider = function(self)
          return self.counts.info > 0 and (' ' .. self.diagnostic_icons.info .. self.counts.info) or ''
        end,
        hl = { fg = 'foam' },
      },
      {
        provider = function(self)
          return self.counts.hint > 0 and (' ' .. self.diagnostic_icons.hint .. self.counts.hint) or ''
        end,
        hl = { fg = 'iris' },
      },
    }

    -- Indent info
    local IndentInfo = {
      provider = function()
        local indent_type = vim.bo.expandtab and 'Spaces' or 'Tabs'
        local indent_size = vim.bo.expandtab and vim.bo.shiftwidth or vim.bo.tabstop
        return indent_type .. ':' .. indent_size
      end,
      hl = { fg = 'subtle' },
    }

    -- LSP Active with icon
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        local lsp_icon = vim.g.have_nerd_font and ' ' or 'LSP:'
        return lsp_icon .. table.concat(names, ' ')
      end,
      hl = { fg = 'pine' },
    }

    -- File type with icon
    local FileType = {
      init = function(self)
        local ft = vim.bo.filetype
        local icon, color = require('nvim-web-devicons').get_icon_by_filetype(ft, { default = true })
        self.ft_icon = icon or ''
        self.ft_color = color or colors.iris
      end,
      provider = function(self)
        return self.ft_icon .. ' ' .. vim.bo.filetype
      end,
      hl = { fg = 'iris' },
    }

    -- Ruler (position) with mode-synchronized background
    local Ruler = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      utils.surround({ '', '' }, get_mode_color, {
        provider = ' %l:%c ',
        hl = { fg = 'base', bold = true },
      }),
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
    }

    local Space = { provider = ' ' }
    local Align = { provider = '%=' }

    -- Assemble statusline
    local StatusLine = {
      hl = { bg = 'base' },
      -- Left side
      ViMode,
      Space,
      GitBranch,
      Space,
      -- FileIcon,
      FilePath,
      FileName,
      FileFlags,
      -- Center
      Align,
      -- Right side
      GitDiff,
      -- Space,
      Diagnostics,
      Space,
      IndentInfo,
      -- Space,
      LSPActive,
      Space,
      -- FileType,
      -- Space,
      Ruler,
    }

    -- Load colors first
    heirline.load_colors(colors)

    -- Setup heirline
    heirline.setup {
      statusline = StatusLine,
    }
  end,
}
