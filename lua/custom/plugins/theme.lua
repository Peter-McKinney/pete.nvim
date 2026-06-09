return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        integrations = {
          treesitter = true,
          -- add others you use, e.g.:
          -- telescope = true,
          -- gitsigns = true,
          -- which_key = true,
          -- mason = true,
          -- blink_cmp = true,
        },
      }
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
