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
opt.completeopt = { "menu", "menuone", "noselect" }

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
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
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
    sections = {
        lualine_c = {
            {
                "filename",
                file_status = true,
                path = 1,
            },
        },
    },
})

-- Currently requires nvim-treesitter CLI tool (npm / cargo)
-- ==========================================
-- Tree-sitter Configuration... eventually change when another solution exists
-- ==========================================

local ensure_installed =
    { "c", "lua", "vim", "vimdoc", "query", "bicep", "c_sharp", "terraform", "yaml", "helm", "gotmpl" }
local already_installed = require("nvim-treesitter.config").get_installed()
local parsers_to_install = vim.iter(ensure_installed)
    :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
    end)
    :totable()

if #parsers_to_install > 0 then
    require("nvim-treesitter").install(parsers_to_install)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        -- Attempt to enable native Tree-sitter highlighting
        pcall(vim.treesitter.start)

        -- Attempt to enable Tree-sitter based indentation
        pcall(function()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
    end,
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
        "shfmt",
    },
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "azure_pipelines_ls",
        "bashls",
        -- "csharp_ls",
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
    filename = {
        [".bash_local"] = "bash",
    },
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
        [".*%.bashrc"] = "bash",
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
    azure_schemas["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] =
        azure_schema_globs
end

vim.lsp.config("azure_pipelines_ls", {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/azure-pipelines-language-server"), "--stdio" },
    filetypes = { "yaml.azure-pipelines" },
    root_markers = { ".azure-pipelines", ".git" },
    settings = { yaml = { schemas = azure_schemas } },
})

vim.lsp.config("terraformls", {
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.lsp.config("ruff", {
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.config("helm_ls", {
    settings = {
        ["helm-ls"] = {
            yamlls = {
                path = "yaml-language-server",
                config = {
                    schemas = {},
                    schemaStore = { enable = true },
                    completion = true,
                    hover = true,
                    validation = true,
                },
            },
        },
    },
})

vim.lsp.config("yamlls", {
    filetypes = { "yaml", "yaml.helm-values" },
    settings = {
        yaml = {
            schemaStore = { enable = true },
        },
        redhat = { telemetry = { enabled = false } },
    },
})

vim.lsp.enable({
    "azure_pipelines_ls",
    "bashls",
    -- "csharp_ls",
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
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf }
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

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
-- Telescope
-- ==========================================
local rg_ignore_args = { "--hidden", "--glob", "!**/.git/**" }

require("telescope").setup({
    pickers = {
        find_files = {
            find_command = function()
                return vim.list_extend({ "rg", "--files", "--color=never" }, rg_ignore_args)
            end,
        },
        live_grep = {
            vimgrep_arguments = vim.list_extend({
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            }, rg_ignore_args),
        },
    },
})

-- ==========================================
-- General Keymaps
-- ==========================================
local builtin = require("telescope.builtin")
map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files (incl. dotfiles, respects .gitignore)" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep (incl. dotfiles, respects .gitignore)" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })

map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")

map("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })

-- Trigger LSP completion with C-n if menu is closed, otherwise navigate next
map("i", "<C-n>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-o>"
end, { expr = true, desc = "Trigger LSP completion" })

-- Accept completion with Enter
map("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept completion with Enter" })
