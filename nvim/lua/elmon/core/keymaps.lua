function Map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

vim.g.mapleader = " "

-- Deprecated since not using netrw anymore for browsing
-- vim.keymap.set("n", "<leader>pv", ":Ex")

-- Easy horizontal movement of code through file
Map("v", "<", "<gv")
Map("v", ">", ">gv")

-- Move code anywhere through the file
Map("n", "<A-j>", ":m .+1<cr>==")
Map("n", "<A-k>", ":m .-2<cr>==")
Map("i", "<A-j>", "<Esc>:m .+1<cr>==gi")
Map("i", "<A-k>", "<Esc>:m .-2<cr>==gi")
Map("v", "<A-j>", ":m '>+1<cr>gv=gv")
Map("v", "<A-k>", ":m '<-2<cr>gv=gv")

