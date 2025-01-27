return {
	{
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            require("mason").setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'basedpyright',
                    'bashls',
                    'dockerls',
                    'docker_compose_language_service',
                    'lua_ls',
                    'rust_analyzer',
                    'ts_ls',
                },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                    ["lua_ls"] = function ()
                       local lspconfig = require("lspconfig")
                       lspconfig.lua_ls.setup {
                           settings = {
                               Lua = {
                                   diagnostics = {
                                       globals = { "vim" }
                                   }
                               }
                           }
                       }
                   end,
                    ['basedpyright'] = function ()
                        local lspconfig = require("lspconfig")
                        lspconfig.basedpyright.setup({
                            settings = {
                                basedpyright = {
                                    typeCheckingMode = "off",
                                },
                            },
                        })
                    end
                }
            })
        end,
	},
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        config = function()
          local cmp = require('cmp')

          cmp.setup({
            sources = {
              { name = 'nvim_lsp' },
            },
            mapping = cmp.mapping.preset.insert({
              ['<CR>'] = cmp.mapping.confirm({ select = false }),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-u>'] = cmp.mapping.scroll_docs(-4),
              ['<C-d>'] = cmp.mapping.scroll_docs(4),
            }),
          })
        end,
    },
    {'hrsh7th/cmp-nvim-lsp'},
	{
        'neovim/nvim-lspconfig',
        config = function ()
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
              'force',
              lspconfig_defaults.capabilities,
              require('cmp_nvim_lsp').default_capabilities()
            )
        end
    },
}
