-- NOTE: May need to run the following for this to work:
-- :Lazy build markdown-preview.nvim
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
  -- build = 'cd app; sudo yarn install',
  -- init = function()
  --   vim.g.mkdp_filetypes = { 'markdown' }
  -- end,
  ft = { 'markdown' },

  build = function()
    vim.fn['mkdp#util#install']()
  end,

  config = function()
    vim.keymap.set('n', '<leader>p', ':MarkdownPreviewToggle<CR>', { desc = 'Markdown Preview Toggle' })

    -- vim.g.mkdp_markdown_css = '/Users/ekuo/.config/nvim/lua/plugins/plugin-data/md.css'
    vim.g.mkdp_markdown_css = '/Users/ekuo/.config/nvim/lua/plugins/plugin-data/github_md.css'
    vim.g.mkdp_highlight_css = '/Users/ekuo/.config/nvim/lua/plugins/plugin-data/mdhl.css'
  end,
}
