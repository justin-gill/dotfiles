---@type vim.lsp.Config
return {
    -- nvim-lspconfig defaults both scopes to "fullSolution", which runs
    -- analyzers across every project in the solution. Open files matches
    -- Roslyn's own default and keeps memory flat.
    settings = {
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
        },
    },
}
