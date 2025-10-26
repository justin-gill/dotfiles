-- LSP and Completion Plugins

-- Helper: LSP keymaps
local function lsp_keymaps(buf)
    local map = vim.keymap.set
    local opts = { buffer = buf }
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    map({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

return {
    -- Mason: LSP installer
    {
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            require("mason").setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'basedpyright', 'rust_analyzer', 'ts_ls', 'bashls', 'lua_ls',
                    'dockerls', 'docker_compose_language_service', 'gopls', 'terraformls',
                },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    ["lua_ls"] = function ()
                        require("lspconfig").lua_ls.setup {
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { library = vim.api.nvim_get_runtime_file("", true) }
                                }
                            }
                        }
                    end,
                    ['basedpyright'] = function ()
                        require("lspconfig").basedpyright.setup({
                            settings = { basedpyright = { typeCheckingMode = "off" } }
                        })
                    end
                }
            })
        end,
    },

    -- nvim-cmp: Completion
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'zbirenbaum/copilot-cmp',
        },
        config = function()
            local cmp = require('cmp')
            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
            end
            cmp.setup({
                sources = {
                    { name = 'copilot', group_index = 2 },
                    { name = 'nvim_lsp', group_index = 2 },
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            copilot = "[Copilot]",
                            nvim_lsp = "[LSP]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
            })
        end,
    },

    -- cmp-nvim-lsp: LSP source for nvim-cmp
    { 'hrsh7th/cmp-nvim-lsp' },

    -- Copilot completion source
    {
        'zbirenbaum/copilot-cmp',
        dependencies = { 'zbirenbaum/copilot.lua' },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    -- nvim-lspconfig: LSP configuration
    {
        'neovim/nvim-lspconfig',
        config = function ()
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- Attach LSP keymaps
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    lsp_keymaps(event.buf)
                end,
            })
        end
    },

    -- Sleuth: Detect tabstop/shiftwidth automatically
    { 'tpope/vim-sleuth' },
}
