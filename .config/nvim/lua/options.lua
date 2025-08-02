local opt = vim.opt
opt.signcolumn = 'yes'
opt.termguicolors = true

opt.nu = true
opt.relativenumber = true
opt.spelllang = 'en_us'
opt.spell = true
opt.fixendofline = false
opt.ignorecase = true
opt.smartcase = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.fillchars= "vert:│,fold:┈,diff:┈"

opt.hlsearch = true
opt.wildmenu = true
opt.incsearch = true

opt.updatetime = 50
opt.clipboard:append("unnamedplus")

vim.g.copilot_enabled = false

local function is_wsl()
    local f = io.popen("uname -a")
    if not f then
        return false
    end
    local uname = f:read("*a")
    f:close()
    return uname:match("Microsoft") ~= nil
end

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
