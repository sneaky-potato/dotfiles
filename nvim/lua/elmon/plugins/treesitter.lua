return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            -- New 0.12 API — no more configs.setup()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "luadoc", "markdown", "cpp", "python",
                    "lua", "java", "javascript", "vim", "vimdoc"
                },
            })
        end,
    },
    -- textobjects is also archived, drop it or find a replacement
    -- nvim-ts-autotag may still work standalone:
    { "windwp/nvim-ts-autotag", opts = {} },
}
