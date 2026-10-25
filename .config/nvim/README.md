# Neovim
Config for Neovim 0.12, using the built-in `vim.pack` plugin manager and native LSP completion.

## Requirements
* Neovim 0.12+
* `tree-sitter` CLI and a C compiler, for installing parsers
* `ripgrep`, for Telescope
* Node and Go, for some of the language servers Mason installs
* `shellcheck` and `shfmt`, for bash diagnostics and formatting through `bashls`

Plugins, Treesitter parsers, and language servers install themselves on first launch.

## Layout
```
init.lua               # options, plugins, treesitter, LSP, telescope, keymaps
nvim-pack-lock.json    # pinned plugin versions (written by vim.pack)
after/lsp/<server>.lua # per-server overrides
```

## Plugins
* **UI:** catppuccin, lualine, gitsigns, nvim-web-devicons
* **Navigation:** telescope, vim-tmux-navigator
* **LSP / syntax:** nvim-treesitter, nvim-lspconfig, mason, mason-lspconfig

Add or remove a plugin in the `plugins` table in `init.lua`, then:
```
:PackUpdate     " update all plugins (or :PackUpdate <name>)
:PackClean      " delete plugins no longer in the list (restart first)
```

## Language servers
bashls, gopls, helm_ls, lua_ls, ruff, rust_analyzer, terraformls, ts_ls, ty, yamlls

`bicep` and `roslyn_ls` are only enabled when `dotnet` is on the `PATH`, e.g. via a machine-local `mise.local.toml`.

## Keymaps
Leader is `Space`.

| Keys | Action |
|---|---|
| `<leader>ff` | Find files (includes dotfiles) |
| `<leader>fg` | Live grep (includes dotfiles) |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |
| `<leader>pv` | File explorer (netrw) |
| `C-h/j/k/l` | Move between Neovim splits and tmux panes |
| `C-/` | Toggle comment |
| `C-click` | Open link under the mouse |
| `C-n` | Open LSP completion |
| `Enter` | Accept selected completion |
| `K` | Hover docs |
| `gd` | Go to definition |
| `<leader>ld` | Line diagnostics |
| `<leader>lD` | All diagnostics |
| `<leader>lG` | Workspace symbols |
| `<leader>lf` | Format buffer |
| `<leader>lh` | Toggle inlay hints |
