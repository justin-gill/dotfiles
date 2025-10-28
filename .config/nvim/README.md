# Neovim Configuration

Neovim config

## Structure

```
lua/
├── options.lua      # Editor settings
├── mappings.lua     # Keymaps
├── autocmds.lua     # Autocommands
└── plugins/
    ├── ui.lua           # Theme & statusline
    ├── editor.lua       # Git, commenting
    ├── navigation.lua   # Telescope, tmux
    ├── lsp.lua          # LSP + completion
    ├── ai.lua           # Copilot, CodeCompanion
    └── coding/
        ├── treesitter.lua
        ├── format.lua
        └── lint.lua
```
