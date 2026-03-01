local script_path = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(script_path, ":p:h:h")

vim.opt.runtimepath:prepend(root)
vim.opt.runtimepath:append(vim.env.PLENARY_PATH or (vim.env.HOME .. "/.local/share/nvim/lazy/plenary.nvim"))
vim.opt.runtimepath:append(vim.env.FUGITIVE_PATH or (vim.env.HOME .. "/.local/share/nvim/lazy/vim-fugitive"))

vim.g.mapleader = "\\"
vim.opt.swapfile = false
