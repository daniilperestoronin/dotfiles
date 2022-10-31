local o = vim.o
local cmd = vim.cmd

-- Set colorscheme
o.termguicolors = true

require('onedark').setup {
    style = 'warm'
}
require('onedark').load()

