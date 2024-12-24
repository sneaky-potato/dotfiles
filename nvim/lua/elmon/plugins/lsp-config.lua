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
                ensure_installed = { 'lua_ls', 'tsserver', 'clangd', 'gopls', 'markdown_oxide', 'pylsp', 'jdtls'}
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            -- Setup language servers here
            -- 
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.tsserver.setup({
                capabilities = capabilities
            })
            lspconfig.clangd.setup({
                capabilities = capabilities
            })
            lspconfig.gopls.setup({
                capabilities = capabilities
            })
            lspconfig.pylsp.setup({
                capabilities = capabilities
            })
            lspconfig.jdtls.setup({
                capabilities = capabilities
            })

            Map('n', 'K', vim.lsp.buf.hover, {})
            Map('n', 'gd', vim.lsp.buf.definition, {})
            Map('n', '<leader>ca', vim.lsp.buf.code_action, {})
        end
    }
}
