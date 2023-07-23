-- Define a function to toggle nvim-tree and switch back to the previous buffer
function ToggleNvimTreeAndSwitchBack()
    if vim.fn.win_gettype() == '' and vim.fn.bufname('#') == '' then
        -- If nvim-tree is not open and there is no previous buffer, open nvim-tree
        vim.cmd('NvimTreeToggle')
    else
        -- Otherwise, switch back to the previous buffer
        local prev_bufnr = vim.fn.bufnr('#')
        vim.cmd('buffer#')
        if prev_bufnr == vim.fn.bufnr('%') then
            vim.cmd('buffer#')
        end
    end
end

-- Set up the keybinding to toggle nvim-tree and switch back to the previous buffer
vim.keymap.set('n', '<Leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

