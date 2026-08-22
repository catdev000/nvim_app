local M = {}

local function create_settings_if_not_exists()
  local fn = vim.fn
  local uv = vim.uv or vim.loop

  local data_dir = fn.stdpath("data")
  local settings_path = data_dir .. "/settings.json"

  if fn.isdirectory(data_dir) == 0 then
    -- "p" flag creates parent directories recursively if needed
    fn.mkdir(data_dir, "p")
  end

  if uv.fs_stat(settings_path) == nil then
    -- Define default settings
    local default_settings = {
      darkmode = true
    }

    -- Encode Lua table to JSON string
    local json_content = vim.json.encode(default_settings)

    -- Write to file
    local file = io.open(settings_path, "w")
    if file then
      file:write(json_content)
      file:close()
      print("Created settings.json at: " .. settings_path)
    else
      print("Error: Could not create settings.json at " .. settings_path)
    end
  end
end

local function get_path()
  return vim.fn.stdpath("data") .. "/settings.json"
end

function M.read_settings() -- make it global so init.lua etc. can initialize settings
  local path = get_path()
  local file = io.open(path, "r")
  if not file then return {} end

  local content = file:read("*a")
  file:close()
  
  local ok, data = pcall(vim.json.decode, content)
  if not ok then
    vim.notify("Failed to parse JSON store: " .. data, vim.log.levels.WARN)
    return {}
  end
  return data or {}
end

local function write_setting(data)
  local path = get_path()
  local file = io.open(path, "w")
  if not file then return false end
  
  -- Encode with indentation for readability
  local content = vim.json.encode(data, { indent = "  " })
  file:write(content)
  file:close()
  return true
end

local function display_settings(text, settings)
  for key,value in pairs(settings) do
    if value == true then
      value = "[x]"
    else
      value = "[ ]"
    end
    table.insert(
      text,
      "  " .. key .. " " .. value
    )
  end
  table.insert(text, " ")
  table.insert(text, "  Go Back")
  return text
end

local function settings_window(mode)
  
  if (mode == "reload") then
      vim.cmd("q") 
  end


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

  local settings = M.read_settings() 

  -- Set content and add settings from settings.json to it
  local content = display_settings(
    {
        "  Settings ( press Enter to toggle )  ",
        "  "
    },
    settings
  )
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

end

local function toggle_darkmode()
  require("base46").toggle_theme() -- switch between dark and light mode
  local settings = M.read_settings()
  settings["darkmode"] = not settings["darkmode"]
  write_setting(settings) -- update settings in json file

  settings_window("reload")
end

function M.open()
  create_settings_if_not_exists()

  -- vim.notify(vim.json.encode(read_settings(), { indent = "  " }), "info") -- TODO remove debugging
  settings_window("create")

  -- Map <CR> to a function based on button line clicked
  vim.keymap.set("n", "<CR>", function()
    local current_line = vim.api.nvim_get_current_line()
    local darkmode_text = "darkmode"
    local back_text = "Back"

    -- Check if the current line contains the button text
    if string.find(current_line, darkmode_text) then
      toggle_darkmode()
    elseif string.find(current_line, back_text) then
      vim.cmd("q")
      require("configs.startmenu").open()
    end
  end, {
    buffer = buf,
    silent = true,
    desc = "Trigger button if on button line"
  })

end

return M
