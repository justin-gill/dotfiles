---@type vim.lsp.Config
return {
    -- terraform-ls sends invalid semantic-token deltas that can freeze Neovim
    -- (hashicorp/terraform-ls#2125). Disable them; treesitter handles HCL
    -- highlighting.
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
}
