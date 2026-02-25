-- LSP and Completion Configuration
return {
    -- Mason: LSP installer
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()

            -- Auto-install linters and formatters
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "cfn-lint", -- CloudFormation validation
                    "yamllint", -- YAML syntax/style
                    "tflint", -- Terraform linter
                    "stylua", -- Lua formatter
                    "taplo", -- TOML formatter
                },
            })

            -- Auto-install LSPs
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "basedpyright",
                    "rust_analyzer",
                    "ts_ls",
                    "bashls",
                    "lua_ls",
                    "dockerls",
                    "docker_compose_language_service",
                    "gopls",
                    "terraformls",
                    "yamlls",
                    "helm_ls",
                    "bicep",
                },
            })

            -- Configure LSP servers
            require("plugins.lsp._servers").setup()
        end,
    },

    -- nvim-cmp: Completion
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "zbirenbaum/copilot-cmp",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                sources = {
                    { name = "copilot", group_index = 2 },
                    { name = "nvim_lsp", group_index = 2 },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            copilot = "[Copilot]",
                            nvim_lsp = "[LSP]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
            })
        end,
    },

    -- Copilot completion source
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- nvim-lspconfig: LSP configuration
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig_defaults = require("lspconfig").util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                "force",
                lspconfig_defaults.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )
        end,
    },
}
