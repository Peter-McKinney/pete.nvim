local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values
local inspect = require('vim.inspect')
local actions = require('telescope.actions')
local make_entry = require('telescope.make_entry')

local M = {}

local function extract_lint_issues(output)
    local issues = {}
    local current_file

    for line in output:gmatch("[^\r\n]+") do
        if line:match("^/") then
            current_file = line
        else
            local lnum, col, issue_type, message = line:match("(%d+):(%d+)%s+(%w+)%s+(.+)")
            if lnum then
                table.insert(issues, {
                    display = string.format("%s - %s", current_file, issue_type),
                    value = current_file,
                    filename = current_file,
                    lnum = tonumber(lnum),
                    col = tonumber(col),
                    message = message,
                    ordinal = current_file,
                })
            end
        end
    end

    return issues
end

M.show = function()
    vim.cmd("botright new")
    vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap")
    vim.cmd("setlocal filetype=log") -- Optional: For better text readability

    local bufnr = vim.api.nvim_get_current_buf()

    local bufnr = vim.api.nvim_get_current_buf()
    local function on_lint_output(_, data, _)
        if data then
            for _, line in ipairs(data) do
                if line and line ~= "" then
                    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { line })
                end
            end
        end
    end


    -- Start the lint process asynchronously
    vim.fn.jobstart("npm run lint", {
        on_stdout = on_lint_output,
        on_exit = function(j, exit_code, _)
            -- If linting process succeeds, capture the output and display in Telescope picker
            print("Buffer number: ", bufnr)
            local cmd_output = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local lint_issues = extract_lint_issues(table.concat(cmd_output, "\n"))

            print(vim.inspect(lint_issues))

            pickers.new({}, {
                prompt_title = 'NPM Lint Issues',
                finder = finders.new_table {
                    results = lint_issues,
                    entry_maker = function(entry)
                        return {
                            display = entry.display,
                            value = entry.value,
                            filename = entry.filename,
                            lnum = entry.lnum,
                            col = entry.col,
                            message = entry.message,
                            ordinal = entry.ordinal
                        }
                    end
                },
                previewer = previewers.vim_buffer_vimgrep.new({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end
    })
end

return M
