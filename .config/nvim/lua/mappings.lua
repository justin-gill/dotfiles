-- Set <Space> as leader key
vim.g.mapleader = " "

local map = vim.keymap.set

-- File explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer (:Ex)" })

-- Buffer navigation
map("n", "<leader>b", "<cmd>:buffers<CR>:buffer<Space>", { noremap = true, desc = "List and switch buffers" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
