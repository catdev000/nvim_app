local M = {}

-- Keymaps are only needed locally and will be removed after startmenu closes 
local function remove_startmenu_keymaps()
  vim.keymap.del("n", "p") -- normally reserved for paste => delete local decleration
  vim.keymap.del("n", "l")
  vim.keymap.del("n", "e")
end

-- Define functions what to do on button clicks
local function open_recent_projects(win)
  require("telescope").extensions.projects.projects() -- Open Telescope's project picker
  vim.api.nvim_create_autocmd("DirChanged", {
    once = true, -- Trigger only once after changing directories
    callback = function()
      require("nvim-tree.api").tree.change_root(vim.fn.getcwd()) -- Update NvimTree root
      require("nvim-tree.api").tree.reload() -- Refresh NvimTree
    end,
  })
  remove_startmenu_keymaps()
  vim.api.nvim_win_close(win, true)
end

local function open_lazy_menu(win)
  vim.cmd("Lazy sync")
  remove_startmenu_keymaps()
  vim.api.nvim_win_close(win, true)
end

local function open_settings(win)
  require("configs.settings").open()
  remove_startmenu_keymaps()
  vim.api.nvim_win_close(win, true)
end

function M.open()
  local current_win = vim.api.nvim_get_current_win()
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2.5)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set content
  local content = {
    "             Nvim App              ",
    "  ",
    "       Open recent projects [p]    ",
    "  ",
    "    Open and update plugins [l]    ",
    "  ",
    "             Settings [e]          ",
    "  ",
    "            Exit Menu [q]          ",
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  
  -- Add a highlight group if it doesn't exist
  if vim.fn.hlexists("PopupButton") == 0 then
    vim.api.nvim_set_hl(0, "PopupButton", { bg = "#444444", fg = "#ffffff", bold = true })
  end
  
  -- Highlight the text of the button line (line, position_from, position_to)
  vim.api.nvim_buf_add_highlight(buf, -1, "PopupButton", 2, 2, 40)
  vim.api.nvim_buf_add_highlight(buf, -1, "PopupButton", 4, 2, 40)
  vim.api.nvim_buf_add_highlight(buf, -1, "PopupButton", 6, 2, 40)

  -- Map <CR> to a function based on button line clicked
  vim.keymap.set("n", "<CR>", function()
    local current_line = vim.api.nvim_get_current_line()
    local recent_projects_text = "recent projects"
    local plugins_manager_text = "plugins"
    local settings_text = "Settings"

    -- Check if the current line contains the button text
    if string.find(current_line, recent_projects_text) then
      open_recent_projects(win)
    elseif string.find(current_line, plugins_manager_text) then
      open_lazy_menu(win)
    elseif string.find(current_line, settings_text) then
      open_settings(win)
    end
  end, {
    buffer = buf,
    silent = true,
    desc = "Trigger button if on button line"
  })
  
  vim.keymap.set("n", "p", function()
    open_recent_projects(win)
  end)

  vim.keymap.set("n", "l", function()
    open_lazy_menu(win)
  end)

  vim.keymap.set("n", "e", function()
    open_settings(win)
  end)

  -- Close with 'q'
  vim.keymap.set("n", "q", function()
    remove_startmenu_keymaps()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, silent = true })

  -- Disable numbers
  vim.api.nvim_set_option_value("number", false, { win = win })
  vim.api.nvim_set_option_value("relativenumber", false, { win = win })
end

return M
