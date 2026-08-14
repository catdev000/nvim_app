return {
  "akinsho/toggleterm.nvim",
  version = "*", -- Use the latest major version to avoid breaking changes
  config = function()
    require("toggleterm").setup({
      size = 20, -- Default size
      open_mapping = [[<c-\>]], -- Optional: Global toggle key
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal", -- Default direction
      close_on_exit = true,
      shell = vim.o.shell,
    })
  end,
}   
