---@type vim.lsp.Config
return {
    -- Invalid semantic-token deltas can freeze Neovim (hashicorp/terraform-ls#2125).
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
