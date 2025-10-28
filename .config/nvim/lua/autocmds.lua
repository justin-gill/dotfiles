-- Autocommands

-- Filetype detection: Waybar config is JSON
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*/waybar/config' },
    callback = function()
        vim.bo.filetype = 'json'
    end,
})

-- LSP: Attach keymaps when LSP attaches to buffer
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        require('plugins.lsp._keymaps').setup(event.buf)
    end,
})

-- Lint: YAML files on save with smart detection
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.yaml', '*.yml' },
    callback = function()
        local ok, lint = pcall(require, 'lint')
        if not ok then return end

        local filepath = vim.fn.expand('%:p')
        local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, 10, false), '\n')

        -- CloudFormation (check first - highest priority)
        if content:match('AWSTemplateFormatVersion') or content:match('Type:%s*AWS::') then
            lint.try_lint('cfn_lint')
        elseif filepath:match('/templates/[^/]+%.yaml$') or filepath:match('/templates/[^/]+%.yml$') then
            -- Helm templates (skip linting - handled by helm_ls)
            return
        elseif content:match('apiVersion:') and content:match('kind:') then
            -- Kubernetes manifests
            lint.try_lint('yamllint')
        else
            -- Generic YAML
            lint.try_lint('yamllint')
        end
    end,
})

-- Lint: Terraform files on save
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.tf' },
    callback = function()
        local ok, lint = pcall(require, 'lint')
        if not ok then return end
        lint.try_lint('tflint')
    end,
})
