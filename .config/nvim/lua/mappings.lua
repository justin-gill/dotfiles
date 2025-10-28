--[[
  Keymaps Reference

  Leader: <Space>

  ## File & Navigation
  <leader>pv   - File explorer (netrw)
  <leader>b    - Buffer picker
  <leader>ff   - Find files (Telescope)
  <leader>fg   - Live grep (Telescope)
  <leader>gt   - Git status (Telescope)

  ## LSP (when attached)
  K            - Hover documentation
  gd           - Go to definition
  gD           - Go to declaration
  gi           - Go to implementation
  go           - Go to type definition
  gr           - Find references
  gs           - Signature help
  <F2>         - Rename symbol
  <F3>         - Format code
  <F4>         - Code actions
  <leader>d    - Show diagnostics (floating)

  ## Completion (Insert mode)
  <C-n>        - Next completion item
  <C-p>        - Previous completion item
  <CR>         - Confirm completion
  <C-d>        - Scroll docs down
  <C-u>        - Scroll docs up

  ## Editing
  <C-/>        - Toggle comment (visual mode)

  ## Navigation (Tmux integration)
  <C-h>        - Navigate left
  <C-j>        - Navigate down
  <C-k>        - Navigate up
  <C-l>        - Navigate right

  ## AI (CodeCompanion)
  <C-a>        - Action palette
  <leader>cc   - Toggle chat
  ga           - Add selection to chat (visual)
  <leader>ci   - Inline assistant
  <leader>ce   - Explain code
  <leader>cf   - Fix code
  <leader>ct   - Generate tests
  <leader>cm   - Generate commit message
--]]

-- Set <Space> as leader key
vim.g.mapleader = ' '

local map = vim.keymap.set

-- File explorer
map('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open file explorer (:Ex)' })

-- Buffer navigation
map('n', '<leader>b', '<cmd>:buffers<CR>:buffer<Space>', { noremap = true, desc = 'List and switch buffers' })

-- Diagnostics
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic under cursor' })
