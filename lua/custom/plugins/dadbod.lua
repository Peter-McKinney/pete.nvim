return {
  {
    'tpope/vim-dadbod',
    lazy = true,
    cmd = { 'DB' },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql', 'postgresql' },
        dependencies = {
          'tpope/vim-dadbod',
        },
        init = function()
          vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'sql', 'mysql', 'plsql', 'postgresql' },
            callback = function()
              vim.bo.omnifunc = 'vim_dadbod_completion#omni'
            end,
          })
        end,
      },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath 'data' .. '/db_ui'

      -- Optional: one or more saved connections
      vim.g.dbs = {
        fhir = string.format(
          'postgres://%s:%s@%s:%s/%s',
          os.getenv 'DB_USERNAME',
          os.getenv 'DB_PASSWORD',
          os.getenv 'DB_HOST' or '127.0.0.1',
          os.getenv 'DB_PORT' or '5432',
          os.getenv 'DB_NAME'
        ),
        sfapidb = 'mysql://root:password@127.0.0.1:3306/qpp-submissions-feedback-api-db',
      }
    end,
  },
}
