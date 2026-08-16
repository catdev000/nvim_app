require "nvchad.mappings"

-- add yours here -- customized settings

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>fp", function()
  require("telescope").extensions.projects.projects() -- Open Telescope's project picker
  vim.api.nvim_create_autocmd("DirChanged", {
    once = true, -- Trigger only once after changing directories
    callback = function()
      require("nvim-tree.api").tree.change_root(vim.fn.getcwd()) -- Update NvimTree root
      require("nvim-tree.api").tree.reload() -- Refresh NvimTree
    end,
  })
end, { desc = "[F]ind [P]rojects" })

map("n", "<leader>ls", function()
  if vim.fn.executable("live-server") == 1 then
    local Terminal = require("toggleterm.terminal").Terminal
    local live_server = Terminal:new({
      cmd="live-server",
      direction="horizontal",
      close_on_exit= false
    })
    live_server:toggle()
  else
    vim.notify(
      "Please install live-server with: npm install -g live-server",
      vim.log.levels.ERROR,
      { title = "Live Server Missing" }
    )
  end
end, { desc = "[L]ive [S]erver (standard html projects)"})

map("n", "<leader>a", function()
  require("configs.buddy").openAIWindow()
end, { desc= "Open Ollama Chat Window", noremap = true, silent = true })
