return {
  "nvim-tree/nvim-tree.lua",
  enabled = true,
  config = function()
    require("nvim-tree").setup({
      filters = {
        git_ignored = false, 
        dotfiles = false,
        custom = {},
      },
    })
  end,
}
