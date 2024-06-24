return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      extenstions = {
        -- fzf = {
        --   fuzzy = true,
        --   override_generic_sorter = true,
        --   override_file_sorter = true,
        --   case_mode = "smart_case",
        -- }
      }
    })
    -- telescope.load_extension("fzf")

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Fuzzy find files in cwd" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Fuzzy find string in cwd" })
    vim.keymap.set('n', '<leader>fd', function()
            builtin.diagnostics({ bufnr = 0 })
        end,
        { desc = "Fuzzy find diagnostics" })

    vim.keymap.set('n', '<leader>fs', function()
        builtin.grep_string({
            search = vim.fn.input("grep>")
        })
    end)
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Fuzzy find buffer" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Fuzzy find tags" })
  end,
}
