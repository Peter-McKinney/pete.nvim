return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-v>'] = 'actions.select_vsplit',
        },
        view_options = {
          show_hidden = true,
        },
      }

      vim.g.loaded_netrw = nil
      vim.g.loaded_netrwPlugin = nil
      -- Open parent directory in current window
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- Open parent directory in floating window
      vim.keymap.set('n', '<space>--', require('oil').toggle_float)
    end,
  },
}
