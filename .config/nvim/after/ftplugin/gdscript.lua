-- ftplugin/gdscript.lua
-- Start/attach to Godot's built-in GDScript LSP (TCP)
local port = tonumber(vim.env.GDSCRIPT_PORT or vim.env.GDScript_Port or "6005")
local root = vim.fs.dirname(vim.fs.find({ "project.godot", ".git" }, { upward = true })[1] or vim.loop.cwd())

-- Avoid starting multiple clients for the same buffer
local clients = vim.lsp.get_clients({ bufnr = 0, name = "Godot" })
if #clients == 0 then
    vim.lsp.start({
        name = "Godot",
        cmd = vim.lsp.rpc.connect("127.0.0.1", port),
        root_dir = root,
    })
end
