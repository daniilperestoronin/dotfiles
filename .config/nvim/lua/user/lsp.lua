local v_fn = vim.fn
local v_cmd = vim.cmd
local v_api = vim.api
local v_lsp = vim.lsp
local v_diag = vim.diagnostic

local opts = {noremap = true, silent = true}
v_api.nvim_set_keymap("n", "<space>e",
                      "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
v_api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
v_api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
v_api.nvim_set_keymap("n", "<space>q",
                      "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

local signs = {
    {name = "DiagnosticSignError", text = ""},
    {name = "DiagnosticSignWarn", text = ""},
    {name = "DiagnosticSignHint", text = ""},
    {name = "DiagnosticSignInfo", text = ""}
}

for _, sign in ipairs(signs) do
    v_fn.sign_define(sign.name,
                     {texthl = sign.name, text = sign.text, numhl = ""})
end

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {active = signs},
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = ""
    }
}

v_diag.config(config)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    v_api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    v_api.nvim_buf_set_keymap(bufnr, "n", "gD",
                              "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "gd",
                              "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "K",
                              "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "gi",
                              "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<C-k>",
                              "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>wa",
                              "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                              opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>wr",
                              "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                              opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>wl",
                              "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                              opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>D",
                              "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>rn",
                              "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>ca",
                              "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "gr",
                              "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- null_ls formatting
    v_api.nvim_buf_set_keymap(bufnr, "n", "<space>lf",
                              "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
    v_api.nvim_buf_set_keymap(bufnr, "n", "gl",
                              '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>',
                              opts)

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        v_cmd([[
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

-- Add additional capabilities supported by nvim-cmp
local capabilities = v_lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

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
    server:setup({on_attach = on_attach})
end)

-- neodev setup
local luadev = require("neodev").setup({})
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
