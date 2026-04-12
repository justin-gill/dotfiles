-- ==========================================
-- Options & Globals
-- ==========================================
vim.g.mapleader = " "
local opt = vim.opt
local map = vim.keymap.set

opt.signcolumn = "yes"
opt.termguicolors = true
opt.nu = true
opt.relativenumber = true
opt.spell = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard:append("unnamedplus")
opt.laststatus = 3
opt.autocomplete = true

-- Disable autocomplete inside Telescope prompts
vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
        vim.opt_local.autocomplete = false
    end,
})

-- ==========================================
-- Plugins
-- ==========================================
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/towolf/vim-helm" },
})

-- ==========================================
-- UI & Syntax
-- ==========================================
vim.cmd.colorscheme("catppuccin-mocha")

require("lualine").setup({
    options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
    },
})

require("nvim-treesitter").setup({
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

-- ==========================================
-- LSP
-- ==========================================
require("mason").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "cfn-lint",
        "goimports",
        "tflint",
    },
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "azure_pipelines_ls",
        "bashls",
        "csharp_ls",
        "gopls",
        "helm_ls",
        "lua_ls",
        "ruff",
        "rust_analyzer",
        "stylua",
        "terraformls",
        "ts_ls",
        "ty",
        "yamlls",
    },
})

vim.filetype.add({
    pattern = {
        [".*/.azure%-pipelines/.*%.ya?ml"] = "yaml.azure-pipelines",
        [".*/azure%-pipeline.*%.ya?ml"] = "yaml.azure-pipelines",
        [".*/templates/.*%.ya?ml"] = function(path)
            if vim.fs.root(path, "Chart.yaml") then
                return "helm"
            end
        end,
        [".*/templates/.*%.tpl"] = function(path)
            if vim.fs.root(path, "Chart.yaml") then
                return "helm"
            end
        end,
        [".*values.*%.ya?ml"] = function(path)
            if vim.fs.root(path, "Chart.yaml") then
                return "yaml.helm-values"
            end
        end,
        ["Chart%.yaml"] = "yaml.helm",
    },
})

-- Org-specific task schema for Azure Pipelines (provides task-level completions).
-- Fetch from: https://dev.azure.com/YOUR-ORG/_apis/distributedtask/yamlschema
-- Save to: ~/.config/nvim/schemas/azure-pipelines-tasks.json
local azure_task_schema = vim.fn.stdpath("config") .. "/schemas/azure-pipelines-tasks.json"
local azure_schema_globs = {
    "**/.azure-pipelines/*.yml",
    "**/.azure-pipelines/*.yaml",
    "**/azure-pipeline*.yml",
    "**/azure-pipeline*.yaml",
}
local azure_schemas = {}
if vim.uv.fs_stat(azure_task_schema) then
    azure_schemas["file://" .. azure_task_schema] = azure_schema_globs
else
    azure_schemas["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = azure_schema_globs
end

vim.lsp.config("azure_pipelines_ls", {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/azure-pipelines-language-server"), "--stdio" },
    filetypes = { "yaml.azure-pipelines" },
    root_markers = { ".azure-pipelines", ".git" },
    settings = { yaml = { schemas = azure_schemas } },
})

vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.config("yamlls", {
    filetypes = { "yaml", "yaml.helm-values" },
    settings = {
        yaml = { schemas = { kubernetes = { "/*.yaml", "/*.yml" } } },
        redhat = { telemetry = { enabled = false } },
    },
})

vim.lsp.enable({
    "azure_pipelines_ls",
    "bashls",
    "csharp_ls",
    "gopls",
    "helm_ls",
    "lua_ls",
    "ruff",
    "rust_analyzer",
    "stylua",
    "terraformls",
    "tflint",
    "ts_ls",
    "ty",
    "yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf }
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "<F2>", vim.lsp.buf.rename, opts)
        map("n", "<F4>", vim.lsp.buf.code_action, opts)
        map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
        map("n", "<leader>lf", vim.lsp.buf.format, opts)
    end,
})

-- ==========================================
-- General Keymaps
-- ==========================================
local builtin = require("telescope.builtin")
map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })

map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")

map("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
