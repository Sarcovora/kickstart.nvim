return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        enable = true
      },
      line_num = {
        enable = true,
        -- style = "#d7827e",
        style = "#c4a7e7",
      }
    })
  end
}

