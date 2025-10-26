return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local map = vim.keymap.set
        map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
        map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
        map("n", "<leader>gt", "<cmd>Telescope git_status<CR>")
    end,
}
