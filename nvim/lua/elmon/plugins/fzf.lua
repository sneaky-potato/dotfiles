return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function ()
        require("fzf-lua").setup{
            files = {
                actions = {
                    ["default"] = require("fzf-lua.actions").file_edit,
                }
            },
            keymap = {

            }
        }
    end

    -- local builtin = require('telescope.builtin')
    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Fuzzy find files in cwd" })
    -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Fuzzy find string in cwd" })
    -- vim.keymap.set('n', '<leader>fd', function()
    --         builtin.diagnostics({ bufnr = 0 })
    --     end,
    --     { desc = "Fuzzy find diagnostics" })
    --
    -- vim.keymap.set('n', '<leader>fs', function()
    --     builtin.grep_string({
    --         search = vim.fn.input("grep>")
    --     })
    -- end)
    -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Fuzzy find buffer" })
    -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Fuzzy find tags" })
}
