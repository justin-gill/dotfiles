-- Treesitter syntax highlighting
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    priority = 100,
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = {
                'c', 'lua', 'vim', 'vimdoc', 'query',
                'markdown', 'markdown_inline', -- markdown_inline for codecompanion
                'json', 'yaml', 'helm', 'hcl', 'csv', 'regex', 'bash',
            },
            auto_install = true,
            sync_install = false,
            ignore_install = {},
            modules = {},
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
