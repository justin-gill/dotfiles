require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "rust", "vim", "python", "javascript",
                         "typescript", "vimdoc", "query", "html", "go", "bash",
                         "json", "sql", "yaml", "slint", },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    autotag = {
        enable = true,
    }
}
