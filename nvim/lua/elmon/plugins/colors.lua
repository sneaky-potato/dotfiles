return {
    -- {
    --     "EdenEast/nightfox.nvim",
    --     name = "nightfox",
    --     config = function()
    --         require("nightfox").setup({transparent = true})
    --         vim.cmd.colorscheme "carbonfox"
    --     end
    -- }
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        config = function()
            require("catppuccin").setup({transparent_background = true})
            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
