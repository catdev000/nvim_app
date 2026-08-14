local M = {}

function M.openAIWindow()
    -- Move to the right window and open a vertical split
    vim.cmd("wincmd l")
    vim.cmd("vsplit")

    -- Create a scratch buffer for user input
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)

    -- Set buffer options
    vim.bo[buf].buftype = "nofile" -- Prevent writing to disk
    vim.bo[buf].bufhidden = "wipe" -- Automatically delete buffer when closed
    vim.bo[buf].filetype = "chat" -- Optional: Set custom filetype

    -- Insert initial text for the chat
    local initial_text = { "User: " }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_text)

    -- Enter insert mode immediately
    vim.cmd("startinsert")

    -- Move cursor to the end of the constant text for user input
    vim.api.nvim_win_set_cursor(0, { #initial_text, 6 }) -- Line 1, column after "User: "

    -- Map <CR> in insert mode for this buffer
    vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', [[<Esc>:lua require('configs.buddy').process_input()<CR>]], {
        noremap = true,
        silent = true,
    })

    -- Store the buffer for later use in process_input()
    M.current_buf = buf
end

function M.test()
    print("hello")
end

-- Function to process user input when <CR> is pressed
function M.process_input()
    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()

    -- Get the current content of the buffer
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    if #lines > 0 then
        -- Get the last line (user's input)
        local last_line = lines[#lines]

        -- Extract text after "User: " (assuming user input starts with "User: ")
        local user_input = last_line:sub(7) -- Extract text starting from the 7th character

        if #user_input > 0 then
            -- Generate Buddy's response
            local buddy_response = "Buddy: your text was " .. user_input

            -- Append Buddy's response below the user's input
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { buddy_response })

            -- Add a new prompt for the next user input
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "User: " })

            -- Move cursor to the end of the new prompt
            local new_line_count = vim.api.nvim_buf_line_count(buf)
            vim.api.nvim_win_set_cursor(0, { new_line_count, 6 }) -- Line X+1, column after "User: "
        else
            print("Buddy: No input was provided.")
        end
    else
        print("Buddy: Buffer is empty.")
    end

    -- Re-enter insert mode after processing input
    vim.cmd("startinsert")
end

return M

