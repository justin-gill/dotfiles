---@module 'hl'

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "desc:LG Electronics LG ULTRAGEAR 204NTGY8J231", mode = "3440x1440@144", position = "0x0", scale = 1 })
hl.monitor({ output = "desc:Acer Technologies Acer V277U 0x10322DB7", mode = "2560x1440@74.89", position = "3440x-650", scale = 1, transform = 3 })

hl.workspace_rule({ workspace = 4, monitor = "desc:Acer Technologies Acer V277U 0x10322DB7", persistent = true })

hl.on("hyprland.start", function()
    local apps = {
        "udiskie &", "waybar", "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",
        "awww-daemon", "ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
    }
    for _, app in ipairs(apps) do hl.exec_cmd(app) end
end)

hl.env("XCURSOR_SIZE", 24)
hl.env("GDK_SCALE", 1)

hl.config({
    misc = { disable_hyprland_logo = true, disable_splash_rendering = true },
    input = { kb_layout = "us", kb_options = "ctrl:nocaps", follow_mouse = 1, mouse_refocus = false, touchpad = { natural_scroll = true }, sensitivity = 0 },
    general = { gaps_in = 5, gaps_out = 5, border_size = 2, layout = "dwindle", col = { active_border = "rgba(ffffffee)", inactive_border = "rgba(595959aa)" } },
    animations = { enabled = false }
})

hl.layer_rule({ match = { namespace = "^(selection)$" }, no_anim = true })

hl.window_rule({ name = "system-floats", match = { class = "^(blueman-manager|org.pulseaudio.pavucontrol|imv)$" }, size = { 1000, 600 }, float = true, center = true })
hl.window_rule({ name = "ghostty-floating", match = { initial_class = "^(com.ghostty.floating)$" }, float = true, size = { 1000, 600 }, center = true })
hl.window_rule({ name = "thunar-float", match = { initial_class = "^(thunar)$" }, float = true, size = { 1100, 700 }, center = true })
hl.window_rule({ name = "thunar-utilities", match = { class = "^(thunar)$", title = "^(File Operation Progress|Confirm to replace files|Attention)$" }, float = true, center = true })
hl.window_rule({ name = "xarchiver", match = { class = "^(xarchiver)$" }, float = true, center = true })
hl.window_rule({ name = "firefox-pip", match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true, keep_aspect_ratio = true })
hl.window_rule({ name = "godot-main", match = { class = "^(Godot)$", title = "^(Godot).*$" }, tile = true })
hl.window_rule({ name = "godot-tools", match = { class = "^(Godot)$", title = "negative:^(Godot).*$" }, float = true })

local mod = "ALT"
local home = os.getenv("HOME")
local bind = hl.bind

bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
bind(mod .. " + SHIFT + Return", hl.dsp.exec_cmd("ghostty --class=com.ghostty.floating"))
bind(mod .. " + Q", hl.dsp.window.close())
bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
bind(mod .. " + V", hl.dsp.window.float())
bind(mod .. " + F", hl.dsp.window.fullscreen())
bind(mod .. " + R", hl.dsp.exec_cmd(home .. "/.local/bin/reload-desktop"))
bind(mod .. " + P", hl.dsp.exec_cmd(home .. "/.config/rofi/bin/powermenu"))
bind(mod .. " + Space", hl.dsp.exec_cmd(home .. "/.config/rofi/bin/launcher"))
bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | tee ~/Pictures/screenshots/$(date +'%Y-%m-%d-%H%M%S.png') | wl-copy"))
bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
bind(mod .. " + TAB", hl.dsp.exec_cmd("pkill -9 hyprsunset || hyprsunset --temperature 3000"))

bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- && dunstify -u low -t 3000 -r 90210 \"󰛨   $(brightnessctl get | awk -v max=$(brightnessctl max) '{print int(($1 / max) * 100)}')%\""))
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5% && dunstify -u low -t 3000 -r 90210 \"󰛨   $(brightnessctl get | awk -v max=$(brightnessctl max) '{print int(($1 / max) * 100)}')%\""))

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
