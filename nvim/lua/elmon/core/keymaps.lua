-- function Map(mode, lhs, rhs, opts)
--     local options = { noremap = true, silent = true }
--     if opts then
--         options = vim.tbl_extend("force", options, opts)
--     end
--     vim.keymap.set(mode, lhs, rhs, options)
-- end

vim.g.mapleader = " "

-- Deprecated since not using netrw anymore for browsing
-- vim.keymap.set("n", "<leader>pv", ":Ex")

-- Easy horizontal movement of code through file
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move code anywhere through the file
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==")
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==")
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi")
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv")

-- Buffer flying
vim.keymap.set("n", "<C-b>", ":ls<cr>:b<space>")

-- Buffer sprinting
vim.keymap.set("n", "]b", ":bnext<cr>")
vim.keymap.set("n", "[b", ":bprev<cr>")




