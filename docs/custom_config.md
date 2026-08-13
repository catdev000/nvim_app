## Custom Configuration of Neovim by NvChad and nvim_app

### NvChad
First component is the NvChad preconfiguration, which can be found on github
[Github Repo](https://github.com/NvChad/NvChad)

### Autostart configurations
Under init.lua (customized settings)

#### Open NvimTree on start of nvim
```
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.cmd("NvimTreeToggle") -- Open nvim-tree
    vim.cmd("NvimTreeResize 35")
	end,
})
```

### Added Plugins
Under lua/plugins.lua

#### nvim-lspconfig (Language Server for static code analyzation)
```
{
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
},
```

#### project_nvim (Detect Projects and add them to recent projects)
```
{
    "ahmedkhalf/project.nvim",
    lazy = false, -- Load immediately
    config = function()
        require("project_nvim").setup({
            detection_methods = { "pattern", "lsp" },
            patterns = { ".git", "Makefile", "package.json", "LICENSE" },
            exclude_dirs = {}
        })
    end,
}
```

#### render_markown (Formats md files)
```
{
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
}
```


### Custom Mappings
Under lua/mappings.lua

#### Add Project selection (Space + f + p)
```
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
```

#### Start live-server for websites (Space + l + s)
```
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
```

#### Open Ollama window
```
map("n", "<leader>a", function()
  require("configs.buddy").openAIWindow()
end, { desc= "Open Ollama Chat Window", noremap = true, silent = true })
```
