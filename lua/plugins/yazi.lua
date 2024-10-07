---@type LazySpec
return {
  'mikavilpas/yazi.nvim',
  cond = function()
    return vim.fn.executable 'yazi' == 1
  end,
  event = 'VeryLazy',
  keys = {
    {
      '<leader>-',
      '<cmd>Yazi<cr>',
      desc = 'Open yazi at the current file',
    },
  },
}
