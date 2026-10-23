-- ==========================================
-- Options
-- ==========================================
vim.g.mapleader = " "

local opt = vim.opt
local map = vim.keymap.set

-- UI
opt.signcolumn = "yes"
opt.laststatus = 3
opt.winborder = "rounded"
opt.pumborder = "rounded"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4

-- Editing
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.undofile = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Completion
opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
opt.clipboard:append("unnamedplus")

-- ==========================================
-- Packages
-- ==========================================
local plugins = {
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/williamboman/mason.nvim",
}

-- Disable vim-tmux-navigator's default mappings; the described versions in
-- the keymaps section are the only ones defined. Must be set before
-- vim.pack.add(), which sources the plugin.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add(plugins)

-- Split installed packages into active (added this session) and stale (left
-- on disk after removal from `plugins`). Nothing here lazy-loads, so stale
-- always means "removed from the plugin list".
---@return string[] active, string[] stale
local function pack_status()
    local active, stale = {}, {}
    for _, p in ipairs(vim.pack.get(nil, { info = false })) do
        local bucket = p.active and active or stale
        bucket[#bucket + 1] = p.spec.name
    end
    table.sort(active)
    table.sort(stale)
    return active, stale
end

-- Nvim 0.13 adds built-in `:packupdate[!]` and `:packdel ++all`; delete both
-- custom commands then. A package removed from `plugins` this session is
-- still active until restart, so run PackClean after restarting.
local function pack_clean(bang)
    local _, stale = pack_status()

    if #stale == 0 then
        vim.notify(
            "PackClean: no stale packages (restart to detect packages removed this session)",
            vim.log.levels.INFO
        )
        return
    end
    if not bang then
        local choice = vim.fn.confirm(
            ("Delete %d stale package(s)?\n\n%s"):format(#stale, table.concat(stale, "\n")),
            "&Yes\n&No",
            2
        )
        if choice ~= 1 then
            return
        end
    end
    vim.pack.del(stale)
end

-- `:PackClean` asks for confirmation; `:PackClean!` deletes immediately.
vim.api.nvim_create_user_command("PackClean", function(opts)
    pack_clean(opts.bang)
end, { bang = true, desc = "Delete packages left on disk after removal from the plugin list" })

-- `:PackUpdate` updates every package; `:PackUpdate name...` updates a
-- subset. `:PackUpdate!` skips the confirmation buffer.
vim.api.nvim_create_user_command("PackUpdate", function(opts)
    vim.pack.update(#opts.fargs > 0 and opts.fargs or nil, { force = opts.bang })
end, {
    bang = true,
    nargs = "*",
    desc = "Update packages (all by default)",
    complete = function(arg_lead)
        local active = pack_status()
        return vim.tbl_filter(function(name)
            return vim.startswith(name, arg_lead)
        end, active)
    end,
})

local builtin = require("telescope.builtin")

-- ==========================================
-- UI
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

-- ==========================================
-- Treesitter
-- ==========================================
-- Parser installation requires the tree-sitter CLI.
local parsers = {
    "bash",
    "bicep",
    "c_sharp",
    "go",
    "gomod",
    "gosum",
    "gotmpl",
    "helm",
    "json",
    "lua",
    "python",
    "rust",
    "terraform",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
}
local installed_parsers = require("nvim-treesitter.config").get_installed()
local missing_parsers = vim.iter(parsers)
    :filter(function(parser)
        return not vim.tbl_contains(installed_parsers, parser)
    end)
    :totable()

if #missing_parsers > 0 then
    require("nvim-treesitter").install(missing_parsers)
end

-- Enable native Tree-sitter highlighting and indentation per filetype.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        pcall(vim.treesitter.start)
        pcall(function()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end)
    end,
})

-- ==========================================
-- LSP
-- ==========================================
local servers = {
    "bashls",
    "bicep",
    "gopls",
    "helm_ls",
    "lua_ls", -- editing this config
    "roslyn_ls", -- C#
    "ruff",
    "rust_analyzer",
    "stylua", -- Lua formatting
    "terraformls",
    "ts_ls",
    "ty",
    "yamlls", -- Helm values, Kubernetes manifests
}

-- Assign the filetype only when the path belongs to a Helm chart.
local function helm_ft(filetype)
    return function(path)
        return vim.fs.root(path, "Chart.yaml") ~= nil and filetype or nil
    end
end

vim.filetype.add({
    filename = {
        [".bash_local"] = "bash",
    },
    pattern = {
        [".*/templates/.*%.ya?ml"] = helm_ft("helm"),
        [".*/templates/.*%.tpl"] = helm_ft("helm"),
        [".*values.*%.ya?ml"] = helm_ft("yaml.helm-values"),
        [".*%.bashrc"] = "bash",
    },
})

require("mason").setup()
-- `servers` is the single source of truth. mason-lspconfig's default
-- `automatic_enable = true` would also start every other installed server
-- (basedpyright, ...) regardless of that list.
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = false,
})

-- Per-server overrides live in after/lsp/<server>.lua, which merges after
-- nvim-lspconfig's own lsp/ configs. init.lua stays server-agnostic.
vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end

        local function lsp_map(lhs, rhs, desc)
            map("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        lsp_map("K", function()
            vim.lsp.buf.hover({ max_width = 80, max_height = 20 })
        end, "Hover")
        lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
        lsp_map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        lsp_map("<leader>lG", builtin.lsp_dynamic_workspace_symbols, "Workspace symbols")
        lsp_map("<leader>lf", function()
            vim.lsp.buf.format({ timeout_ms = 5000 })
        end, "Format buffer")
        if client and client:supports_method("textDocument/inlayHint") then
            lsp_map("<leader>lh", function()
                vim.lsp.inlay_hint.enable(
                    not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                    { bufnr = bufnr }
                )
            end, "Toggle inlay hints")
        end
    end,
})

-- ==========================================
-- Telescope
-- ==========================================
local rg_hidden_args = { "--hidden", "--glob", "!**/.git/**" }

require("telescope").setup({
    pickers = {
        find_files = {
            find_command = vim.list_extend({ "rg", "--files", "--color=never" }, rg_hidden_args),
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
            }, rg_hidden_args),
        },
    },
})

-- ==========================================
-- Keymaps
-- ==========================================
-- File explorer
map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })

-- Files and search (LazyVim convention)
map("n", "<leader>ff", builtin.find_files, {
    desc = "Find files (incl. dotfiles, respects .gitignore)",
})
map("n", "<leader>fg", builtin.live_grep, {
    desc = "Live grep (incl. dotfiles, respects .gitignore)",
})
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>lD", builtin.diagnostics, { desc = "All diagnostics" })

-- Window navigation through tmux.
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Tmux: navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Tmux: navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Tmux: navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Tmux: navigate right" })

-- netrw maps <C-l> to refresh; restore tmux navigation in its buffers.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function(args)
        map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { buffer = args.buf, desc = "Tmux: navigate right" })
    end,
})

-- Comments
map("x", "<C-_>", "gc", { remap = true, desc = "Toggle comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment" })

-- Completion: open the LSP menu with C-n, accept with Enter.
map("i", "<C-n>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-o>"
end, { expr = true, desc = "Trigger LSP completion" })

-- With noselect, Enter must only complete when an item is actually selected;
-- accepting with nothing selected would swallow the newline.
map("i", "<CR>", function()
    return (vim.fn.pumvisible() == 1 and vim.fn.complete_info().selected ~= -1) and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept selected completion with Enter" })
