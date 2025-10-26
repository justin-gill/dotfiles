local opt = vim.opt

-- UI/Display Settings
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.nu = true
opt.relativenumber = true
opt.fillchars = "vert:│,fold:┈,diff:┈"

-- Editing Behavior
opt.spell = true
opt.spelllang = 'en_us'
opt.fixendofline = false

-- Indentation Settings
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- Search Settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Command-line Completion
opt.wildmenu = true

-- Performance
opt.updatetime = 50

-- Clipboard Settings
opt.clipboard:append("unnamedplus")

-- WSL Clipboard Integration
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
