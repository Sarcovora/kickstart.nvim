local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

vim.api.nvim_set_hl(0, 'StatusLineFilenameBox', {
  bold = true,
  italic = true,
  fg = '#191724',
  bg = '#c4a7e7',
})

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_filename = function()
  -- Check if this is a real file buffer
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype

  -- Skip special buffers (quickfix, help, terminal, etc.)
  if buftype ~= '' then
    return ''
  end

  -- Skip specific filetypes you don't want (outline, file explorers, etc.)
  local skip_filetypes = {
    'qf', -- quickfix
    'help', -- help files
    'Outline', -- outline buffer
    'neo-tree', -- neo-tree file explorer
    'NvimTree', -- nvim-tree
    'Trouble', -- trouble.nvim
    'lspinfo', -- LSP info
    'TelescopePrompt', -- Telescope
    'lazy', -- lazy.nvim
    'mason', -- mason.nvim
  }

  for _, ft in ipairs(skip_filetypes) do
    if filetype == ft then
      return ''
    end
  end

  local filename = vim.fn.expand '%:t'
  local filepath = vim.fn.expand '%:h'

  if filename == '' then
    filename = '[No Name]'
  end

  -- Add modification indicator
  local modified = vim.bo.modified and ' ●' or ''

  -- Create the filename box with padding
  local filename_box = '%#StatusLineFilenameBox# ' .. filename .. modified .. ' %*'

  if filepath == '.' or filepath == '' then
    return filename_box
  else
    -- Filename box + path in normal statusline color
    return filepath .. '/' .. filename_box
  end
end

---@diagnostic disable-next-line: duplicate-set-field
-- Disable the diff section
statusline.section_diff = function()
  return ''
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v' -- LINE:COLUMN
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_fileinfo = function()
  local filetype = vim.bo.filetype
  if filetype == '' then
    return ''
  end

  -- Get filetype icon if available
  local icon = ''
  if vim.g.have_nerd_font then
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
      local ft_icon = devicons.get_icon_by_filetype(filetype)
      if ft_icon then
        icon = ft_icon .. ' '
      end
    end
  end

  -- Add LSP info right next to filetype
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  local lsp_info = ''
  if #clients > 0 then
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    local lsp_icon = vim.g.have_nerd_font and '󰰎' or 'LSP'
    lsp_info = lsp_icon .. ' ' .. table.concat(client_names, ',')
  end

  return lsp_info .. ' ' .. icon .. filetype
end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_lsp = function()
  -- LSP info is now handled in section_fileinfo
  return ''
end

-- Custom section for indent info
statusline.section_indent = function()
  local expandtab = vim.bo.expandtab
  local shiftwidth = vim.bo.shiftwidth
  local tabstop = vim.bo.tabstop

  if expandtab then
    return 'Spaces:' .. shiftwidth
  else
    return 'Tabs:' .. tabstop
  end
end

-- Setup custom content layout after all sections are defined
statusline.config.content = {
  active = function()
    local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
    local git = statusline.section_git { trunc_width = 75 }
    local diff = statusline.section_diff { trunc_width = 75 }
    local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
    local lsp = statusline.section_lsp { trunc_width = 75 }
    local filename = statusline.section_filename { trunc_width = 140 }
    local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
    local search = statusline.section_searchcount { trunc_width = 75 }
    local location = statusline.section_location { trunc_width = 75 }
    local indent = statusline.section_indent { trunc_width = 75 }

    return statusline.combine_groups {
      { hl = mode_hl, strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment (everything after goes to right side)
      { hl = 'MiniStatuslineFileinfo', strings = { diagnostics, lsp, indent, fileinfo } },
      { hl = mode_hl, strings = { search, location } },
    }
  end,
}
