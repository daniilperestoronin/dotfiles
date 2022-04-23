local map = vim.api.nvim_set_keymap

vim.g.mapleader = ' '

-- Files
map('n', '<Leader>ff', ':Telescope find_files<CR>', {noremap = true})
map('n', '<Leader>fg', ':Telescope live_grep<CR>', {noremap = true})
map('n', '<Leader>fb', ':Telescope buffers<CR>', {noremap = true})
map('n', '<Leader>fp', ':Telescope projects<CR>', {noremap = true})
map('n', '<Leader>ft', ':NvimTreeOpen<CR>', {noremap = true})
map('n', '<Leader>fc', ':NvimTreeClose<CR>', {noremap = true})

-- Lsp
map('n', '<Leader>lt', ':SymbolsOutline<CR>', {noremap = true})
map('n', '<Leader>ld', ':Trouble<CR>', {noremap = true})

-- Dap
map('n', '<Leader>db', ':lua require\'dap\'.toggle_breakpoint()<CR>',
    {noremap = true}) -- Creates or removes a breakpoint at the current line.
map('n', '<Leader>dc', ':lua require\'dap\'.continue()<CR>',
    {noremap = true}) -- Removes all breakpoints
map('n', '<Leader>dl', ':lua require\'dap\'.list_breakpoints()<CR>',
    {noremap = true}) -- Lists all breakpoints and log points in quickfix window.

-- Git
map('n', '<Leader>gd', ':DiffviewOpen<CR>', {noremap = true})
map('n', '<Leader>gh', ':DiffviewFileHistory<CR>', {noremap = true})
map('n', '<Leader>gc', ':DiffviewClose<CR>', {noremap = true})
map('n', '<Leader>gb', ':Gitsigns toggle_current_line_blame<CR>',
    {noremap = true})
map('n', '<Leader>gr', ':Gitsigns reset_buffer<CR>', {noremap = true})

-- utils
map('n', '<Leader>s', ':w<CR>', {noremap = true})

map('n', '<Leader>qa', ':qa<CR>', {noremap = true})
map('n', '<Leader>qf', ':q<CR>', {noremap = true})

map('n', '<Leader>n', '<C-w><C-w>', {noremap = true})
map('n', '<Leader>o', '<C-o>', {noremap = true})

