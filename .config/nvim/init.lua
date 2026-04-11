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
opt.spell = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.ignorecase = true
opt.smartcase = true
opt.clipboard:append("unnamedplus")
opt.laststatus = 3
opt.autocomplete = true

-- ==========================================
-- Plugins
-- ==========================================
vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim"},
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/mfussenegger/nvim-lint" },
})

-- ==========================================
-- UI & Syntax (Standard Requires!)
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
-- LSP Native Config
-- ==========================================
require("mason").setup()

require("mason-tool-installer").setup({
    ensure_installed = { "cfn-lint", "yamllint", "tflint" },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls", "basedpyright", "yamlls", "helm_ls",
        "terraformls", "bashls", "rust_analyzer", "ts_ls"
    },
    automatic_enable = true,
})

vim.lsp.config('lua_ls', {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local opts = { buffer = args.buf }
        map("n", "<leader>d", vim.diagnostic.open_float, { buffer = args.buf, desc = "Line diagnostics" })
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "<F2>", vim.lsp.buf.rename, opts)
        map("n", "<F4>", vim.lsp.buf.code_action, opts)
    end,
})

vim.api.nvim_create_autocmd("CompleteChanged", {
    callback = function()
        if vim.fn.pumvisible() == 1 then
            vim.lsp.buf.hover()
        end
    end,
})

-- ==========================================
-- 5. Formatting & Linting
-- ==========================================
require("conform").setup({
    format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "cs" then
            return
        end
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if vim.fs.find(".editorconfig", { path = filepath, upward = true })[1] then
            return { timeout_ms = 2000, lsp_fallback = true }
        end
    end,
})

local lint = require("lint")
lint.linters_by_ft = { terraform = { "tflint" }, yaml = { "yamllint" } }

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

-- ==========================================
-- 6. General Keymaps
-- ==========================================
map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })
map("n", "<leader>b", "<cmd>buffers<CR>:buffer ", { desc = "Switch buffers" })

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")

map("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })
