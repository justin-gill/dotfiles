return {
    'tpope/vim-commentary',
    config = function()
        local map = vim.keymap.set
        map("v", "<C-_>", ":Commentary<CR>", { noremap = true })
    end,
}
