-- LSP keybindings
local M = {}

function M.setup(buf)
    local map = vim.keymap.set
    local opts = { buffer = buf }

    map('n', 'K', vim.lsp.buf.hover, opts)
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'gi', vim.lsp.buf.implementation, opts)
    map('n', 'go', vim.lsp.buf.type_definition, opts)
    map('n', 'gr', vim.lsp.buf.references, opts)
    map('n', 'gs', vim.lsp.buf.signature_help, opts)
    map('n', '<F2>', vim.lsp.buf.rename, opts)
    map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
    map('n', '<F4>', vim.lsp.buf.code_action, opts)
end

return M
