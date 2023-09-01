local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'lua_ls',
    'ltex',
    'bashls',
    'cssls',
    'dockerls',
    'docker_compose_language_service',
    'jedi_language_server',
})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    local opts = { buffer = bufnr }

    vim.keymap.set('n', '<leader>fd', function()
        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
    end, opts)
end)

lsp.setup()
