-- Editor enhancement plugins
return {
    -- Git signs in gutter
    { 'lewis6991/gitsigns.nvim' },

    -- Comment toggling with <C-/>
    {
        'tpope/vim-commentary',
        config = function()
            local map = vim.keymap.set
            map('v', '<C-_>', ':Commentary<CR>', { noremap = true, desc = 'Toggle comment' })
        end,
    },

    -- Detect tabstop/shiftwidth automatically
    { 'tpope/vim-sleuth' },
}
