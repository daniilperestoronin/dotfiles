local v_fn = vim.fn
local v_cmd = vim.cmd

-- Automatically install packer
local install_path = v_fn.stdpath("data") ..
                         "/site/pack/packer/start/packer.nvim"
if v_fn.empty(v_fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = v_fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
    })
    print("Installing packer close and reopen Neovim...")
    v_cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
v_cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end
    }
})

packer.startup(function(use)
    -- Package manager
    use("wbthomason/packer.nvim")

    -- Color scheme
    use("arcticicestudio/nord-vim")
    use({
        "nvim-lualine/lualine.nvim",
        requires = {"kyazdani42/nvim-web-devicons", opt = true},
        config = function() require("lualine").setup() end
    })
    use({
        "akinsho/bufferline.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    offsets = {{filetype = "NvimTree", text = "File Explorer"}},
                    diagnostics = "nvim_lsp",
                    show_tab_indicators = false,
                    separator_style = "slant"
                }
            })
        end
    })
    use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight

    -- Navigation
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function() require("nvim-tree").setup({}) end
    })
    use("majutsushi/tagbar")
    use({
        "nvim-telescope/telescope.nvim",
        requires = {{"nvim-lua/plenary.nvim"}},
        config = function()
            require("telescope").setup({
                pickers = {find_files = {hidden = true}}
            })
        end
    })

    -- LSP
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "java", "javascript", "python", "go", "lua", "html", "css",
                    "vue", "json", "yaml", "kotlin", "scala", "rust"
                },
                highlight = {enable = true}
            })
        end
    })
    use({
        "folke/trouble.nvim", -- list for showing diagnostics, references, telescope results, quickfix
        requires = "kyazdani42/nvim-web-devicons",
        config = function() require("trouble").setup({}) end
    })
    -- Collection of configurations for built-in LSP client
    use("neovim/nvim-lspconfig")
    use("williamboman/nvim-lsp-installer")
    -- Autocompletion
    use("hrsh7th/nvim-cmp") -- Autocompletion plugin
    use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
    use("L3MON4D3/LuaSnip") -- Snippets plugin
    use("simrat39/symbols-outline.nvim") -- A tree like view for symbols using the Lsp
    use("ray-x/lsp_signature.nvim") -- Show function signature when you type
    use("jose-elias-alvarez/null-ls.nvim")
    use("nvim-lua/plenary.nvim")

    -- DAP
    use('mfussenegger/nvim-dap')
    use {"rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}}
    use 'mfussenegger/nvim-dap-python'

    -- integration with git
    use({
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function() require("gitsigns").setup() end
    })
    use {'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim'}

    -- Comments
    use({
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    })

    -- Greeter
    use({
        "goolord/alpha-nvim",
        requires = {"kyazdani42/nvim-web-devicons"},
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end
    })

    -- Key bindings
    use({
        "folke/which-key.nvim",
        config = function() require("which-key").setup({}) end
    })

    -- Project detecting
    use({
        "ahmedkhalf/project.nvim",
        config = function() require("project_nvim").setup({}) end
    })

    -- dev setup for init.lua
    use("folke/lua-dev.nvim")

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then require("packer").sync() end
end)
