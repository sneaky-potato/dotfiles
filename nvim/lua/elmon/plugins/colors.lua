return {
    {
        "catppuccin/nvim",
        name = "catppuccin",

        config = function()
            require("catppuccin").setup({transparent_background = true})
            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"
        end,
    }
}
