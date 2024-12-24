return {
    {
        "tpope/vim-fugitive",
        config = function()
           Map('n', '<leader>gs', vim.cmd.Git)
        end
    }
}
