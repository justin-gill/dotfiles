---@type vim.lsp.Config
return {
    -- ruff and ty both run on Python buffers; disable ruff's hover so ty owns it.
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
}
