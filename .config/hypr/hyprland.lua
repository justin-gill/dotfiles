---@module 'hl'

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

local primary = "desc:LG Electronics"
local secondary = "desc:Acer"

hl.monitor({ output = primary, mode = "3440x1440@144", position = "0x0", scale = 1 })
hl.monitor({ output = secondary, mode = "2560x1440@75", position = "3440x-650", scale = 1, transform = 3 })

hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = secondary, persistent = true })

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("udiskie")
end)

hl.env("XCURSOR_SIZE", 24)
hl.env("GDK_SCALE", 1)
hl.env("QT_QPA_PLATFORMTHEME", "gtk3") -- Qt apps follow the GTK (Adwaita-dark) theme

hl.config({
    misc = { disable_hyprland_logo = true, disable_splash_rendering = true },
    input = { kb_layout = "us", kb_options = "ctrl:nocaps", follow_mouse = 1, mouse_refocus = false, touchpad = { natural_scroll = true }, sensitivity = 0 },
    general = { gaps_in = 5, gaps_out = 10, border_size = 2, layout = "dwindle",
        col = { active_border = "rgba(ffffffee)", inactive_border = "rgba(595959aa)" }
    },
    decoration = { rounding = 5, rounding_power = 2,
        shadow = { enabled = true, range = 4, render_power = 3, color = 0xee1a1a1a },
        blur = { enabled = true, size = 3, passes = 2, vibrancy = 0.1696 },
    },
    animations = { enabled = false }
})

hl.window_rule({ name = "ghostty-floating", match = { initial_class = "^(com.ghostty.floating)$" }, float = true, size = { 1000, 600 }, center = true })
hl.window_rule({ name = "thunar-float", match = { initial_class = "^(thunar)$" }, float = true, size = { 1100, 700 }, center = true })
hl.window_rule({ name = "thunar-utilities", match = { class = "^(thunar)$", title = "^(File Operation Progress|Confirm to replace files|Attention)$" }, float = true, center = true })
hl.window_rule({ name = "xarchiver", match = { class = "^(xarchiver)$" }, float = true, center = true })
hl.window_rule({ name = "firefox-pip", match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true, keep_aspect_ratio = true })
hl.window_rule({ name = "godot-main", match = { class = "^(Godot)$", title = "^(Godot).*$" }, tile = true })
hl.window_rule({ name = "godot-tools", match = { class = "^(Godot)$", title = "negative:^(Godot).*$" }, float = true })

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

local mod = "ALT"
local bind = hl.bind
local ipc = "noctalia msg "

-- Core binds
bind(mod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
bind(mod .. " + S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
bind(mod .. " + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
bind(mod .. " + P", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd(ipc .. "session lock"))
bind("CTRL + SHIFT + S", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

-- Media keys
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })

-- Noctalia Settings
hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 1080, 920 },
})

bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("ghostty --class=com.ghostty.floating"))
bind(mod .. " + Q", hl.dsp.window.close())
bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
bind(mod .. " + V", hl.dsp.window.float())
bind(mod .. " + F", hl.dsp.window.fullscreen())

bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

local dirs = { h = "left", l = "right", k = "up", j = "down" }
for key, dir in pairs(dirs) do bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir })) end

for i = 1, 10 do
    local key = (i == 10) and 0 or i
    bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
