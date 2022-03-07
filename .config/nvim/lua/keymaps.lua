local map = vim.api.nvim_set_keymap


vim.g.mapleader = ' '

map('n', '<Leader>ff', ':Telescope find_files<CR>', {noremap = true})
map('n', '<Leader>fg', ':Telescope live_grep<CR>', {noremap = true})
map('n', '<Leader>fb', ':Telescope buffers<CR>', {noremap = true})
map('n', '<Leader>fp', ':Telescope projects<CR>', {noremap = true})

map('n', '<Leader>ft', ':NvimTreeOpen<CR>', {noremap = true})
map('n', '<Leader>fc', ':NvimTreeClose<CR>', {noremap = true})

map('n', '<Leader>lt', ':SymbolsOutline<CR>', {noremap = true})
map('n', '<Leader>ld', ':Trouble<CR>', {noremap = true})

map('n', '<Leader>s', ':w<CR>', {noremap = true})

map('n', '<Leader>qa', ':qa<CR>', {noremap = true})
map('n', '<Leader>qf', ':q<CR>', {noremap = true})

