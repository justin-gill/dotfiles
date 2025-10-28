-- Navigation and search plugins
return {
    -- Fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local map = vim.keymap.set
            map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
            map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = 'Live grep' })
            map('n', '<leader>gt', '<cmd>Telescope git_status<CR>', { desc = 'Git status' })
        end,
    },

    -- Tmux/Vim seamless navigation
    {
        'christoomey/vim-tmux-navigator',
        cmd = {
            'TmuxNavigateLeft',
            'TmuxNavigateDown',
            'TmuxNavigateUp',
            'TmuxNavigateRight',
            'TmuxNavigatePrevious',
            'TmuxNavigatorProcessList',
        },
        keys = {
            { '<c-h>', '<cmd>TmuxNavigateLeft<cr>',  desc = 'Navigate left' },
            { '<c-j>', '<cmd>TmuxNavigateDown<cr>',  desc = 'Navigate down' },
            { '<c-k>', '<cmd>TmuxNavigateUp<cr>',    desc = 'Navigate up' },
            { '<c-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Navigate right' },
        },
    },
}
