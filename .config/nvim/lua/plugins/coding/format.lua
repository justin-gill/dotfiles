-- Auto-formatting with conform.nvim
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            terraform = { "terraform_fmt" },
            hcl = { "terraform_fmt" },
            yaml = { "prettier" },
            lua = { "stylua" },
            toml = { "taplo" },
            json = { "prettier" },
        },
        format_on_save = function(bufnr)
            -- Only format if .editorconfig exists in project root
            local filetype = vim.bo[bufnr].filetype
            if filetype == "cs" then
                return
            end

            local filepath = vim.api.nvim_buf_get_name(bufnr)
            local editorconfig = vim.fs.find(".editorconfig", {
                path = filepath,
                upward = true,
            })[1]

            if not editorconfig then
                return -- No .editorconfig, skip formatting
            end

            return {
                timeout_ms = 2000,
                lsp_fallback = true,
            }
        end,
    },
}
