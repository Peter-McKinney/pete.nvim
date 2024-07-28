vim.api.nvim_set_keymap('n', '<leader>ts', ':lua toggle_hidden_file_searching()<Enter>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':q<Enter>', { silent = true })
vim.keymap.set('n', '<leader>w', ':w<Enter>', { silent = true })

vim.keymap.set('n', '<leader>ns', ':source ~/.config/nvim/init.lua')

-- [[ insert mode maps ]]
vim.keymap.set('i', 'kj', '<Esc>')

-- [[ quick fix lists ]]
vim.keymap.set('n', ']q', ':cnext<Enter>', { silent = true })
vim.keymap.set('n', '[q', ':cprev<Enter>', { silent = true })
vim.keymap.set('n', ']Q', ':clast<Enter>', { silent = true })
vim.keymap.set('n', '[Q', ':cfirst<Enter>', { silent = true })

-- [[ jira ]]
vim.keymap.set('n', '<leader>jo', ':!open_ticket<Enter>', { desc = '[J]ira [O]pen Ticket', silent = true })

-- [[ fugitive ]]
vim.keymap.set('n', '<leader>gb', ':Git blame<Enter>', { desc = '[G]it [b]lame', silent = true })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit<Enter>', { desc = '[G]it [d]iff', silent = true })
vim.keymap.set('n', '<leader>gw', ':GBrowse<Enter>', { desc = '[G]it Bro[w]se', silent = true })
vim.keymap.set('n', '<leader>gP', ':Git push<Enter>', { desc = '[G]it [P]ush', silent = true })
vim.keymap.set('n', '<leader>gl', ':Gclog<Enter>', { desc = '[G]it [L]og', silent = true })
vim.keymap.set('n', '<leader>gh', ':0Gclog<Enter>', { desc = '[G]it [H]istory for File', silent = true })

-- [[ gh cli ]]
vim.keymap.set('n', '<leader>gcp', ':!gh pr view --web<Enter>', { desc = '[G]ithub [C]li [P]R view', silent = true })

vim.keymap.set('n', '<leader>dl', ':diffget //3<Enter>', { desc = '[D]iffget right', silent = true })
vim.keymap.set('n', '<leader>dh', ':diffget //2<Enter>', { desc = '[D]iffget left', silent = true })
vim.keymap.set('n', '<leader>dm', ':Gvdiffsplit!<Enter>', { desc = 'Three Way Diff Merge', silent = true })

-- [[ resize splits ]]
vim.keymap.set('n', '<A-Up>', ':resize -2<Enter>')
vim.keymap.set('n', '<A-Down>', ':resize +2<Enter>')
vim.keymap.set('n', '<A-Left>', ':vertical resize -2<Enter>')
vim.keymap.set('n', '<A-Right>', ':vertical resize +2<Enter>')
vim.keymap.set('n', '<leader>=', '<C-w>=', { desc = 'resize splits equal', silent = true })
vim.keymap.set('n', '<leader>|', '<C-w>|', { desc = 'max width buffer', silent = true })

vim.keymap.set('n', '<leader>pa', function()
  vim.fn.setreg('+', vim.fn.expand '%:p')
end, { desc = 'Copy absolute path', silent = true })

vim.keymap.set('n', '<leader>pr', function()
  vim.fn.setreg('+', vim.fn.expand '%:t')
end, { desc = 'Copy file name', silent = true })

-- [[ sessions ]]
-- telescope extension??
vim.keymap.set('n', '<leader>ms', ':mksession! ~/vim-sessions/pete-session.vim<CR>', { desc = '[S]ave [S]ession Quick' })
vim.keymap.set('n', '<leader>mr', ':source ~/vim-sessions/pete-session.vim<CR>', { desc = '[R]estore [S]ession Quick' })

vim.keymap.set('n', '<leader>mns', ':mksession! ~/vim-sessions/', { desc = '[S]ave [S]ession name' })
vim.keymap.set('n', '<leader>mnr', ':source ~/vim-sessions/', { desc = '[R]estore [S]ession name' })

-- pete custom
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>g^h', require('custom.telescope_pickers').git_diff_files, { desc = 'Search [G]it Diff Files' })
vim.keymap.set('n', '<leader>g^d', require('custom.telescope_pickers').git_diff_develop, { desc = 'Search [G]it Diff Develop' })

vim.keymap.set('n', '<leader>le', require('custom.diagnostics').set_error_diagnostics, { desc = 'Set Error Diagnostics' })

vim.keymap.set('n', '<leader>n', ':noh<Enter>', { desc = '[N]o Highlight' })

vim.keymap.set('n', '<leader>sj', require('telescope.builtin').jumplist, { desc = '[S]earch [J]ump' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>lw', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { desc = 'Search [G]it [S]tatus' })
vim.keymap.set('n', '<leader>gt', require('telescope.builtin').git_stash, { desc = 'Search [G]it S[t]ash' })
-- vim.keymap.set('n', '<leader>fc', require('telescope.builtin').git_commits, { desc = 'Search Git Commits' })
-- vim.keymap.set('n', '<leader>fbc', require('telescope.builtin').git_bcommits, { desc = 'Search Git [B]uffer [C]ommits' })
-- vim.keymap.set('n', '<leader>fbb', require('telescope.builtin').git_branches, { desc = 'Search Git [Branches]' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').search_history, { desc = '[S]earch [P]revious Searches' })
vim.keymap.set('n', '<leader>sq', require('telescope.builtin').quickfixhistory, { desc = '[S]earch [q]uickfix history' })
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').command_history, { desc = '[S]earch [C]ommand history' })

-- Remap <C-a> to <C-b> since I use <C-a> for tmux prefix
vim.api.nvim_set_keymap('n', '<C-b>', '<C-a>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-b>', '<C-a>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-b>', '<C-a>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'g<C-b>', 'g<C-a>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'g<C-b>', 'g<C-a>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'g<C-b>', 'g<C-a>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
