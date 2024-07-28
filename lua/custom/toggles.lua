-- toggle hidden file searching in telescope
function _G.toggle_hidden_file_searching()
  _G.hidden_files = not _G.hidden_files

  require('telescope').setup {
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        (_G.hidden_files and '--hidden' or ''),
      },
    },
    pickers = {
      find_files = {
        hidden = _G.hidden_files,
      },
    },
  }

  print('Telescope hidden files searching: ' .. (_G.hidden_files and 'enabled' or 'disabled'))
end
