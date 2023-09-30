local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')

local M = {}

local function get_git_diff_data()
    local output = vim.fn.system("git diff HEAD^ HEAD")
    local files = {}
    local current_file
    for line in output:gmatch("[^\r\n]+") do
        if line:match("^diff") then
            current_file = line:match("b/(.*)")
            files[current_file] = {}
        elseif current_file then
            table.insert(files[current_file], line)
        end
    end
    return files
end

M.git_diff_files = function()
    local diff_data = get_git_diff_data()

    local results = {}
    for file, hunks in pairs(diff_data) do
        table.insert(results, {
            value = file,
            ordinal = file,
            display = file,
            diff_hunks = hunks
        })
    end

    pickers.new({}, {
        prompt_title = 'Git Diff Files',
        finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
                return entry
            end
        },
        sorter = require('telescope.sorters').get_fuzzy_file(),
        previewer = previewers.new_buffer_previewer({
            define_preview = function(self, entry, status)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, true, entry.diff_hunks)
		vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'diff')
            end
        }),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("edit " .. selection.value)
            end)
            map('n', '<CR>', function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd("edit " .. selection.value)
            end)
            return true
        end,
    }):find()
end

return M
