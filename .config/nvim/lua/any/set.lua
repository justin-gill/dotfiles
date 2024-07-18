function is_wsl()
    local f = io.popen("uname -a")
    local uname = f:read("*a")
    f:close()
    return uname:match("Microsoft") ~= nil
end

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fillchars= "vert:│,fold:┈,diff:┈"

vim.opt.hlsearch = true
vim.opt.wildmenu = true
vim.opt.incsearch = true

vim.opt.updatetime = 50
vim.opt.clipboard:append("unnamedplus")

if is_wsl() then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring():gsub("\r", ""))',
        },
        cache_enabled = 0,
    }
end

