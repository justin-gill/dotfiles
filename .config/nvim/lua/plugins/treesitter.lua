return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c", -- required
                "lua", -- required
                "vim", -- required
                "vimdoc", -- required
                "markdown", -- required
                "markdown_inline", -- required for codecompanion
                "query", -- required
                "json",
                "yaml",
                "csv",
                "regex",
                "bash",
            },
            auto_install = true,
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
