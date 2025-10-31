-- Vim Options -- 
---------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>l", ":Lazy<CR>")

vim.cmd("set number")
vim.wo.relativenumber = true
vim.cmd("set nowrap")

-- Yank to clipboard using wlcopy
vim.o.clipboard = "unnamedplus"

-- Map <leader>y to yank and <leader>p to paste
vim.api.nvim_set_keymap('n', '<leader>y', ':w !wlcopy<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', ':w !wlcopy<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', ':r !wlpaste<CR><CR>', { noremap = true, silent = true })

-- Enable filetype plugins and indent
vim.cmd([[
  filetype plugin indent on
  syntax on
]])

-- Smart indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true   -- use spaces instead of tabs
vim.o.shiftwidth = 4     -- 4 spaces per indent
vim.o.tabstop = 4        -- tabs appear as 4 spaces
vim.o.smarttab = true

