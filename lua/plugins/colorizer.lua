return {
  -- norcalli's original has had no commits since 2024-05 and still calls
  -- vim.tbl_flatten, which Neovim removes in 0.13. This is the maintained fork.
  'catgoose/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      filetypes = { '*', css = { rgb_fn = true } },
    }
  end,
}
