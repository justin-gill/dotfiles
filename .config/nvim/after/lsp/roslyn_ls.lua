---@type vim.lsp.Config
return {
    -- nvim-lspconfig defaults to "fullSolution", which analyzes every project and eats memory.
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
    },
}
