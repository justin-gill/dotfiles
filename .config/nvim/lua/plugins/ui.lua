-- UI and appearance plugins
return {
    -- Catppuccin colorscheme
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require('catppuccin').setup({
                flavour = 'frappe',
                transparent_background = true,
                styles = {
                    comments = { 'italic' },
                    conditionals = { 'italic' },
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                },
            })
            vim.cmd.colorscheme 'catppuccin'
        end
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'catppuccin',
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            }
        end
    },
}
