local generalSettingsGroup = vim.api.nvim_create_augroup('General settings', { clear = true })

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = { '*.goof' },
    callback = function()
        vim.bo.filetype = 'goof'
    end,
    group = generalSettingsGroup,
})
