-- LSP server configurations
local M = {}

function M.setup()
    -- lua_ls
    vim.lsp.config('lua_ls', {
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file('', true) }
            }
        }
    })

    -- basedpyright
    vim.lsp.config('basedpyright', {
        settings = {
            basedpyright = { typeCheckingMode = 'off' }
        }
    })

    -- yamlls (exclude Helm charts)
    -- Prevents yamlls from attaching to Helm templates, which are handled by helm_ls instead.
    -- This avoids conflicts between the two language servers.
    vim.lsp.config('yamlls', {
        root_dir = function(fname)
            -- Ensure fname is a string (can be buffer number)
            if type(fname) ~= 'string' then
                fname = vim.api.nvim_buf_get_name(fname)
            end

            -- Don't attach yamlls to Helm charts (return nil = skip attachment)
            local helm_chart = vim.fs.find('Chart.yaml', {
                path = fname,
                upward = true,
            })[1]
            if helm_chart then
                return nil
            end
            return vim.fs.root(fname, { '.git' })
        end,
        settings = {
            yaml = {
                format = { enable = true },
                validate = true,
                hover = true,
                completion = true,
                customTags = {
                    '!Ref scalar',
                    '!GetAtt scalar',
                    '!GetAtt sequence',
                    '!Sub scalar',
                    '!Sub sequence',
                    '!Join sequence',
                    '!FindInMap sequence',
                    '!Select sequence',
                    '!Split sequence',
                    '!Equals sequence',
                    '!And sequence',
                    '!Or sequence',
                    '!Not sequence',
                    '!If sequence',
                    '!Condition scalar',
                    '!ImportValue scalar',
                    '!Base64 scalar',
                    '!Cidr sequence',
                    '!GetAZs scalar',
                },
                schemaStore = {
                    enable = true,
                    url = 'https://www.schemastore.org/api/json/catalog.json',
                },
                schemas = {
                    ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] =
                    '/*.template.yaml',
                },
            },
            redhat = { telemetry = { enabled = false } },
        }
    })

    -- helm_ls
    vim.lsp.config('helm_ls', {
        settings = {
            ['helm-ls'] = {
                yamlls = {
                    enabled = true,
                    diagnosticsLimit = 0, -- Disable schema errors, keep hover/autocomplete
                    config = {
                        completion = true,
                        hover = true,
                    }
                }
            }
        }
    })

    -- Enable all configured servers
    local servers = {
        'lua_ls', 'basedpyright', 'yamlls', 'helm_ls', 'bicep',
        'rust_analyzer', 'ts_ls', 'bashls', 'dockerls',
        'docker_compose_language_service', 'gopls', 'terraformls'
    }
    for _, server in ipairs(servers) do
        vim.lsp.enable(server)
    end
end

return M
