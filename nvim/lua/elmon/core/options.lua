local opt = vim.opt

-- Global settings
-- vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
-- vim.g.netrw_list_hide = netrw_gitignore#Hide()
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.autochdir = true

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.smartcase = true

opt.cursorline = true

opt.guicursor = ""

opt.termguicolors = false
opt.background = "dark"
opt.signcolumn = "no"
opt.scrolloff = 8

opt.backspace = "indent,eol,start"

-- opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
