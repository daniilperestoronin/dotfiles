local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
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

local use = require("packer").use
require("packer").startup(function()
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
        config = function() require("telescope").setup({}) end
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
    use("Pocco81/DAPInstall.nvim")

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

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd([[colorscheme nord]])

-- LSP config
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap("n", "<space>e",
                        "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>",
                        opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>",
                        opts)
vim.api.nvim_set_keymap("n", "<space>q",
                        "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD",
                                "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd",
                                "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K",
                                "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi",
                                "<cmd>lua vim.lsp.buf.implementation()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>",
                                "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa",
                                "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr",
                                "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wl",
                                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D",
                                "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn",
                                "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca",
                                "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr",
                                "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- null_ls formatting
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lf",
                                "<cmd>lua vim.lsp.buf.formatting_sync()<CR>",
                                opts)

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            hi! LspReferenceRead cterm=bold ctermbg=red guibg=#4C566A
            hi! LspReferenceText cterm=bold ctermbg=red guibg=#4C566A
            hi! LspReferenceWrite cterm=bold ctermbg=red guibg=#4C566A
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
          ]], false)
    end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    "bashls", "cssls", "dockerls", "eslint", "gopls", "golangci_lint_ls",
    "groovyls", "html", "jsonls", "jdtls", "tsserver", "kotlin_language_server",
    "ltex", "sumneko_lua", "remark_ls", "pyright", "sqlls", "vuels", "lemminx",
    "yamlls"
}

local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
}

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    sources = {{name = "nvim_lsp"}, {name = "luasnip"}},
    formatting = {
        fields = {"abbr", "kind", "menu"},
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s  %s", kind_icons[vim_item.kind],
                                          vim_item.kind)
            vim_item.menu = ({
                nvim_lsp = "LSP",
                luasnip = "Snippet",
                buffer = "Buffer",
                path = "Path"
            })[entry.source.name]
            return vim_item
        end
    }
})

for _, lsp in pairs(servers) do
    require("lspconfig")[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150
        }
    })
end

-- LSP install servers
local lsp_installer = require("nvim-lsp-installer")
-- Include the servers you want to have installed by default below
for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
    local opts = {on_attach = on_attach}
    server:setup(opts)
end)

-- lua-dev setup
local luadev = require("lua-dev").setup({})
local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup(luadev)

-- ray-x/lsp_signature.nvim conf
require("lsp_signature").setup({hint_prefix = ""})

-- nul-ls setup
local null_ls = require("null-ls")
null_ls.setup({
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    sources = {
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.code_actions.proselint,
        null_ls.builtins.code_actions.statix, null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.luacheck,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.protoc_gen_lint,
        null_ls.builtins.diagnostics.protolint,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.eslint, null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.google_java_format,
        null_ls.builtins.formatting.json_tool,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.formatting.pg_format,
        null_ls.builtins.formatting.protolint,
        null_ls.builtins.formatting.stylelint, null_ls.builtins.formatting.tidy
    }
})

-- DAP
local dap_install = require("dap-install")

dap_install.setup({installation_path = vim.fn.stdpath("data") .. "/dapinstall/"})
dap_install.config("python", {})
