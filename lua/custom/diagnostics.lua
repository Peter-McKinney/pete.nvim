local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require('telescope.config').values

local M = {}

local function unique_insert(unique_table, value)
  local exists = false

  for _, v in ipairs(unique_table) do
    if v.ordinal == value.ordinal and v.lnum == value.lnum and v.col == value.col then
      exists = true
      break
    end
  end

  if not exists then
    table.insert(unique_table, value)
  end
end

local function create_build_errors_table(output)
  local build_errors = {}

  for _, line in ipairs(output) do
    local match = string.match(line, 'Error: (.*:%d*%d*)')
    local message = string.match(line, '.*:(.*)')

    if match then
      local file, lnum, col = unpack(vim.split(match, ':'))

      print(file, lnum, col, message)

      print(lnum, col, 'THESE THINGS')

      table.insert(build_errors, {
        display = string.format('%s - %s', file, message),
        value = file,
        filename = file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        message = message,
        ordinal = string.format('%s - %s', file, message),
      })
    end
  end

  return build_errors
end

local function get_lines_from_file(file)
  print(file)
  local err_file = vim.fn.expand(file)
  local lines = vim.fn.readfile(err_file)

  return lines
end

M.set_error_diagnostics = function()
  local output = get_lines_from_file '~/build-errors.txt'
  local build_errors = create_build_errors_table(output)

  M.set_diagnostics(build_errors, 'Build Errors')
end

M.clear_build_errors_file = function()
  local homeDirectory = os.getenv 'HOME'
  local filePath = homeDirectory .. '/' .. 'build-errors.txt'

  --passing empty to clear the file
  vim.fn.writefile({}, filePath)
end

M.set_diagnostics = function(picker_table, prompt_title)
  pickers
    .new({}, {
      prompt_title = prompt_title,
      finder = finders.new_table {
        results = picker_table,
        entry_maker = function(entry)
          return {
            display = entry.display,
            value = entry.value,
            filename = entry.filename,
            lnum = entry.lnum,
            col = entry.col,
            message = entry.message,
            ordinal = entry.ordinal,
          }
        end,
      },
      previewer = previewers.vim_buffer_vimgrep.new {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

return M
