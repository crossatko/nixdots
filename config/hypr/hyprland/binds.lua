local apps = require("hyprland.apps")

local mod = "SUPER"
local alt = "ALT"
local modalt = mod .. " + " .. alt

hl.bind("Print", hl.dsp.exec_cmd(apps.screenshot))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(apps.menu))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | tofi | cliphist decode | wl-copy"))

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(apps.terminal))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(apps.browser))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(apps.filemanager))
hl.bind(mod .. " + W", hl.dsp.exec_cmd(apps.whatsapp))
hl.bind(mod .. " + M", hl.dsp.exec_cmd(apps.messages))

hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Escape", hl.dsp.exec_cmd("~/.config/hypr/scripts/leave_computer.sh"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"))

hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreenstate 1"))
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mod .. " + X", hl.dsp.layout("togglesplit"))

hl.bind(mod .. " + G", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))

hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

hl.bind(mod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(modalt .. " + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(modalt .. " + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(modalt .. " + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(modalt .. " + j", hl.dsp.window.move({ direction = "down" }))

local res_step = 20
hl.bind(modalt .. " + SHIFT + h", hl.dsp.window.resize({ x = -res_step, y = 0, relative = true }), { repeating = true })
hl.bind(modalt .. " + SHIFT + l", hl.dsp.window.resize({ x = res_step, y = 0, relative = true }), { repeating = true })
hl.bind(modalt .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -res_step, relative = true }), { repeating = true })
hl.bind(modalt .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = res_step, relative = true }), { repeating = true })

local workspace_map = {
	{ key = "a", ws = "1" },
	{ key = "s", ws = "2" },
	{ key = "d", ws = "3" },
	{ key = "f", ws = "4" },
	{ key = "q", ws = "5" },
	{ key = "w", ws = "6" },
	{ key = "e", ws = "7" },
	{ key = "r", ws = "8" },
	{ key = "z", ws = "9" },
	{ key = "x", ws = "10" },
	{ key = "c", ws = "11" },
	{ key = "v", ws = "12" },
}

for _, entry in ipairs(workspace_map) do
	hl.bind(alt .. " + " .. entry.key, hl.dsp.focus({ workspace = "name:" .. entry.ws }))
	hl.bind(mod .. " + " .. alt .. " + " .. entry.key, hl.dsp.window.move({ workspace = "name:" .. entry.ws }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
