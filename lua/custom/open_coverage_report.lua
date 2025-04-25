local M = {}

local function escape_pattern(text)
  return text:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])', '%%%1')
end

local function get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return cursor[1]
end

local function get_file_path()
  local prefix_to_remove = '/Users/43159/github/qpp-submission-client'

  local file_path = vim.api.nvim_buf_get_name(0)
  local sanitized_file_path = string.gsub(file_path, escape_pattern(prefix_to_remove), '')

  return sanitized_file_path
end

local function get_line_fragment_identifier()
  local line_number = get_current_line()
  return string.format('#L%s', line_number)
end

M.open_coverage_at_current_line = function()
  local line_number_identifier = get_line_fragment_identifier()
  local file_path = get_file_path()
  local coverage_path = 'http://localhost:8080' .. file_path .. '.html' .. line_number_identifier
  print(coverage_path)
  vim.fn.system('open ' .. coverage_path)
end

return M
