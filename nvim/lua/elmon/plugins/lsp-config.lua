return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { 'lua_ls', 'ts_ls', 'clangd', 'gopls', 'markdown_oxide', 'pylsp', 'jdtls' }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local servers = { 'lua_ls', 'ts_ls', 'clangd', 'gopls', 'pylsp', 'jdtls' }
            for _, server in ipairs(servers) do
                vim.lsp.config(server, {
                    capabilities = capabilities
                })
                vim.lsp.enable(server)
            end

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        end
    }
}
