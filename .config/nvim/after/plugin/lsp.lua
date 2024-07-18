local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
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
        'ruff_lsp',
        'slint_lsp',
        'gopls',
  },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

